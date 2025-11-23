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

## Vorher-Nachher

**Vorher (Manuell):** ~30-40 Befehle, die man eine nach einer eingeben muss, ca. 20 Minuten pro Instanz

**Nachher (Cloud-Init):** Beide Instanzen starten völlig automatisch, alles fertig in ~5 Minuten
