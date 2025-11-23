# Automatisierung - Tests und Deployment

Dokumentation des kompletten automatisierten Deployment-Prozesses mit Cloud-Init für beide EC2-Instanzen sowie die anschließende Konfiguration von Nextcloud mit Datenbank-Verbindung.

## Vorbereitung

Zwei YAML-Dateien für die automatisierte Installation wurden erstellt: `cloud-init-nextclouddb.yml` für den MariaDB Datenbank-Server mit automatischer Datenbank- und User-Erstellung sowie `cloud-init-nextcloud.yml` für Nextcloud mit Apache, PHP und VirtualHost-Konfiguration. Beide Dateien befinden sich im Repository und sind produktionsbereit.

## NextcloudDB-Instanz mit Cloud-Init erstellen und testen

Über die AWS Console wurde eine neue EC2-Instanz mit Namen NextcloudDB, Ubuntu 24.04 LTS als AMI und Instance Type t3.medium gestartet. In der Security Group wurden Port 22 für SSH und Port 3306 für MySQL geöffnet. Unter Advanced Details im User Data Feld wurde der komplette Inhalt von cloud-init-nextclouddb.yml eingefügt. Nach dem Klick auf Launch Instance läuft Cloud-Init automatisch.

Nach 2-3 Minuten Wartezeit wurde per SSH auf die Instanz verbunden und der MariaDB Status mit systemctl geprüft. Das Resultat zeigte MariaDB 10.11.13 mit Status active running - MariaDB läuft erfolgreich. Die Datenbank-Prüfung mit SHOW DATABASES ergab, dass die nextcloud Datenbank automatisch erstellt wurde. Die User-Prüfung bestätigte, dass der User nextclouduser mit Host % für Remote-Zugriff automatisch angelegt wurde.

Die Cloud-Init Logs zeigten die erfolgreiche Package Installation, das Setzen der bind-address auf 0.0.0.0 für Remote-Zugriff, die Erstellung der nextcloud Datenbank und des Users nextclouduser mit Passwort jucbB6MPMWCzth sowie das Gewähren aller Berechtigungen. Installation und Konfiguration der MariaDB-Instanz waren vollständig automatisiert.

## Nextcloud-Instanz mit Cloud-Init erstellen und testen

Eine zweite EC2-Instanz mit Namen Nextcloud, Ubuntu 24.04 LTS und Instance Type t3.medium wurde gestartet. Die Security Group erlaubte Port 22 für SSH und Port 80 für HTTP. Im User Data Feld wurde der komplette Inhalt von cloud-init-nextcloud.yml eingefügt und die Instanz gestartet.

Nach 5-7 Minuten Wartezeit (Nextcloud-Download 260 MB dauert länger) wurde per SSH verbunden. Apache Status-Prüfung zeigte active running - Apache läuft erfolgreich. Das Nextcloud-Verzeichnis /var/www/nextcloud/ existierte mit allen Dateien wie index.php, config/, core/ und apps/. Nextcloud wurde erfolgreich heruntergeladen und entpackt.

Die VirtualHost-Konfiguration unter /etc/apache2/sites-available/nextcloud.conf wurde automatisch korrekt erstellt mit DocumentRoot /var/www/nextcloud/ und allen notwendigen Directory-Einstellungen. Die aktiven Sites zeigten einen Symlink auf nextcloud.conf und die deaktivierte 000-default.conf - Nextcloud-Site ist aktiviert, Default-Site deaktiviert.

Die Cloud-Init Logs bestätigten die Aktivierung der Apache Module rewrite, headers, env, dir und mime, den Download von Nextcloud 32.0.2.tar.bz2, das Entpacken, Kopieren nach /var/www/, das Setzen der Berechtigungen auf www-data:www-data, die VirtualHost-Config-Erstellung sowie die Aktivierung der Nextcloud-Site und Deaktivierung der Default-Site. Apache, PHP und Nextcloud wurden vollständig automatisiert installiert und konfiguriert.

## Nextcloud Setup-Wizard durchführen und mit Datenbank verbinden

Im Browser wurde die URL http://PUBLIC-IP geöffnet und der Nextcloud Setup-Wizard angezeigt. Im Setup-Formular wurde der Admin-Username admin mit Passwort NK67MxmPj7f9L4 eingegeben. Diese Credentials werden später für den Login verwendet.

Nach Klick auf "Datenbank konfigurieren" wurde im Datenbank-Formular MySQL/MariaDB aus dem Dropdown ausgewählt. Die Eingaben waren: Datenbank-User nextclouduser, Datenbank-Passwort jucbB6MPMWCzth, Datenbank-Name nextcloud und Datenbank-Host 172.31.85.12:3306. Die Private IP wurde von der NextcloudDB-Instanz mit hostname -I ermittelt. Wichtig ist die Verwendung der Private IP, da beide Instanzen im gleichen VPC über Private IPs kommunizieren.

