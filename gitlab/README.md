#### Install
- copy .env.example to .env and set external_url
```shell
set -o allexport; source .env; set +o allexport
```
```shell
docker-compose up -d
```

#### Do it.
- after run gitlab change root password (username root and set password)
```shell
sudo docker exec -it container_name bash
gitlab-rake "gitlab:password:reset[root]"
```

##### Materials
- https://www.czerniga.it/2021/11/14/how-to-install-gitlab-using-docker-compose/
- https://forum.gitlab.com/t/gitlab-using-docker-compose-behind-a-nginx-reverse-proxy/26148/3
- https://docs.gitlab.com/omnibus/settings/nginx.html
- https://mcs.mail.ru/docs/additionals/cases/cases-gitlab/case-gitlab
- https://serveradmin.ru/gitlab-container-registry-za-nginx-reverse-proxy/

