#### Install
- copy .env.example to .env and set external_url
```shell
set -o allexport; source .env; set +o allexport
```
```shell
docker-compose up -d
```
- set external_url setting your url in etc/gitlab/gitlab.rb and reconfigure - gitlab-ctl reconfigure
#### Do it.
- after run gitlab change root password (username root and set password)
```shell
sudo docker exec -it container_name bash
gitlab-rake "gitlab:password:reset[root]"
```
- if problems with permissions
```shell

- https://gitlab.com/gitlab-org/omnibus-gitlab/-/issues/6926
sudo docker exec -it gitlab-ce update-permissions
inside container:
rm /var/opt/gitlab/gitaly/gitaly.pid
chown -R git:git /var/opt/gitlab/gitaly/
sudo docker restart gitlab-ce
```

#### Gitlab runner settings
- Read this - https://www.dmosk.ru/miniinstruktions.php?mini=gitlab-runner-web

##### Materials
- https://www.czerniga.it/2021/11/14/how-to-install-gitlab-using-docker-compose/
- https://forum.gitlab.com/t/gitlab-using-docker-compose-behind-a-nginx-reverse-proxy/26148/3
- https://docs.gitlab.com/omnibus/settings/nginx.html
- https://mcs.mail.ru/docs/additionals/cases/cases-gitlab/case-gitlab
- https://serveradmin.ru/gitlab-container-registry-za-nginx-reverse-proxy/
