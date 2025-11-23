# Tests und Testprotokoll

Alle Tests wurden am 22. November 2025 um 16:39 Uhr durchgeführt.
Testperson: Jan Josuran

## Test 1: Nextcloud Webzugriff
**Testziel:** Nextcloud ist über Browser erreichbar
**Durchführung:** Browser geöffnet mit URL http://44.222.194.210
**Ergebnis:** ERFOLGREICH - Nextcloud Dashboard wird angezeigt
**Screenshot:** test-01-webzugriff.png

(../screenshots/test-01-webzugriff.png)
## Test 2: Login funktioniert
**Testziel:** Login-Funktionalität pruefen
**Durchführung:** Logout durchgefuehrt, dann Login mit admin/admin
**Ergebnis:** ERFOLGREICH - Login funktioniert einwandfrei
**Screenshot:** test-02-login.png

## Test 3: Datei hochladen
**Testziel:** Datei-Upload und Anzeige in Nextcloud
**Durchführung:** Testdatei test.txt hochgeladen
**Ergebnis:** ERFOLGREICH - Datei erscheint in der Dateiliste
**Screenshot:** test-03-datei-upload.png

## Test 4: Datenbank-Verbindung
**Testziel:** Verbindung zwischen Nextcloud und MariaDB prüfen
**Durchführung:** mysql -h 172.31.78.193 -u nextclouduser -p nextcloud
**Ergebnis:** ERFOLGREICH - Verbindung funktioniert, Tabellen sichtbar
**Screenshot:** test-04-datenbank.png

## Test 5: Apache Webserver Status
**Testziel:** Apache läuft auf Nextcloud-Instanz
**Durchführung:** sudo systemctl status apache2
**Ergebnis:** ERFOLGREICH - apache2 is active (running)
**Screenshot:** test-05-apache-status.png

## Test 6: MariaDB Status
**Testziel:** MariaDB läuft auf NextcloudDB-Instanz
**Durchführung:** sudo systemctl status mariadb
**Ergebnis:** ERFOLGREICH - mariadb is active (running)
**Screenshot:** test-06-mariadb-status.png

## Fazit
Alle 6 Tests wurden erfolgreich durchgeführt.
Die Nextcloud-Installation ist vollständig funktionsfähig:
- Webserver läuft stabil
- Datenbank-Verbindung funktioniert
- Datei-Upload und -Verwaltung funktionieren
- Login-System funktioniert

Keine Fehler oder Probleme festgestellt.
