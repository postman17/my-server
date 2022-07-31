echo "### Get back http nginx configs ..."

docker_compose_file_path="nginx/docker-compose.yml"

for domain in $domains; do
  if [[ "$domain" != *"www"* ]]; then
    echo "now enabling this domain: $domain"
    docker-compose -f $docker_compose_file_path exec -T nginx mv -v "/etc/nginx/conf.d/ssl.$domain.conf" "/etc/nginx/conf.d/ssl.$domain.conf.disabled"
    echo "now disabling this domain: $domain"
    docker-compose -f $docker_compose_file_path exec -T nginx mv -v "/etc/nginx/conf.d/$domain.conf.disabled" "/etc/nginx/conf.d/$domain.conf"
  fi
done
