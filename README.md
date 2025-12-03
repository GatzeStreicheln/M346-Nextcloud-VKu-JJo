# Nextcloud Installation auf AWS EC2

Projekt von Vasco Kugler und Jan Josuran  
Modul 346 - Cloudlösungen konzipieren und realisieren  
Gewerbliches Berufs- und Weiterbildungszentrum St.Gallen  

## Projektübersicht

Wir haben Nextcloud auf zwei separaten AWS EC2-Instanzen installiert. Eine Instanz läuft mit Apache Webserver und PHP, die andere ist ein MariaDB Datenbank-Server. So können wir die Datenbank getrennt vom Webserver betreiben.

Die Installation funktioniert vollautomatisch über Cloud-Init Skripte. Man kann aber auch alles manuell Schritt für Schritt machen, wenn man verstehen will, was gerade passiert.

## Wie man das Ganze startet

Zuerst brauchst du einen AWS Account. Dann gehst du auf EC2 und erstellst zwei neue Instanzen.

Bei der ersten Instanz (NextcloudDB) wählst du Ubuntu 24.04 LTS, t3.medium Instance Type und machst eine neue Security Group, die den SSH Port 22 und den MySQL Port 3306 erlaubt. Das wichtigste ist, dass du bei den Advanced Details die User Data nimmst und da den Inhalt von `cloud-init-nextclouddb.yml` reinkopierst. Das installiert dann automatisch MariaDB und konfiguriert alles.

Bei der zweiten Instanz (Nextcloud) machst du das gleiche, nur dass du da die Ports 22 und 80 öffnest. Und in der User Data kommt der Inhalt von `cloud-init-nextcloud.yml` rein. Das installiert Apache, PHP und Nextcloud automatisch.

Nach ungefähr 5 Minuten sind beide Instanzen ready. Dann schreibst du dir die öffentlichen IP-Adressen auf. Bei mir war das 44.222.194.210 für Nextcloud und 98.93.91.87 für die Datenbank.

Dann öffnest du einen Browser und gehst auf http://44.222.194.210 (oder deine Nextcloud-IP). Dort siehst du einen Setup-Wizard. Da musst du eingeben:
- Admin-Benutzername: admin
- Admin-Passwort: NK67MxmPj7f9L4
- Datenbank: MySQL/MariaDB
- Datenbankbenutzer: nextclouduser
- Datenbankpasswort: jucbB6MPMWCzth
- Datenbankname: nextcloud
- Datenbank-Host: 98.93.91.87:3306 (deine NextcloudDB-IP)

Dann klickst du auf "Installation abschließen" und nach 1-2 Minuten ist Nextcloud fertig und du kannst dich einloggen.

Wenn du alles manuell machen willst statt Cloud-Init, findest du die ausführliche Anleitung in den Dokumentations-Dateien im `docs/` Verzeichnis. Da sind alle Befehle Schritt für Schritt aufgelistet.

## Was wir alles dokumentiert haben

Im `docs/` Verzeichnis sind zehn Markdown-Dateien:
- 01 bis 06 beschreiben die Installation, von AWS Setup bis zur Datenbank-Konfiguration
- 07 ist ein Testprotokoll, wo wir alles durchgetestet haben
- 08 erklärt wie die Cloud-Init Automatisierung funktioniert
- 09 ist unsere Reflexion zum Projekt

Im `screenshots/` Verzeichnis sind alle Screenshots von den wichtigen Stellen.

## Was genau läuft da

Die Nextcloud-Instanz hat Ubuntu 24.04 LTS, Apache 2.4 als Webserver, PHP 8.3 und Nextcloud Version 32.0.2. Die läuft unter der IP 44.222.194.210.

Die NextcloudDB-Instanz hat auch Ubuntu 24.04 LTS, aber dafür MariaDB 10.11 als Datenbank. Das läuft unter der IP 98.93.91.87. Die Security Groups erlauben SSH auf Port 22 und MySQL auf Port 3306 für die Datenbank.

## Tests

Wir haben alles getestet. Nextcloud war im Browser erreichbar, Login hat geklappt, Dateien hochladen funktioniert, die Datenbank-Verbindung war stabil, Apache läuft und MariaDB läuft auch. Alle Tests waren erfolgreich. Das Testprotokoll steht in docs/07-tests.md.

## Automatisierung mit Cloud-Init

Die Cloud-Init Skripte machen bei NextcloudDB die ganze MariaDB Installation, stellen sicher dass die Datenbank von außen erreichbar ist, erstellen die Datenbank und den Benutzer. Bei Nextcloud installiert es Apache und PHP mit allen Modulen, lädt Nextcloud runter, entpackt es, setzt die richtigen Berechtigungen und konfiguriert den Apache VirtualHost.

## Was noch nicht ideal ist

Die Installation ist für die Schule gemacht, nicht für Production. In einer echten Installation würde man HTTPS machen, bessere Passwörter nehmen, die Instanzen nicht offen ins Internet stellen sondern in einer VPC mit privaten Subnets. Backups und Monitoring würde man auch noch einbauen. Das alles ist in unserer Reflexion ausführlicher beschrieben.

## Autoren

Vasco Kugler und Jan Josuran

Modul 346 - Cloudlösungen konzipieren und realisieren  
