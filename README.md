## Schild im Browser
Schild als Docker-Lösung im Browser. Damit ist Schild unabhängig von
einer Windowsinstallation und kann überall aus dem Intranet aufgerufen
werden. Oder für Linux-Nutzer, die keine Lust haben, wine und
Abhängigkeiten zu installieren.

### Einrichtung
Es wird Docker als Grundlage benötigt. Bitte, wenn noch nicht vorhanden,
installieren. Es bietet sich an, den Anweisungen unter
[https://docs.docker.com/engine/installation](https://docs.docker.com/engine/installation)
zu folgen und dementsprechend zu installieren. Tipp: ganz unten ist ein
Einzeiler, um alles in einem Abwasch zu installieren.

Anschließend kann der Schild-Container im Terminal so gestartet werden:

    sudo docker run -p 8080:8080 --name schild hmtx/schild-docker:latest

Damit wird der Container gestartet und beim ersten Durchlauf das
Installationsscript von Schild gestartet. Dabei wird die Datenbank
eingerichtet. Damit Schild die passende Datenbank findet (es wird nur
MySQL unterstützt), müssen die folgenden Umgebungsvariablen gesetzt
werden:

SERVER
DATENBANK
BENUTZER
PASSWORT

Das kann man z.B. direkt beim Start Docker mit auf den Weg geben:

    sudo docker run -p 8080:8080 --name schild \
      -e SERVER 192.168.178.100 \
      -e DATENBANK schild-db \
      -e BENUTZER schildnutzer \
      -e PASSWORT geheim \
      hmtx/schild-docker:latest

### Schild nutzen

Nun kann man im Browser auf Schild zugreifen, dazu die Adresse des Hosts
aufrufen, z.B. [http://localhost:8080/vnc.html](http://localhost:8080/vnc.html)

### bleibende Datenspeicherung
Diese Lösung bietet noch keine bleibende Speicherung der Daten, Schild
wird bei jedem Start neu aufgesetzt. So kann man natürlich nicht
dauerhaft arbeiten.

Es macht Sinn, zwei Volumes einzurichten, einmal für Schild selber,
damit Updates eingespielt werden können und z.B. Reports angelegt werden
können. Ebenso sollten die prefix-Einstellungen sicher gespeichert
bleiben.

### Dieser Container läuft unter:

* FlexBox – ein einfacher Windowmanager
* x11vnc - Ein VNC-Server
* [noNVC](https://kanaka.github.io/noVNC/) - Ein HTML5 canvas vnc viewer

basiert auf dem Dockerfile von [https://github.com/solarkennedy/wine-x11-novnc-docker](https://github.com/solarkennedy/wine-x11-novnc-docker)
