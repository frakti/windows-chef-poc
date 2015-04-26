NGINX_SERVER_FILE_PATH=/var/opt/opscode/nginx/etc/nginx.d/poc-artefacts-repo.conf;

tee $NGINX_SERVER_FILE_PATH <<SERVER_CONFIG
server {
  listen 23000;
  autoindex on;
  root /vagrant/artefacts;
}
SERVER_CONFIG

chef-server-ctl restart nginx