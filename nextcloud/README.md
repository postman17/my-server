# NextCloud simple


### Start
- ```Copy .env.example to .env and fill settings```
- ```docker-compose up```

### Clear volumes data
- ```make clear```

### Install common apps after startup
- ```Fill NEXTCLOUD_CUSTOM_APPS variable target apps```
- ```make install-apps```
#### Install apps materials
- https://github.com/nextcloud/docker/issues/820
- https://www.linux.org.ru/forum/admin/16833314
- https://github.com/nextcloud/server/issues/1599
