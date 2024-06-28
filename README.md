# NBIS webapp 
Docker setup for hosting web applications which may have a password protection

The web applications should be provided as docker images, either existing in a repository or with a Dockerfile that can be built locally

## Setup 

### Create credentials
Create necessary login credentials in the `nginx` folder by the command `htpasswd`. For example, for the service `python2024`, use the following command to create the password hash 


```
htpasswd -c nginx/.htpasswd-python-bioinfo <username>
```

### Deploy 

#### Deploy without TLS

To deploy the service without TLS, run the following command

```
. proj.sh
deploy-no-ssl
```

#### Deploy with TLS 

To deploy the service with TLS enabled, run the following command
> make sure that the DNS are mapped properly for the server names configured in the [nginx.conf](./nginx/nginx.conf) file.

```
. proj.sh
deploy-with-ssl
```

### How to add a new web application

To add a new web application to the setup, 
1. add this application as a new service in the [docker-compose.yml](./docker-compose.yml) 
2. add the nginx configuration in both [nginx.conf](./nginx/nginx.conf) and [nginx-ssl.conf](./nginx/nginx-ssl.conf)

### Testing
There is a dummy application `app1` included in the setup. The hostname is `app1.bioshu.se` and 
login credentials are 
```
username: user1
password: pass1
```