# MariaDB-Installation auf NextcloudDB

Auf der NextcloudDB-Instanz habe ich MariaDB als Datenbank-Backend fuer Nextcloud installiert.

## Installation
sudo apt update && sudo apt upgrade -y
sudo apt install mariadb-server -y

## Service starten und aktivieren
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb

## MariaDB absichern
sudo mysql_secure_installation

Dabei wurden folgende Optionen gewaehlt:
- Root-Passwort gesetzt mit starkem passwort
- Anonymous User entfernt
- Remote Root Login deaktiviert
- Test-Datenbank geloescht
- Privilegien neu geladen

## Datenbank fuer Nextcloud erstellen
sudo mariadb -u root -p

Im MariaDB-Prompt:

CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'nextclouduser'@'%' IDENTIFIED BY 'jucbB6MPMWCzth';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextclouduser'@'%';
FLUSH PRIVILEGES;
EXIT;

Datenbank-Details:
- Datenbank: nextcloud
- User: nextclouduser
- Passwort: jucbB6MPMWCzth

MariaDB ist jetzt bereit fuer Nextcloud.
