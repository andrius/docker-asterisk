#!/bin/sh

docker run -ti --rm --name="asterisk12" --net=host \
  -v `pwd`/etc_asterisk:/etc/asterisk \
  -v `pwd`/voicemail:/var/spool/asterisk/voicemail \
  -v `pwd`/spool:/var/spool/asterisk \
  -v `pwd`/run:/var/run/asterisk \
  andrius/asterisk12_webrtc
