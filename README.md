# Self Hosted

This is a template of some services I run on my VPS and it currently contains:
- Jitsi Meetings (Zoom clone)
- Mozilla Sync Server (Sync server for Firefox)
- Piped (Youtube Proxy)
- Revolt (Discord clone)
- Whoogle Search (Google proxy)

## Installation

#### Requirements
- Docker 19+
- Docker Compose 2+
- bridge-utils (for Debian 10/11)
- a domain name
- Let's Encrypt SSL certificate for that domain name

#### Steps
- Clone this repo to the target server with
`git clone https://github.com/jim3692/self-hosted.git`
- Symlink the folders of the needed applications from `sites-available` to `sites-enabled`. For example:
`ln -s sites-available/jitsi sites-enabled/`
- (Optional) Rename the symlinks in `sites-enabled` as their names will appear on the domain. For example, if you rename `jitsi` to `meet`, its domain will be `meet.yourdomain.com` instead of `jitsi.yourdomain.com`.
- Create a new folder inside `nginx/configs/cert` and name it as your domain. For example `yourdomain.com`
- Copy your `ssl_certificate` as `domain.cert.pem` in the previously created folder
- Copy your `ssl_certificate_key` as `private.key.pem` in the previously created folder

> For more info about configuring SSL on nginx check http://nginx.org/en/docs/http/configuring_https_servers.html

- Rename `.env.example` to `.env`
- Change the values to your preferences. It's recommended to only change `SERVER_DOMAIN`.
- Run `up.sh` as root

## Challenges

1. Its application uses its own docker-compose and there is a need for a way to organize them and run them behind the same reverse proxy.

2. Cross-stack communication is a pain and the best option is to publish the required ports, which requires additional firewall configuration.

3. Docker does not integrate well with ufw or any iptables based firewall.

## Solutions

1. Each application has its own folder inside `sites-available` which needs to be symlinked to `sites-enabled` to be activated. The application's folder should contain the `init.sh` file. This file is a bash script which bootstraps the application. It usually compiles the `nginx.template.conf`, `template.env` and `docker-compose.template.yml` files and the calls `docker-compose up -d`.

2. Before any of the applications start, a bridge interface is created on the host. This interface gets a /32 IP address which is unique for each application. After the creation of the bridges, each `${IP}` in the `docker-compose.template.yml` and `nginx.template.conf` files is replaced with the corresponding IP of the application. This gives nginx a reliable path to the target services.

3. Since each application publishes its ports on its own exclusive bridge, there is no need to deal with firewalls, as only the required ports are exposed to the host's uplink interface.
