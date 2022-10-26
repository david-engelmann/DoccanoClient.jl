#!/bin/bash
apt update
apt upgrade -y
apt install git curl -y

curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

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

docker-compose -f docker/docker-compose.prod.yml --env-file .env up

if ping -c 1 http://127.0.0.1/ &> /dev/null
then
  echo "Doccano Installed"
else
  echo "Doccano Installation Failed"
fi

exec "$@"