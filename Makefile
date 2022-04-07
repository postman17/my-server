start:
	chmod +x nginx/init-letsencrypt.sh
	sudo ./nginx/init-letsencrypt.sh
	docker-compose -f postgres/docker-compose.yml up -d & sleep 10s & docker-compose -f postgres/docker-compose.yml stop
	sudo chown -R 5050:5050 data/pgadmin
	docker-compose -f postgres/docker-compose.yml up -d
	docker-compose -f nextcloud/docker-compose.yml up -d

up:
	docker-compose -f nginx/docker-compose.yml up nginx -d
	docker-compose -f postgres/docker-compose.yml up -d
	docker-compose -f nextcloud/docker-compose.yml up -d

stop:
	docker-compose -f nginx/docker-compose.yml stop
	docker-compose -f postgres/docker-compose.yml stop
	docker-compose -f nextcloud/docker-compose.yml stop

down:
	docker-compose -f nginx/docker-compose.yml down
	docker-compose -f postgres/docker-compose.yml down
	docker-compose -f nextcloud/docker-compose.yml down

clear:
	docker-compose -f nginx/docker-compose.yml down
	docker-compose -f postgres/docker-compose.yml down
	docker-compose -f nextcloud/docker-compose.yml down
	sudo chown -R konstantin data/postgres data/pgadmin data/certbot data/nextcloud
	rm -rf data/postgres data/pgadmin data/certbot data/nextcloud

rename:
	mv -v nginx/etc/nginx/conf.d/cloud.postman17.tech.conf.disabled etc/nginx/conf.d/cloud.postman17.tech.conf
	mv -v nginx/etc/nginx/conf.d/pgadmin.postman17.tech.conf.disabled etc/nginx/conf.d/pgadmin.postman17.tech.conf
	mv -v nginx/etc/nginx/conf.d/postman17.tech.conf.disabled etc/nginx/conf.d/postman17.tech.conf
	mv -v nginx/etc/nginx/conf.d/ssl.cloud.postman17.tech.conf etc/nginx/conf.d/ssl.cloud.postman17.tech.conf.disabled
	mv -v nginx/etc/nginx/conf.d/ssl.pgadmin.postman17.tech.conf etc/nginx/conf.d/ssl.pgadmin.postman17.tech.conf.disabled
	mv -v nginx/etc/nginx/conf.d/ssl.postman17.tech.conf etc/nginx/conf.d/ssl.postman17.tech.conf.disabled
