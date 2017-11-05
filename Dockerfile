FROM phusion/baseimage:0.9.22
MAINTAINER hmtx

# Set correct environment variables
ENV HOME /root
ENV LC_ALL C.UTF-8
ENV WINEPREFIX /root/prefix32
ENV WINEARCH win32
ENV DISPLAY :0

WORKDIR /root/

# Expose Port
EXPOSE 8080

CMD ["/usr/bin/supervisord"]

# Configure user nobody to match unRAID's settings
RUN \
    usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /config nobody && \
    chown -R nobody:users /home

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt-get install -y \
      xvfb \
      x11vnc \
      xdotool \
      wget \
      supervisor \
      net-tools \
      fluxbox \
      cabextract \
      git && \
    wget -nc https://dl.winehq.org/wine-builds/Release.key && \
    apt-key add Release.key && \
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/ &&\
    apt-get update && apt-get install -y --install-recommends winehq-stable && \
    wget http://winetricks.org/winetricks -O /usr/bin/winetricks && \
    chmod +x /usr/bin/winetricks && \
    wget https://dev.mysql.com/get/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.9-win32.msi && \
    wget https://www.svws.nrw.de/uploads/media/SchILDBasisSetup.exe && \
    git clone https://github.com/novnc/noVNC.git /root/novnc

RUN wget https://www.svws.nrw.de/fileadmin/user_upload/Schild-NRW/schildupdate_2_0_17_05.exe

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD installer.sh .

# hier müssen die eigenen Datenbankeinstellungen eingetragen werden:
# Server: Adresse der MySQL-Datenbank im Netz
# Datenbank: Name der Datenbank von Schild
# Benutzer: Datenbankbenutzer
# Passwort: Passwort des Datenbankbenutzers
ENV SERVER 192.168.178.32
ENV DATENBANK schild_berufskolleg
ENV BENUTZER schild
ENV PASSWORT schild
