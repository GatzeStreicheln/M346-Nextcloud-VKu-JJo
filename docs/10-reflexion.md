# Reflexion

## Persönliche Reflexion - Vasco Kugler

Ich habe die meiste technische Arbeit gemacht - AWS-Instanzen aufgesetzt, MariaDB installiert und konfiguriert, Apache und PHP aufgebaut und am Ende die Cloud-Init Skripte geschrieben. Jan war dabei, hat Fehler gefunden und die Tests gemacht.

Was ich gelernt habe: Das Debugging bei der Datenbankverbindung war wichtig. Erst kam "Connection refused", dann "Access denied". Statt rumzuprobieren bin ich systematisch vorgegangen - Security Group checken, bind-address anpassen, User-Berechtigungen überprüfen. Am Ende hat es gepasst. Das merke ich mir für andere Projekte.

Die Cloud-Init Skripte waren interessant. Erst alles manuell machen, dann automatisieren - das macht Sinn. Wenn du direkt YML schreibst, dauert das Debugging ewig. So konnte ich alles testen und dann einfach in YML umschreiben.

Was war schwierig? Die Netzwerk-Architektur. Ich habe öffentliche IPs verwendet - das funktioniert, ist aber nicht optimal. Mit Private Subnets und VPC wäre es besser, aber das hätte zu viel Zeit gekostet.

Nächstes Mal würde ich:
- Security von Anfang an einplanen (HTTPS, starke Passwörter)
- Monitoring und Backups von Anfang an, nicht erst später
- Private Subnets für die Datenbank
- Mehr verschiedene Tests durchführen

Insgesamt war es gut, das Projekt von Anfang bis Ende selbst zu machen. Man versteht viel besser wie alles zusammenhängt, statt nur Befehle zu kopieren.

---


## Was wir zusammen gelernt haben

**Was hat gut funktioniert:**
- Die zwei Instanzen trennen war eine gute Idee
- Während der Arbeit Screenshots und Notizen machen hat geholfen
- Zu zweit arbeiten - wenn einer was nicht sieht, sieht's der andere
- Fehlersuche Schritt für Schritt machen hat funktioniert

**Was hätte besser sein können:**
- Mehr Security von Anfang an planen
- Monitoring und Backups von Anfang an
- Private Subnets für die Datenbank wäre besser
- Mehr verschiedene Tests durchführen

**Was wir mitnehmen:**
- Cloud-Infrastruktur ist verstehbar wenn man es selbst aufbaut
- Systematische Fehlersuche spart Zeit
- Gute Dokumentation während der Arbeit ist wichtig
- Automation nach Test besser als direkt automatisieren

Das Projekt hat gezeigt, dass wir verstehen wie das alles funktioniert - nicht nur Befehle kopieren, sondern wissen warum es funktioniert.
