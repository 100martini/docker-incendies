NAME = inception
COMPOSE = docker-compose -f srcs/docker-compose.yml

all: up

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v
	docker system prune -af

re: clean all

.PHONY: all up down clean re
