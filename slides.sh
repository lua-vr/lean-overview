#!/usr/bin/env bash
cleanup() { kill "$SERVER_PID" 2>/dev/null || true; }
trap cleanup EXIT

mkdir -p _slides
(cd _slides && exec uvx reloadserver -w >/dev/null 2>&1) &
SERVER_PID=$!

lake exe generate-slides;

while inotifywait -r --exclude "_slides/|.lake/|.git/|.jj/" -e close_write .; do
    lake exe generate-slides;
    curl -X POST localhost:8000/api-reloadserver/trigger-reload;
done
