# Erstellung der EC2-Instanzen für Nextcloud

Für mein Nextcloud-Projekt habe ich im AWS-Lernlab zwei EC2-Instanzen angelegt. Beide laufen mit Ubuntu 24.04 LTS und sind im gleichen Netz.

- Instanz 1: nextcloud-server
  - Typ: t3.medium
  - Ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)
  - SSH-Key wurde neu erstellt und gespeichert

- Instanz 2: nextcloud-database
  - Typ: t3.medium
  - Ports: 22 (SSH)
  - Wird später zusätzlich für den Datenbank-Port (3306) freigegeben

Die öffentlichen IPs und Security-Gruppenregeln habe ich dokumentiert (siehe Screenshot).

### Probleme und Lösungen

Die Erstellung war zunächst problemlos. 
Später hat sich gezeigt, dass die Security Groups noch angepasst werden mussten. Port 3306 war noch nicht freigegeben.
