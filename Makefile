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
	docker-compose -f nginx/docker-compose.yml up nginx -d
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

clear-volumes:
	sudo chown -R konstantin data/postgres || true
	sudo chown -R konstantin data/pgadmin || true
	sudo chown -R konstantin data/certbot || true
	sudo chown -R konstantin data/nextcloud || true
	rm -rf data/postgres
	rm -rf data/pgadmin
	rm -rf data/certbot
	rm -rf data/nextcloud

remove-configs:
	sudo chown -R konstantin nginx/etc/nginx/conf.d/
	rm -rf nginx/etc/nginx/conf.d/*.conf
	rm -rf nginx/etc/nginx/conf.d/*.disabled

remove-envs:
	sudo chown -R konstantin nextcloud/
	rm nextcloud/.env
	sudo chown -R konstantin postgres/
	rm postgres/.env.db
	rm postgres/.env.pgadmin

remove-shit: clear-volumes remove-configs remove-envs

