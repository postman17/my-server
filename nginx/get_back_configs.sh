echo "### Get back http nginx configs ..."

nextcloud=""
if [[ "$2" == "true" ]]; then
  nextcloud="cloud.$2"
fi
sentry=""
if [[ "$3" == "true" ]]; then
  sentry="sentry.$3"
fi
domains="$1 www.$1 pgadmin.$1 $nextcloud $sentry"
docker_compose_file_path="nginx/docker-compose.yml"

for domain in $domains; do
  if [[ "$domain" != *"www"* ]]; then
    echo "now enabling this domain: $domain"
    docker-compose -f $docker_compose_file_path exec -T nginx mv -v "/etc/nginx/conf.d/ssl.$domain.conf" "/etc/nginx/conf.d/ssl.$domain.conf.disabled"
    echo "now disabling this domain: $domain"
    docker-compose -f $docker_compose_file_path exec -T nginx mv -v "/etc/nginx/conf.d/$domain.conf.disabled" "/etc/nginx/conf.d/$domain.conf"
  fi
done
