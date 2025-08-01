#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Inception Project Setup${NC}"

if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}Please don't run this script as root${NC}"
   exit 1
fi

echo -e "${YELLOW}Updating .env file...${NC}"
sed -i "s/wel-kass/$USER/g" srcs/.env

echo -e "${YELLOW}Creating data directories...${NC}"
sudo mkdir -p /home/$USER/data/mariadb
sudo mkdir -p /home/$USER/data/wordpress
sudo chown -R $USER:$USER /home/$USER/data

echo -e "${YELLOW}Adding domain to /etc/hosts...${NC}"
if ! grep -q "127.0.0.1 $USER.42.fr" /etc/hosts; then
    echo "127.0.0.1 $USER.42.fr" | sudo tee -a /etc/hosts
fi

echo -e "${YELLOW}Cleaning up existing Docker resources...${NC}"
cd srcs && docker-compose down -v 2>/dev/null || true
cd ..
docker system prune -af --volumes

echo -e "${GREEN}Building and starting services...${NC}"
make up

echo -e "${YELLOW}Waiting for services to be ready...${NC}"
sleep 15

echo -e "${GREEN}Checking services status:${NC}"
cd srcs && docker-compose ps && cd ..

echo -e "${GREEN}✓ Setup Complete ${NC}"
echo -e "Access your services at:"
echo -e "  - WordPress: https://$USER.42.fr"
echo -e "  - Adminer: http://localhost:8080"
echo -e "  - Static site: http://localhost:8081"
echo -e ""
echo -e "FTP access:"
echo -e "  - Host: localhost"
echo -e "  - Port: 21"
echo -e "  - User: ${FTP_USER:-ftpuser}"
echo -e "  - Pass: Check FTP_PASSWORD in .env"