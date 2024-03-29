## My server installation

## If you use ansible
- Install ansible on server
- sudo ansible-playbook playbook.yml
- After services started, for nextcloud install apps:
  - In nextcloud folder run make install-apps

### If you use make file (Full installation with makefiles not available)
- Copy env examples files and fill variables
- Fill make file variables in 3 row with email, domain, staging and true or false for nextcloud
- Do nginx configs from templates, use .disabled for first start with ssl configs in nginx/etc/nginx/conf.d/ folder
- make start
- After services started, for nextcloud install apps:
  - In nextcloud folder run make install-apps


#### Secondary scripts

##### Add nginx subdomain config
- ```ansible-playbook add-subdomain.yml```

##### Recreate letsecrypt ssl certs
- ```ansible-playbook recreate-ssl-certs.yml```
