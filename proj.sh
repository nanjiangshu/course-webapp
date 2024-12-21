# this script contains a set of helper functions to deploy the project.
#!/bin/bash set -e

deploy-no-ssl() {
    echo "Deploying project without SSL"
    docker compose down 
    docker compose -f docker-compose.yml --env-file .env-no-ssl up -d
}

deploy-with-ssl() {
    echo "Deploying project with SSL"

    # Get the list of hostnames from the nginx configuration
    hostnames=$(grep server_name nginx/nginx.conf | awk '{print $2}' | sed 's/;$//' | sort -u)

    # Get the list of hostnames that already have SSL certificates
    hostname_with_ssl=$(sudo find certbot/etc/letsencrypt/live -name "fullchain.pem" | xargs dirname | xargs basename | sort -u) || echo "no sudo rights"

    # Stop and remove the current containers
    docker compose down
    sleep 5s

    if [ "$hostnames" != "$hostname_with_ssl" ]; then # need to create the certificate first
        docker compose -f docker-compose.yml --env-file .env-no-ssl up -d

        for hostname in $hostnames; do
            if ! echo "$hostname_with_ssl" | grep -q "$hostname"; then
                echo "Certificate for $hostname not found, creating certificate..."
                docker compose exec certbot certbot certonly --webroot -w /var/www/letsencrypt --agree-tos --no-eff-email --email nanjiang@bioshu.se -d "$hostname"
            else
                echo "Certificate already exists for $hostname, skipping..."
            fi
        done

        docker compose stop nginx
    fi

    # Start services with SSL configuration
    docker compose -f docker-compose.yml --env-file .env-ssl up -d
}
