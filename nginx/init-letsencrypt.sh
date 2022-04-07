#!/bin/bash

#set -x

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

domains="cloud.postman17.tech pgadmin.postman17.tech"
rsa_key_size=4096
data_path="./data/certbot"
docker_compose_file_path="nginx/docker-compose.yml"
email="frompostal@yandex.ru" # Adding a valid address is strongly recommended
staging=1 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ -d "$data_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi


if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

#echo "### Creating dummy certificate for $domains ..."
#for domain in $domains; do
#  path="/etc/letsencrypt/live/$domain"
#  mkdir -p "$data_path/conf/live/$domain"
#  docker-compose -f $docker_compose_file_path run --rm --entrypoint "\
#    openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
#      -keyout '$path/privkey.pem' \
#      -out '$path/fullchain.pem' \
#      -subj '/CN=localhost'" certbot
#  echo
#done

echo "### Starting nginx ..."
docker-compose -f $docker_compose_file_path up --force-recreate -d nginx
echo


#echo "### Deleting dummy certificate for $domains ..."
#for domain in $domains; do
#  docker-compose -f $docker_compose_file_path run --rm --entrypoint "\
#    rm -Rf /etc/letsencrypt/live/$domain && \
#    rm -Rf /etc/letsencrypt/archive/$domain && \
#    rm -Rf /etc/letsencrypt/renewal/$domain.conf" certbot
#  echo
#done


echo "### Requesting Let's Encrypt certificate for $domains ..."

for domain in $domains; do
  #Join $domain to -d args
  domain_args="-d $domain -d 'www.$domain'"

  # Select appropriate email arg
  case "$email" in
    "") email_arg="--register-unsafely-without-email" ;;
    *) email_arg="--email $email" ;;
  esac

  # Enable staging mode if needed
  if [ $staging != "0" ]; then staging_arg="--staging"; fi

  docker-compose -f $docker_compose_file_path run --rm --entrypoint "\
    certbot certonly --nginx --webroot -w /var/www/certbot \
      $staging_arg \
      $email_arg \
      $domain_args \
      --rsa-key-size $rsa_key_size \
      --agree-tos \
      --force-renewal" certbot
  echo
done


echo "### Enabled domains in nginx with SSL ..."
for domain in $domains; do
  echo "now enabling this domain: $domain"
  docker-compose -f $docker_compose_file_path exec nginx mv -v "/etc/nginx/conf.d/ssl.$domain.conf.disabled" "/etc/nginx/conf.d/ssl.$domain.conf"
  echo "now disabling this domain: $domain"
  docker-compose -f $docker_compose_file_path exec nginx mv -v "/etc/nginx/conf.d/$domain.conf" "/etc/nginx/conf.d/$domain.conf.disabled"
done


echo "### Reloading nginx ..."
docker-compose -f $docker_compose_file_path exec nginx nginx -s reload
