start:
	docker network create --gateway 172.16.1.1 --subnet 172.16.1.0/24 nginx_net
	chmod +x nginx/init-letsencrypt.sh
	sudo ./nginx/init-letsencrypt.sh qwerty@example.com 1 example.com false
	docker-compose -f postgres/docker-compose.yml up -d
	sleep 10s
	docker-compose -f postgres/docker-compose.yml stop pgadmin
	sleep 10s
	sudo chown -R 5050:5050 data/pgadmin
	docker-compose -f postgres/docker-compose.yml up -d pgadmin
	docker-compose -f nextcloud/docker-compose.yml up -d

up:
	docker-compose -f nginx/docker-compose.yml up -d nginx
	docker-compose -f postgres/docker-compose.yml up -d
	docker-compose -f nextcloud/docker-compose.yml up -d

stop:
	docker-compose -f postgres/docker-compose.yml stop
	docker-compose -f nextcloud/docker-compose.yml stop
	docker-compose -f nginx/docker-compose.yml stop

down:
	docker-compose -f postgres/docker-compose.yml down
	docker-compose -f nextcloud/docker-compose.yml down
	docker-compose -f nginx/docker-compose.yml down
	docker network rm nginx_net

clear-volumes:
	sudo chown -R konstantin data/postgres || true
	sudo chown -R konstantin data/pgadmin || true
	sudo chown -R konstantin data/certbot || true
	sudo chown -R konstantin data/nextcloud || true
	sudo chown -R konstantin data/nginx || true
	rm -rf data/postgres || true
	rm -rf data/pgadmin || true
	rm -rf data/certbot || true
	rm -rf data/nextcloud || true
	rm -rf data/nginx || true

remove-configs:
	sudo chown -R konstantin nginx/etc/nginx/conf.d/ || true
	rm -rf nginx/etc/nginx/conf.d/*.conf || true
	rm -rf nginx/etc/nginx/conf.d/*.disabled || true

remove-envs:
	sudo chown -R konstantin nextcloud/ || true
	rm nextcloud/.env || true
	sudo chown -R konstantin postgres/ || true
	rm postgres/.env.db || true
	rm postgres/.env.pgadmin || true

remove-shit: clear-volumes remove-configs remove-envs
