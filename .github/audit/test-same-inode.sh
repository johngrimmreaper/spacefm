#!/bin/bash
set -euo pipefail

export DISPLAY=:99
export XDG_CONFIG_HOME=/tmp/spacefm-same-inode-config
rm -rf "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CONFIG_HOME"

Xvfb :99 -screen 0 1024x768x24 >/tmp/xvfb-same-inode.log 2>&1 &
xvfb_pid=$!
trap 'kill "$xvfb_pid" 2>/dev/null || true; pkill -x spacefm 2>/dev/null || true' EXIT

src_dir=/tmp/spacefm-hardlink-src
dst_dir=/tmp/spacefm-hardlink-dst
src="$src_dir/myfile"
dst="$dst_dir/myfile"
rm -rf "$src_dir" "$dst_dir"
mkdir -p "$src_dir" "$dst_dir"
printf 'SpaceFM same-inode regression payload\n' > "$src"
ln "$src" "$dst"

before_inode=$(stat -c %i "$src")
before_size=$(stat -c %s "$src")
before_links=$(stat -c %h "$src")

test "$before_inode" = "$(stat -c %i "$dst")"
test "$before_links" -eq 2

after_start=0
./src/spacefm "$src_dir" >/tmp/spacefm-same-inode.log 2>&1 &
for i in $(seq 1 50); do
    if ./src/spacefm -s get window_size >/tmp/socket-same-inode.log 2>&1; then
        after_start=1
        break
    fi
    sleep 0.2
done
test "$after_start" -eq 1

./src/spacefm -s run-task copy "$src" "$dst_dir"

# The existing UI asks for confirmation. Choose Overwrite deliberately; the
# candidate fix must still refuse to truncate an alias of the same inode.
for i in $(seq 1 50); do
    if xdotool search --name 'File Exists\|Overwrite\|Replace' >/tmp/dialog-windows.log 2>/dev/null; then
        break
    fi
    sleep 0.2
done
xdotool key --clearmodifiers alt+o
sleep 2

test -f "$src"
test -f "$dst"
test "$(stat -c %i "$src")" = "$before_inode"
test "$(stat -c %i "$dst")" = "$before_inode"
test "$(stat -c %s "$src")" -eq "$before_size"
test "$(stat -c %s "$dst")" -eq "$before_size"
test "$(stat -c %h "$src")" -eq 2
cmp "$src" "$dst"

echo 'PASS: overwrite of a same-inode hard link is rejected safely'
