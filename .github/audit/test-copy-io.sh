#!/bin/bash
set -euo pipefail

export DISPLAY=:99
export XDG_CONFIG_HOME=/tmp/spacefm-test-config
rm -rf "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CONFIG_HOME"

Xvfb :99 -screen 0 1024x768x24 >/tmp/xvfb.log 2>&1 &
xvfb_pid=$!
trap 'kill "$xvfb_pid" 2>/dev/null || true; pkill -x spacefm 2>/dev/null || true' EXIT

wait_for_socket()
{
    local i
    for i in $(seq 1 50); do
        if ./src/spacefm -s get window_size >/tmp/socket-ready.log 2>&1; then
            return 0
        fi
        sleep 0.2
    done
    return 1
}

stop_spacefm()
{
    pkill -x spacefm 2>/dev/null || true
    sleep 0.5
}

# A short write is a successful partial write, not a complete buffer write.
# Force every destination write to consume only half the requested bytes.
src_dir=/tmp/spacefm-copy-src
dest_dir=/dev/shm/spacefm-copy-dest
src="$src_dir/blob.bin"
dest="$dest_dir/blob.bin"
rm -rf "$src_dir" "$dest_dir"
mkdir -p "$src_dir" "$dest_dir"
dd if=/dev/urandom of="$src" bs=1M count=4 status=none

env \
    LD_PRELOAD="$PWD/.github/audit/libspacefm-iofault.so" \
    SPACEFM_SHORT_WRITE_TARGET="$dest" \
    ./src/spacefm "$src_dir" >/tmp/spacefm-short-write.log 2>&1 &
wait_for_socket
./src/spacefm -s run-task copy "$src" "$dest_dir"

src_size=$(stat -c %s "$src")
for i in $(seq 1 150); do
    if test -f "$dest" && test "$(stat -c %s "$dest")" -eq "$src_size"; then
        break
    fi
    sleep 0.1
done

test "$(stat -c %s "$dest")" -eq "$src_size"
cmp "$src" "$dest"
stop_spacefm

# A read error must fail the task, preserve the source, and remove the partial
# destination rather than being mistaken for EOF.
src_dir=/tmp/spacefm-read-src
dest_dir=/dev/shm/spacefm-read-dest
src="$src_dir/blob.bin"
dest="$dest_dir/blob.bin"
rm -rf "$src_dir" "$dest_dir"
mkdir -p "$src_dir" "$dest_dir"
dd if=/dev/urandom of="$src" bs=1M count=4 status=none

env \
    LD_PRELOAD="$PWD/.github/audit/libspacefm-iofault.so" \
    SPACEFM_READ_ERROR_SOURCE="$src" \
    SPACEFM_READ_ERROR_AFTER=8192 \
    ./src/spacefm "$src_dir" >/tmp/spacefm-read-error.log 2>&1 &
wait_for_socket
./src/spacefm -s run-task copy "$src" "$dest_dir"
sleep 3

test -f "$src"
test ! -e "$dest"
stop_spacefm

echo 'PASS: partial writes and read errors are handled safely'
