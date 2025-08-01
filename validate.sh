#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1 - Missing!"
        ((ERRORS++))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
    else
        echo -e "${RED}✗${NC} $1/ - Missing!"
        ((ERRORS++))
    fi
}

check_service() {
    if docker ps --format "table {{.Names}}" | grep -q "^$1$"; then
        echo -e "${GREEN}✓${NC} $1 is running"
    else
        echo -e "${RED}✗${NC} $1 is not running!"
        ((ERRORS++))
    fi
}

echo -e "\n${YELLOW}Checking directory structure...${NC}"
check_file "Makefile"
check_dir "secrets"
check_dir "srcs"
check_file "srcs/.env"
check_file "srcs/docker-compose.yml"
check_dir "srcs/requirements"
check_dir "srcs/requirements/nginx"
check_dir "srcs/requirements/wordpress"
check_dir "srcs/requirements/mariadb"
check_dir "srcs/requirements/bonus"

echo -e "\n${YELLOW}Checking Dockerfiles...${NC}"
check_file "srcs/requirements/nginx/Dockerfile"
check_file "srcs/requirements/wordpress/Dockerfile"
check_file "srcs/requirements/mariadb/Dockerfile"
check_file "srcs/requirements/bonus/redis/Dockerfile"
check_file "srcs/requirements/bonus/ftp/Dockerfile"
check_file "srcs/requirements/bonus/adminer/Dockerfile"
check_file "srcs/requirements/bonus/static/Dockerfile"

echo -e "\n${YELLOW}Checking configuration files...${NC}"
check_file "srcs/requirements/nginx/conf/nginx.conf"
check_file "srcs/requirements/wordpress/conf/www.conf"

echo -e "\n${YELLOW}Checking tools scripts...${NC}"
check_file "srcs/requirements/nginx/tools/generate_ssl.sh"
check_file "srcs/requirements/wordpress/tools/setup_wordpress.sh"
check_file "srcs/requirements/mariadb/tools/init_db.sh"

echo -e "\n${YELLOW}Checking secrets...${NC}"
if [ -d "secrets" ]; then
    check_file "secrets/db_root_password.txt"
    check_file "secrets/db_password.txt"
    check_file "secrets/credentials.txt"
else
    echo -e "${RED}✗${NC} Secrets directory not found!"
    ((ERRORS++))
fi

echo -e "\n${YELLOW}Checking data directories...${NC}"
check_dir "/home/$USER/data"
check_dir "/home/$USER/data/mariadb"
check_dir "/home/$USER/data/wordpress"

echo -e "\n${YELLOW}Checking Docker services...${NC}"
if command -v docker &> /dev/null; then
    check_service "nginx"
    check_service "wordpress"
    check_service "mariadb"
    check_service "redis"
    check_service "ftp"
    check_service "adminer"
    check_service "static"
else
    echo -e "${RED}✗${NC} Docker is not installed!"
    ((ERRORS++))
fi

echo -e "\n${YELLOW}Checking network configuration...${NC}"
if docker network ls | grep -q "srcs_inception"; then
    echo -e "${GREEN}✓${NC} Docker network 'inception' exists"
else
    echo -e "${RED}✗${NC} Docker network 'inception' not found!"
    ((ERRORS++))
fi

echo -e "\n${YELLOW}Checking domain configuration...${NC}"
if grep -q "127.0.0.1.*$USER.42.fr" /etc/hosts; then
    echo -e "${GREEN}✓${NC} Domain $USER.42.fr is configured"
else
    echo -e "${YELLOW}⚠${NC}  Domain $USER.42.fr not in /etc/hosts"
    ((WARNINGS++))
fi

echo -e "\n${YELLOW}Checking port availability...${NC}"
ports=(443 8080 8081 9000 21)
for port in "${ports[@]}"; do
    if docker ps --format "table {{.Ports}}" | grep -q ":$port->"; then
        echo -e "${GREEN}✓${NC} Port $port is exposed"
    else
        echo -e "${YELLOW}⚠${NC}  Port $port is not exposed"
        ((WARNINGS++))
    fi
done

echo -e "\n${YELLOW}Checking TLS configuration...${NC}"
if docker exec nginx nginx -t 2>&1 | grep -q "test is successful"; then
    echo -e "${GREEN}✓${NC} NGINX configuration is valid"
else
    echo -e "${RED}✗${NC} NGINX configuration has errors!"
    ((ERRORS++))
fi

echo -e "\n${BLUE}===============================================${NC}"
echo -e "${BLUE}Validation Results:${NC}"
echo -e "${BLUE}===============================================${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Your Inception project is ready!${NC}"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Validation passed with $WARNINGS warning(s)${NC}"
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
fi

echo -e "${BLUE}===============================================${NC}"

exit $ERRORS