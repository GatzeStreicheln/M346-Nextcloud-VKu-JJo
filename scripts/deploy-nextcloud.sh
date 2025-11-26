#!/bin/bash

# Nextcloud AWS EC2 Deployment Script
# Startet DB + Nextcloud Instanzen mit Cloud-Init YAML-Dateien

set -e

# Variablen
DB_INSTANCE_TYPE="t3.medium"
NC_INSTANCE_TYPE="t3.medium"
AMI_ID="ami-0ecb62995f68bb549"
IAM_PROFILE="LabInstanceProfile"
REGION="us-east-1"

DB_USER="nextclouduser"
DB_PASSWORD="jucbB6MPMWCzth"
DB_NAME="nextcloud"
DB_ROOT_PASSWORD="admin"

echo "=========================================="
echo "Nextcloud AWS EC2 Deployment"
echo "=========================================="

# Security Group für DB
echo ""
echo "Schritt 1: Erstelle DB Security Group"

SECGROUP_DB_ID=$(aws ec2 create-security-group \
  --group-name nextcloud-db-secgroup \
  --description "Nextcloud Database Security Group" \
  --region $REGION \
  --query GroupId \
  --output text)

aws ec2 authorize-security-group-ingress \
  --group-id $SECGROUP_DB_ID \
  --ip-permissions \
    IpProtocol=tcp,FromPort=3306,ToPort=3306,IpRanges='[{CidrIp=0.0.0.0/0}]' \
  --region $REGION > /dev/null 2>&1

echo "Security Group erstellt: $SECGROUP_DB_ID"

# Security Group für Nextcloud
echo ""
echo "Schritt 2: Erstelle Nextcloud Security Group"

SECGROUP_NC_ID=$(aws ec2 create-security-group \
  --group-name nextcloud-app-secgroup \
  --description "Nextcloud Application Security Group" \
  --region $REGION \
  --query GroupId \
  --output text)

aws ec2 authorize-security-group-ingress \
  --group-id $SECGROUP_NC_ID \
  --ip-permissions \
    IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=0.0.0.0/0}]' \
    IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=0.0.0.0/0}]' \
  --region $REGION > /dev/null 2>&1

echo "Security Group erstellt: $SECGROUP_NC_ID"

# Starte Datenbank Instanz
echo ""
echo "Schritt 3: Starte Datenbank Instanz"

DB_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $DB_INSTANCE_TYPE \
  --security-group-ids $SECGROUP_DB_ID \
  --iam-instance-profile Name=$IAM_PROFILE \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=NextcloudDB}]' \
  --user-data file://cloud-init-nextclouddb.yml \
  --region $REGION \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "DB Instance ID: $DB_INSTANCE_ID"
sleep 10

DB_PRIVATE_IP=$(aws ec2 describe-instances \
  --instance-ids $DB_INSTANCE_ID \
  --region $REGION \
  --query 'Reservations[0].Instances[0].PrivateIpAddress' \
  --output text)

DB_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $DB_INSTANCE_ID \
  --region $REGION \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "DB Private IP: $DB_PRIVATE_IP"
echo "DB Public IP: $DB_PUBLIC_IP"

# Starte Nextcloud Instanz
echo ""
echo "Schritt 4: Starte Nextcloud Instanz"

NC_INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $NC_INSTANCE_TYPE \
  --security-group-ids $SECGROUP_NC_ID \
  --iam-instance-profile Name=$IAM_PROFILE \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Nextcloud}]' \
  --user-data file://cloud-init-nextcloud.yml \
  --region $REGION \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Nextcloud Instance ID: $NC_INSTANCE_ID"
sleep 10

NC_PRIVATE_IP=$(aws ec2 describe-instances \
  --instance-ids $NC_INSTANCE_ID \
  --region $REGION \
  --query 'Reservations[0].Instances[0].PrivateIpAddress' \
  --output text)

NC_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $NC_INSTANCE_ID \
  --region $REGION \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "Nextcloud Private IP: $NC_PRIVATE_IP"
echo "Nextcloud Public IP: $NC_PUBLIC_IP"

# Ausgabe
echo ""
echo "=========================================="
echo "DEPLOYMENT ERFOLGREICH GESTARTET"
echo "=========================================="
echo ""
echo "DATABASE SERVER:"
echo "  Instance ID: $DB_INSTANCE_ID"
echo "  Instance Name: NextcloudDB"
echo "  Security Group: $SECGROUP_DB_ID"
echo "  Public IP: $DB_PUBLIC_IP"
echo "  Private IP: $DB_PRIVATE_IP"
echo ""
echo "NEXTCLOUD SERVER:"
echo "  Instance ID: $NC_INSTANCE_ID"
echo "  Instance Name: Nextcloud"
echo "  Security Group: $SECGROUP_NC_ID"
echo "  Public IP: $NC_PUBLIC_IP"
echo "  Private IP: $NC_PRIVATE_IP"
echo ""
echo "DATENBANK CREDENTIALS:"
echo "  Host: $DB_PRIVATE_IP:3306"
echo "  Benutzer: $DB_USER"
echo "  Passwort: $DB_PASSWORD"
echo "  Datenbank: $DB_NAME"
echo "  Root Passwort: $DB_ROOT_PASSWORD"
echo ""
echo "Oeffne im Browser: http://$NC_PUBLIC_IP"
echo "Warte 3-5 Minuten bis die Instanzen vollstaendig initialisiert sind"
echo ""
echo "=========================================="

# Speichere Informationen
cat > nextcloud-deployment-info.txt << EOF
Nextcloud AWS Deployment - $(date '+%Y-%m-%d %H:%M:%S')

DATABASE
Instance ID: $DB_INSTANCE_ID
Instance Name: NextcloudDB
Security Group: $SECGROUP_DB_ID
Public IP: $DB_PUBLIC_IP
Private IP: $DB_PRIVATE_IP

NEXTCLOUD
Instance ID: $NC_INSTANCE_ID
Instance Name: Nextcloud
Security Group: $SECGROUP_NC_ID
Public IP: $NC_PUBLIC_IP
Private IP: $NC_PRIVATE_IP
URL: http://$NC_PUBLIC_IP

DATABASE CREDENTIALS
Host: $DB_PRIVATE_IP:3306
User: $DB_USER
Password: $DB_PASSWORD
Database: $DB_NAME
Root Password: $DB_ROOT_PASSWORD
EOF

echo "Informationen gespeichert in: nextcloud-deployment-info.txt"
