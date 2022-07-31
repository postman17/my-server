#!/bin/bash


domains="$1"
docker_compose_file_path="nginx/docker-compose.yml"


echo "### Starting nginx ..."
docker-compose -f $docker_compose_file_path up --force-recreate -d nginx
echo


echo "### Enabled domains in nginx with SSL ..."
for domain in $domains; do
  if [[ "$domain" != *"www"* ]]; then
    echo "now enabling this domain: $domain"
    docker-compose -f $docker_compose_file_path exec -T nginx mv -v "/etc/nginx/conf.d/ssl.$domain.conf.disabled" "/etc/nginx/conf.d/ssl.$domain.conf"
    echo "now disabling this domain: $domain"
    docker-compose -f $docker_compose_file_path exec -T nginx mv -v "/etc/nginx/conf.d/$domain.conf" "/etc/nginx/conf.d/$domain.conf.disabled"
  fi
done


echo "### Reloading nginx ..."
docker-compose -f $docker_compose_file_path exec -T nginx nginx -s reload