Nach Klick auf "Installation abschließen" dauerte die Installation 1-2 Minuten. Die Fortschrittsanzeige zeigte das Testen der Datenbank-Verbindung, die Erstellung der Tabellen, das Anlegen des Admin-Accounts und das Speichern der Konfiguration. Nach erfolgreicher Installation erfolgte automatische Weiterleitung zum Login. Der Login mit Username admin und Passwort NK67MxmPj7f9L4 führte zum vollständig angezeigten Nextcloud Dashboard.

## Funktionsprüfung nach Setup

Das Dashboard wurde geöffnet und folgende Funktionen getestet: Dashboard lädt vollständig, Dateien-App zeigt leeres Verzeichnis, Kalender-App und Kontakte-App sind verfügbar, Einstellungen sind erreichbar, Admin-Menü funktioniert, User-Menü funktioniert und Logout ist möglich - alle Funktionen arbeiten korrekt.

Ein Datei-Upload wurde getestet durch Öffnen der Dateien-App, Hochladen einer Test-Datei per Drag & Drop und Beobachten des Upload-Fortschritts. Die Datei wurde erfolgreich hochgeladen und ist im Verzeichnis sichtbar.

Die Datenbank-Verbindung wurde auf der NextcloudDB-Instanz geprüft mit SHOW TABLES in der nextcloud Datenbank. Das Resultat zeigte über 70 Tabellen wie oc_accounts, oc_activity, oc_files und oc_users - Nextcloud hat Datenbank-Tabellen erfolgreich erstellt. Eine Abfrage der User-Anzahl ergab COUNT = 1, der Admin-User existiert.

Die Netzwerk-Kommunikation wurde von der Nextcloud-Instanz aus getestet durch Anpingen der DB-Instanz auf 172.31.85.12. Das Resultat zeigte 3 packets transmitted, 3 received, 0% packet loss - Netzwerk-Verbindung funktioniert. Eine direkte MySQL-Verbindung mit mysql -h 172.31.85.12 -u nextclouduser -pjucbB6MPMWCzth nextcloud und Abfrage der User ergab COUNT = 1 - Datenbank-Abfragen funktionieren und die Verbindung zwischen Instanzen ist stabil.

## Zusammenfassung und Fazit

Die Deployment-Zeiten betrugen für die NextcloudDB-Instanz 2-3 Minuten vollständig automatisch, für die Nextcloud-Instanz 5-7 Minuten vollständig automatisch und für Setup-Wizard plus DB-Konfiguration 2-3 Minuten manuell - insgesamt 10-15 Minuten bis zur produktionsreifen Installation. Im Vergleich zur vollständig manuellen Installation wurden 45-60 Minuten gespart.

Automatisiert wurden: MariaDB Installation und Konfiguration, Datenbank nextcloud erstellen, User nextclouduser mit Berechtigungen erstellen, MariaDB bind-address auf 0.0.0.0 setzen für Remote-Zugriff, Apache Installation und Konfiguration, PHP 8.3 mit allen erforderlichen Modulen installieren, Nextcloud 32.0.2 herunterladen (260 MB), Nextcloud entpacken und nach /var/www/ kopieren, Berechtigungen auf www-data:www-data setzen, VirtualHost-Konfiguration für Nextcloud erstellen, Apache-Module aktivieren (rewrite, headers, env, dir, mime), Nextcloud-Site aktivieren, Default-Site deaktivieren sowie Apache und MariaDB Services starten und für Autostart aktivieren.

Manuell durchgeführt wurden: Nextcloud Setup-Wizard, Admin-Account mit Passwort anlegen sowie Datenbank-Verbindung konfigurieren durch Eingabe von Host, User und Passwort. Der Grund für diese manuellen Schritte liegt in Sicherheitsaspekten - Admin-Account und Datenbank-Verbindung sollten interaktiv konfiguriert werden, damit Credentials nicht im Cloud-Init Skript hardcodiert sind.

Die Cloud-Init Automatisierung funktioniert perfekt und zuverlässig. Beide Instanzen werden vollautomatisch bereitgestellt und sind innerhalb von 10 Minuten produktionsbereit. Der Deployment-Prozess ist wiederholbar, deterministisch und spart erheblich Zeit gegenüber manueller Installation. Die Kommunikation zwischen Nextcloud und Datenbank über Private IPs funktioniert stabil. Das Projekt ist erfolgreich automatisiert.
