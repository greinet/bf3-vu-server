FROM ubuntu:eoan

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y install xvfb x11vnc xdotool wget tar supervisor net-tools fluxbox gnupg2
RUN wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
RUN echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ eoan main' |tee /etc/apt/sources.list.d/winehq.list

WORKDIR /tmp
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key
RUN apt-key add Release.key
RUN apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'


RUN apt-get update && apt-get -y install winehq-stable
RUN mkdir /opt/wine-stable/share/wine/mono && wget -O - https://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-bin-4.9.4.tar.gz |tar -xzv -C /opt/wine-stable/share/wine/mono 
RUN mkdir /opt/wine-stable/share/wine/gecko && wget -O /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.1-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi && wget -O /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.1-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86_64.msi 
RUN apt-get -y full-upgrade && apt-get clean
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV WINEPREFIX /root/prefix32
ENV WINARCH win32 wine wineboot
ENV DISPLAY :0

RUN apt-get install -y winbind

RUN apt install -y xvfb unzip
WORKDIR /tmp
RUN wget -nc https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe
RUN xvfb-run wine /tmp/vcredist_x86.exe /q

RUN mkdir -p /root/bf3/vu/client

WORKDIR /root/bf3/vu/client
RUN wget https://veniceunleashed.net/files/vu.zip
RUN unzip vu.zip
RUN rm vu.zip

WORKDIR /root/
RUN wget -O - https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.1.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html
RUN wget -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.9.0 /root/novnc/utils/websockify

WORKDIR /root/bf3/vu/
RUN mkdir instance
VOLUME /root/bf3/vu/instance

WORKDIR /root/bf3
RUN mkdir -p gamedata/bf3
VOLUME /root/bf3/gamedata/bf3


RUN mkdir -p /root/prefix32/drive_c/ProgramData/Electronic Arts/EA Services/License
VOLUME /root/prefix32/drive_c/ProgramData/Electronic Arts/EA Services/License

EXPOSE 8080
EXPOSE 7948
EXPOSE 25200
EXPOSE 47200


WORKDIR /root/bf3/
CMD ["/usr/bin/supervisord"]
