FROM ubuntu:14.04

MAINTAINER Andrius Kairiukstis <andrius@kairiukstis.com>

RUN sed -i "s/# deb http/deb http/g" /etc/apt/sources.list
RUN sed -i "s/# deb-src http/deb-src http/g" /etc/apt/sources.list
RUN echo "APT::Install-Recommends "false";" > /etc/apt/apt.conf
RUN echo "APT::Install-Suggests "false";" >> /etc/apt/apt.conf

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes autoremove
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install aptitude gdb strace autoconf automake binutils-dev bison build-essential ca-certificates curl doxygen espeak flex freetds-dev ghostscript git git-core libasound2-dev libc6-dev libcorosync-dev libcurl4-openssl-dev libedit-dev libespeak-dev libffi-dev libgdbm-dev libgsm1-dev libical-dev libiksemel-dev libjansson-dev libmagic-dev libncurses-dev libncurses5-dev libneon27-dev libnewt-dev libogg-dev libpcap-dev libpcre3-dev libpopt-dev libpq-dev libreadline-dev libreadline6 libsamplerate0-dev libsndfile1-dev libsnmp-dev libspandsp-dev libspeexdsp1 libspeex-dev libspeexdsp-dev libsqlite0-dev libsqlite3-dev libsrtp0 libsrtp0-dev libssl-dev libtiff-dev libtiff-tools libtool libusb-dev libvorbis-dev libxml2-dev libxslt-dev libxslt1-dev libyaml-dev mc minicom mpg123 ngrep openssl pkg-config rsync screen sox sqlite3 ssl-cert subversion sudo tmux tree unzip usbutils uuid uuid-dev vim w3m wget whois zlib1g zlib1g-dev libav-tools

RUN DEBIAN_FRONTEND=noninteractive apt-get --yes install linux-headers-`uname -r`

RUN ln -s /usr/bin/avconv /usr/bin/ffmpeg > /dev/null 2>&1

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN mkdir -p /usr/src/asterisk

WORKDIR /usr/src/asterisk

RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-13.0.1.tar.gz
RUN wget http://www.pjsip.org/release/2.2.1/pjproject-2.2.1.tar.bz2

RUN tar -xjvf pjproject-2.2.1.tar.bz2
RUN cd pjproject-2.2.1 && \
    ./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr && \
    make dep && \
    make && \
    make install && \
    ldconfig

RUN tar -zxvf asterisk-13.0.1.tar.gz

RUN asterisk-13.0.1/contrib/scripts/install_prereq install

WORKDIR /usr/src/asterisk/asterisk-13.0.1

RUN ./contrib/scripts/get_ilbc_source.sh; ./contrib/scripts/get_mp3_source.sh; ./contrib/scripts/get_swagger_ui.sh; echo 1
RUN ./contrib/scripts/install_prereq install-unpackaged
RUN ldconfig
RUN ./bootstrap.sh
RUN ./configure --with-crypto --with-ssl --with-srtp
RUN make menuselect.makeopts
RUN menuselect/menuselect --disable BUILD_NATIVE --enable DONT_OPTIMIZE --enable BETTER_BACKTRACES --enable CORE-SOUNDS-EN-WAV --enable CORE-SOUNDS-EN-G729 --enable CORE-SOUNDS-EN-G722 --enable CORE-SOUNDS-EN-SLN16 --enable CORE-SOUNDS-EN_AU-WAV --enable CORE-SOUNDS-EN_AU-G729 --enable CORE-SOUNDS-EN_AU-G722 --enable CORE-SOUNDS-EN_AU-SLN16 --enable CORE-SOUNDS-EN_GB-WAV --enable CORE-SOUNDS-EN_GB-G729 --enable CORE-SOUNDS-EN_GB-G722 --enable CORE-SOUNDS-EN_GB-SLN16 --enable CORE-SOUNDS-ES-WAV --enable CORE-SOUNDS-ES-G729 --enable CORE-SOUNDS-ES-G722 --enable CORE-SOUNDS-ES-SLN16 --enable CORE-SOUNDS-FR-WAV --enable CORE-SOUNDS-FR-G729 --enable CORE-SOUNDS-FR-G722 --enable CORE-SOUNDS-FR-SLN16 --enable CORE-SOUNDS-IT-WAV --enable CORE-SOUNDS-IT-G729 --enable CORE-SOUNDS-IT-G722 --enable CORE-SOUNDS-IT-SLN16 --enable CORE-SOUNDS-RU-WAV --enable CORE-SOUNDS-RU-G729 --enable CORE-SOUNDS-RU-G722 --enable CORE-SOUNDS-RU-SLN16 --enable CORE-SOUNDS-JA-WAV --enable CORE-SOUNDS-JA-G729 --enable CORE-SOUNDS-JA-G722 --enable CORE-SOUNDS-JA-SLN16 --enable MOH-OPSOUND-WAV --enable MOH-OPSOUND-ULAW --enable MOH-OPSOUND-ALAW --enable MOH-OPSOUND-GSM --enable MOH-OPSOUND-G729 --enable MOH-OPSOUND-G722 --enable MOH-OPSOUND-SLN16 --enable EXTRA-SOUNDS-EN-WAV --enable EXTRA-SOUNDS-EN-G729 --enable EXTRA-SOUNDS-EN-G722 --enable EXTRA-SOUNDS-EN-SLN16 --enable EXTRA-SOUNDS-EN_GB-WAV --enable EXTRA-SOUNDS-EN_GB-G729 --enable EXTRA-SOUNDS-EN_GB-G722 --enable EXTRA-SOUNDS-EN_GB-SLN16 --enable EXTRA-SOUNDS-FR-WAV --enable EXTRA-SOUNDS-FR-G729 --enable EXTRA-SOUNDS-FR-G722 --enable EXTRA-SOUNDS-FR-SLN16 menuselect.makeopts
RUN make
RUN make install
RUN make samples
RUN make config
RUN make install-logrotate
RUN ldconfig
RUN cp -R ./contrib/scripts/astcli /usr/local/bin/
RUN update-rc.d asterisk defaults
RUN mkdir -p /var/spool/asterisk/fax
RUN mkdir -p /var/punchblock/record 
RUN sed -i "s/; t38pt_udptl = yes,redundancy/t38pt_udptl = yes,redundancy  /g" /etc/asterisk/sip.conf
RUN sed -i "s/; faxdetect = yes/faxdetect = yes  /g" /etc/asterisk/sip.conf
# RUN sed -i "s/console => notice,warning,error/console => notice,warning,error,fax/g" /etc/asterisk/logger.conf

# Cleanup stuff
RUN rm -rf /usr/src/asterisk/*
RUN DEBIAN_FRONTEND=noninteractive apt-get --yes clean all

ADD run.sh /run.sh
CMD ["/run.sh"]

# Run with:
#
#    dk run -ti --rm --net=host -v `pwd`/etc_asterisk:/etc/asterisk -v `pwd`/voicemail:/var/spool/asterisk/voicemail -v `pwd`/monitor:/var/spool/asterisk/monitor -v `pwd`/run:/var/run/asterisk asterisk /etc/init.d/asterisk start
#
#    -v `pwd`/voicemail:/var/spool/asterisk/voicemail -v `pwd`/monitor:/var/spool/asterisk/monitor -v `pwd`/run:/var/run/asterisk
#    --net=host to listen to all ports on the machine