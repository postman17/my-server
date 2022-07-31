#!/bin/bash

#set -x

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi


email="$1" # Adding a valid address is strongly recommended
staging="$2" # Set to 1 if you're testing your setup to avoid hitting request limits

nextcloud=""
if [[ "$4" == "true" ]]; then
  nextcloud="cloud.$3"
fi
sentry=""
if [[ "$5" == "true" ]]; then
  sentry="sentry.$3"
fi
domains="$3 www.$3 pgadmin.$3 $nextcloud $sentry"
rsa_key_size=4096
data_path="./data/certbot"
docker_compose_file_path="nginx/docker-compose.yml"


if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi


echo "### Starting nginx ..."
docker-compose -f $docker_compose_file_path up --force-recreate -d nginx
echo


echo "### Requesting Let's Encrypt certificate for $domains ..."
domain_args=""
for domain in $domains; do
  #Join $domain to -d args
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose -f $docker_compose_file_path run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --non-interactive \
    --force-renewal" certbot
echo


echo "### Reloading nginx ..."
docker-compose -f $docker_compose_file_path exec -T nginx nginx -s reload
