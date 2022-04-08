## My server installation

## If you use ansible
- Install ansible on server
- sudo ansible-playbook playbook.yml
- After services started, run make install-apps in nextcloud directory if you need to install default nextcloud apps

### If you use make file
- Copy env examples files and fill variables
- Fill make file variables in 3 row with email, domain, staging and true or false for nextcloud
- Do nginx configs from templates? use .disabled for first start with ssl configs in nginx/etc/nginx/conf.d/ folder
- make start
- After services started, run make install-apps in nextcloud directory if you need to install default nextcloud apps
