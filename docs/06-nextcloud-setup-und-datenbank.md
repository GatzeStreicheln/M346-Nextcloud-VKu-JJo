# Nextcloud Setup-Wizard und Datenbank-Konfiguration

Nach der Installation des Nextcloud-Servers wurde die Datenbank-Verbindung konfiguriert und der Setup-Wizard durchgeführt.

## Vorbereitung: MariaDB-Konfiguration auf NextcloudDB

### bind-address Änderung
Die Datei /etc/mysql/mariadb.conf.d/50-server.cnf wurde geändert:
- Änderung: bind-address = 127.0.0.1 → bind-address = 0.0.0.0
- Grund: MariaDB muss auf externen Verbindungen lauschen

sudo systemctl restart mariadb

### Security Group Konfiguration
AWS EC2 Security Group der NextcloudDB-Instanz:
- Port 3306 (MySQL/MariaDB) freigegeben
- Source: Nextcloud-Instanz IP (44.222.194.210/32)

### Datenbank-User Vorbereitung
Auf NextcloudDB wurden folgende SQL-Befehle ausgeführt:

sudo mariadb -u root -p

SQL-Befehle:
DROP USER 'nextclouduser'@'%';
CREATE USER 'nextclouduser'@'%' IDENTIFIED BY 'jucbB6MPMWCzth';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextclouduser'@'%';
FLUSH PRIVILEGES;

## Datenbank-Verbindungstests

### Test von der Nextcloud-Instanz
ubuntu@ip-172-31-65-118:/tmp$ mysql -h 172.31.78.193 -u nextclouduser -p nextcloud

Passwort: jucbB6MPMWCzth

Test erfolgreich: MySQL-Prompt erreichbar

## Nextcloud Setup-Wizard (Browser)

URL: http://44.222.194.210

### Admin-Account erstellen
- Benutzername: admin
- Passwort: NK67MxmPj7f9L4

### Datenbank-Konfiguration
- Datenbanktyp: MySQL/MariaDB
- Datenbank-Benutzer: nextclouduser
- Datenbank-Passwort: jucbB6MPMWCzth
- Datenbank-Name: nextcloud
- Datenbank-Host: 172.31.78.193:3306

### Installation abgeschlossen
Nach dem Klick auf "Installation abschliessen" wurde Nextcloud vollständig eingerichtet.
Die Datenbank-Verbindung zur MariaDB-Instanz auf NextcloudDB funktioniert einwandfrei.

Nextcloud ist jetzt unter http://44.222.194.210 vollständig funktionsfähig.


