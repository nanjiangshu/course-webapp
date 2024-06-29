# this script contains a set of helper functions to deploy the project.
#!/bin/bash set -e

deploy-no-ssl() {
    echo "Deploying project without SSL"
    docker compose down 
    docker compose -f docker-compose.yml --env-file .env-no-ssl up -d
}

deploy-with-ssl() {
    echo "Deploying project with SSL"
    hostnames=$(grep server_name nginx/nginx.conf | awk '{print $2}' | sed 's/;$//' | sort -u )
    hostname_with_ssl=$(sudo find certbot/etc/letsencrypt/live -name "fullchain.pem" | xargs dirname | xargs basename | sort -u) || echo "no sudo rights"
    docker compose down 
    sleep 5s
    if [ "$hostnames" != "$hostname_with_ssl" ]; then # need to create the certificate first
        docker compose -f docker-compose.yml --env-file .env-no-ssl up -d
        certbot_opts=$(echo "$hostnames" | sed 's/ /\ -d\ /g; s/^/-d\ /')
        echo "docker compose exec certbot certbot certonly --webroot -w /var/www/letsencrypt --agree-tos --no-eff-email --email nanjiang@bioshu.se $certbot_opts"
        docker compose exec certbot certbot certonly --webroot -w /var/www/letsencrypt --agree-tos --no-eff-email --email nanjiang@bioshu.se $certbot_opts
        docker compose stop nginx  
    fi
    docker compose -f docker-compose.yml --env-file .env-ssl up -d
}