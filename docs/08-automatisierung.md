# Automatisierung mit Cloud-Init

## Entwicklungsprozess der Cloud-Init Skripte

Die Cloud-Init Skripte wurden nach der erfolgreichen manuellen Installation erstellt. 

Anfangs wollten wir direkt YML schreiben, aber dann sind wir auf verschiedene Fehler gestoßen. Beim Debugging haben wir gemerkt: Das ist blöd. Viel besser ist, erst alles von Hand zum Laufen zu bringen, dann die Befehle aufzuschreiben und DANN in YML zu packen.

## Warum erst manuell, dann automatisiert?

Bei der manuellen Installation sind wir auf verschiedene Fehler gestoßen (bind-address Problem, Security Group Port 3306, bzip2 fehlend, etc.). Jede Fehlermeldung konnten wir direkt sehen und sofort beheben. 

Wenn man direkt Cloud-Init YML schreibt, sieht man die Fehler erst wenn die Instanz startet. Dann muss man alles debuggen über Logs. Das wäre Zeitverschwendung gewesen. Besser: erst stabil, dann automatisiert.

## Unser Prozess

Zuerst haben wir zwei EC2 Instanzen erstellt und alles von Hand installiert. Das war manchmal frustrierend - verschiedene Fehler, verschiedene Lösungen. Aber dadurch wussten wir genau:
- Welche Pakete brauchen wir
- In welcher Reihenfolge müssen wir die installieren
- Welche Konfigurationen sind nötig
- Was kann schiefgehen

Dann haben wir alles dokumentiert (docs/02-06) und auch die Fehler aufgeschrieben (docs/11-fehlerbehebung).

Als dann die Installation stabil lief, haben wir die Befehle genommen und einfach in Cloud-Init Skripte umgewandelt. Statt Trial & Error war das dann nur noch Copy & Paste der getesteten Befehle.

Zum Schluss haben wir die Cloud-Init Skripte selbst getestet (docs/07-tests).

## Die Cloud-Init Skripte

### cloud-init-nextcloud.yml

Installiert automatisch:
- Apache Webserver
- PHP mit allen Modulen
- Nextcloud 32.0.2
- Apache Module (rewrite, headers, etc.)
- Setzt richtige Berechtigungen
- Konfiguriert VirtualHost
- Gibt IP-Adresse aus

### cloud-init-nextclouddb.yml

Installiert automatisch:
- MariaDB Server
- Konfiguriert bind-address auf 0.0.0.0
- Erstellt Datenbank "nextcloud"
- Erstellt User "nextclouduser" mit Berechtigungen
- Gibt IP-Adresse aus

## Automatisierung des kompletten Deployments mit Bash-Script

Nach dem Test der Cloud-Init Skripte über AWS Console war der nächste Schritt: **vollständige Automatisierung auch der EC2 Instance-Erstellung**.

Das Bash-Script `deploy-nextcloud.sh` kombiniert die Cloud-Init YAML-Dateien mit der AWS CLI:

**SSH Key wird automatisch erstellt** - anschliessen wir der Schlüssel direkt im .ssh ordner abgelegt für sofortigen zugriff nach der Installation
1. **Security Groups werden automatisch erstellt** - eine für Datenbank (Port 3306), eine für Nextcloud (Port 80/443)
2. **Instanzen werden mit `aws ec2 run-instances` gestartet** - mit automatischen Namen (NextcloudDB, Nextcloud) und den Cloud-Init Dateien als User Data
3. **Private und Public IPs werden abgerufen** - mit `aws ec2 describe-instances` und jq-Queries
4. **Deployment-Informationen werden gespeichert** - in `nextcloud-deployment-info.txt` inklusive Credentials und Verbindungsdaten mit Port 3306 für die Datenbank

Der Workflow mit dem Script ist dann nur noch:

```bash
chmod +x ./deploy-nextcloud.sh
./deploy-nextcloud.sh
```

Das Script läuft vollautomatisch durch:
- Schritt 1-2: Security Groups erstellen und konfigurieren
- Schritt 3-4: Beide Instanzen mit Cloud-Init starten
- Schritt 5: IPs abrufen und Deployment-Info speichern

## Vorher-Nachher Vergleich

| Methode | Zeit | Schritte | Fehleranfälligkeit |
|---------|------|----------|------------------|
| **Vollständig manuell** | 60-75 Min | EC2 erstellen, SSH, 30+ Befehle tippen | Sehr hoch |
| **Cloud-Init über Console** | 15-20 Min | EC2 erstellen, YML kopieren, Setup-Wizard | Mittel |
| **Automatisiert mit Script** | 10-15 Min | `./deploy-nextcloud.sh` ausführen | Niedrig |

## Fazit

Die Automatisierung mit Cloud-Init + Bash-Script spart nicht nur Zeit, sondern auch:
- **Sicherheit**: Konsistente Konfiguration bei jedem Deploy
- **Reproduzierbarkeit**: Immer das gleiche Ergebnis
- **Wartbarkeit**: Änderungen nur in YAML/Script, nicht in 30 Befehlen verteilt
- **Skalierbarkeit**: Mehrere Umgebungen (Test, Staging, Production) problemlos möglich
