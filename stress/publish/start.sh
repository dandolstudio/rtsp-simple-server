#!/bin/sh -e

PUBLISHER_COUNT=10
PUBLISHER_PROTOCOL=tcp

#####################################################
# publishers

CONF=""
CONF="${CONF}pprof: yes\n"
echo -e "$CONF" > /source.conf

/rtsp-simple-server /source.conf &

sleep 1

for i in $(seq 1 $PUBLISHER_COUNT); do
    ffmpeg -hide_banner -loglevel error \
    -re -stream_loop -1 -i /video.mkv -c copy -f rtsp \
    -rtsp_transport $PUBLISHER_PROTOCOL rtsp://localhost:8554/source$i &
done

wait
