#!/bin/bash
apt update
apt upgrade -y
apt install git curl -y

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Clone in Doccano Source Code
git clone https://github.com/doccano/doccano.git --config core.autocrlf=input
cd doccano

# Create .env file for creating Doccano
touch .env

echo "# platform settings" >> .env
echo "ADMIN_USERNAME=admin" >> .env
echo "ADMIN_PASSWORD=password" >> .env
echo "ADMIN_EMAIL=julia_jackson@gmail.com" >> .env
echo "\n" >> .env
echo "# rabbit mq settings" >> .env
echo "RABBITMQ_DEFAULT_USER=doccano" >> .env
echo "RABBITMQ_DEFAULT_PASS=doccano" >> .env
echo "\n" >> .env
echo "# databse settings" >> .env
echo "POSTGRES_USER=doccano" >> .env
echo "POSTGRES_PASSWORD=doccano" >> .env
echo "POSTGRES_DB=doccano" >> .env

# Create Doccano with docker-compose
docker-compose -f docker/docker-compose.prod.yml --env-file .env up
exec "$@"