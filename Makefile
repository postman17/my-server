start:
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

clear:
	docker-compose -f postgres/docker-compose.yml down
	docker-compose -f nextcloud/docker-compose.yml down
	docker-compose -f nginx/docker-compose.yml down
	sudo chown -R konstantin data/postgres data/pgadmin data/certbot data/nextcloud
	rm -rf data/postgres data/pgadmin data/certbot data/nextcloud

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
