FROM ubuntu:14.04

MAINTAINER Andrius Kairiukstis <andrius@kairiukstis.com>

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i "s/# deb http/deb http/g" /etc/apt/sources.list \
&&  sed -i "s/# deb-src http/deb-src http/g" /etc/apt/sources.list \
&&  echo "APT::Install-Recommends "false";" > /etc/apt/apt.conf \
&&  echo "APT::Install-Suggests "false";" >> /etc/apt/apt.conf \

&&  apt-get update \
&&  apt-get --yes autoremove \

&&  apt-get --yes install aptitude gdb strace autoconf automake binutils-dev bison build-essential ca-certificates curl doxygen espeak flex freetds-dev ghostscript git git-core libasound2-dev libc6-dev libcorosync-dev libcurl4-openssl-dev libedit-dev libespeak-dev libffi-dev libgdbm-dev libgsm1-dev libical-dev libiksemel-dev libjansson-dev libmagic-dev libmyodbc libmysqlclient-dev libncurses-dev libncurses5-dev libneon27-dev libnewt-dev libogg-dev libpcap-dev libpcre3-dev libpopt-dev libpq-dev libreadline-dev libreadline6 libsamplerate0-dev libsndfile1-dev libsnmp-dev libspandsp-dev libspeexdsp1 libspeex-dev libspeexdsp-dev libsqlite0-dev libsqlite3-dev libsrtp0 libsrtp0-dev libssl-dev libtiff-dev libtiff-tools libtool libusb-dev libvorbis-dev libxml2-dev libxslt-dev libxslt1-dev libyaml-dev mc minicom mpg123 ngrep odbcinst openssl pkg-config rsync screen sox sqlite3 ssl-cert subversion sudo tmux tree unixodbc unixodbc-bin unixodbc-dev unzip usbutils uuid uuid-dev vim w3m wget whois zlib1g zlib1g-dev libav-tools \

&&  ln -s /usr/bin/avconv /usr/bin/ffmpeg > /dev/null 2>&1 \

&&  rm /bin/sh && ln -s /bin/bash /bin/sh \

&&  apt-get --yes autoremove \
&&  apt-get clean all \
&&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/src/asterisk

RUN ASTERISK_VERSION=asterisk-12.8.0 \
&&  SRC_DIR=/usr/src/asterisk \

&&  mkdir -p ${SRC_DIR} \
&&  cd ${SRC_DIR} \
&&  wget --quiet --continue http://downloads.asterisk.org/pub/telephony/asterisk/releases/${ASTERISK_VERSION}.tar.gz \
&&  wget --quiet --continue http://www.pjsip.org/release/2.2.1/pjproject-2.2.1.tar.bz2 \
&&  wget --quiet --continue http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz \
&&  git clone https://github.com/andrius/asterisk-opus.git \

&&  tar -xjf pjproject-2.2.1.tar.bz2 \
&&  tar -zxf ${ASTERISK_VERSION}.tar.gz \
&&  tar -zxf opus-1.1.tar.gz \

&&  cd pjproject-2.2.1 \
&&  ./configure --prefix=/usr --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr \
&&  make dep \
&&  make \
&&  make install \
&&  ldconfig \

&&  cd ${SRC_DIR}/opus-1.1 \
&&  ./configure --prefix=/usr \
&&  make all \
&&  make install \
&&  ldconfig \

&&  cd ${SRC_DIR}/${ASTERISK_VERSION} \
&&  patch --strip 1 < ../asterisk-opus/asterisk-12.2-5_opus.patch \
&&  ./contrib/scripts/install_prereq install \
&&  ./contrib/scripts/install_prereq install-unpackaged \
&&  ldconfig \
&&  ./bootstrap.sh \
&&  ./configure --with-crypto --with-ssl --with-srtp \
&&  make menuselect.makeopts \
&&  menuselect/menuselect --disable BUILD_NATIVE --enable DONT_OPTIMIZE --enable BETTER_BACKTRACES --enable CORE-SOUNDS-EN-WAV --enable CORE-SOUNDS-EN-SLN16 --enable MOH-OPSOUND-WAV --enable MOH-OPSOUND-SLN16 menuselect.makeopts \
&&  make all \
&&  make install \
&&  make samples \
&&  make config \
&&  make install-logrotate \
&&  ldconfig \
&&  cp -R ./contrib/scripts/astcli /usr/local/bin/ \
&&  update-rc.d asterisk defaults \
&&  mkdir -p /var/spool/asterisk/fax \
&&  mkdir -p /var/punchblock/record \
&&  sed -i "s/; t38pt_udptl = yes,redundancy/t38pt_udptl = yes,redundancy  /g" /etc/asterisk/sip.conf \
&&  sed -i "s/; faxdetect = yes/faxdetect = yes  /g" /etc/asterisk/sip.conf \

&&  rm -rf /usr/src/asterisk/* \
&&  apt-get --yes autoremove \
&&  apt-get clean all \
&&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD run.sh /run.sh
CMD ["/run.sh"]

# Run with:
#
#    dk run -ti --rm --net=host -v `pwd`/etc_asterisk:/etc/asterisk -v `pwd`/voicemail:/var/spool/asterisk/voicemail -v `pwd`/monitor:/var/spool/asterisk/monitor -v `pwd`/run:/var/run/asterisk asterisk /etc/init.d/asterisk start
#
#    -v `pwd`/voicemail:/var/spool/asterisk/voicemail -v `pwd`/monitor:/var/spool/asterisk/monitor -v `pwd`/run:/var/run/asterisk
#    --net=host to listen to all ports on the machine
