# Reflexion

## Persönliche Reflexion - Vasco Kugler

Ich habe die meiste technische Arbeit gemacht - AWS-Instanzen aufgesetzt, Apache und PHP aufgebaut und am Ende ein Cloud-Init Skript geschrieben. Jan war dabei, hat Fehler gefunden, MariaDB installiert und die Tests gemacht.

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

## Persönliche Reflexion - Jan Josuran

Ich habe hauptsächlich getestet und die Datenbank erstellt. Bei den restlichen Schritten habe ich Vasco zugeschaut. Wenn Fehler kamen, haben wir zusammen überlegt, was nicht stimmt.

AWS fand ich am Anfang ziemlich verwirrend. Aber jetzt verstehe ich, dass es eigentlich logisch aufgebaut ist. Jedes Teil hat einen Zweck.

Da wir bei der Datenbankverbindung vergessen haben, den Port 3306 zu öffnen kam die Fehlermeldung "Connection refused". Das hat uns zwar etwas verwirrt, aber durch das Troubleshooting konnten wir viel lernen.

Was ich gelernt habe:
- Screenshots während der Arbeit zu machen ist wichtig
- Es sollte immer sichergestellt werden, dass die benötigten Ports geöffnet sind.
- Fehlermeldungen genau lesen

Spannend fand ich die Zeitersparnis durch Cloud-Init, im Vergleich zur manuellen Installation.

Insgesamt fand ich es ein gelungenes Projekt. Wir haben etwas aufgebaut, das funktioniert und wir wissen auch wie es funktioniert. Das ist interessanter als nur Aufgaben abzuarbeiten.

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

**Ergäntzungen:**
Während des Projekts haben wir zunächst alles auf einem einzigen Laptop entwickelt. Das hatte aber zur Folge, dass alle Commits von einer Person stammten. Um eine sauberere Zusammenarbeit zu zeigem, haben wir ein neues Git-Repository aufgesetzt, in dem jeder nur das comittet, was er tatsächlich gearbeitet hat.

Ausserdem haben wir unsere Skripte zunächst offline entwickelt und auf einmal hochgeladen, was dazu führte, dass zunächst nur eine einzige grosse Version im Repository war. Daraufhin haben wir die Historie schrittweise wiederhergestellt, indem wir die Änderungen Stück für Stück separat comitten haben. So wurde der Verlauf nachvollziehbar und übersichtlich.

Diese Herangehensweise hat es uns erlaubt, die einzelnen Arbeitsschritte sauber zu dokumentieren und den Projektfortschritt klar ersichtlich zu machen.
