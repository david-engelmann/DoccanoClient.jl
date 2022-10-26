#!/bin/bash
apt update
apt upgrade -y
apt install git curl -y

git clone https://github.com/doccano/doccano.git --config core.autocrlf=input
cd doccano

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

cat .env
exec "$@"