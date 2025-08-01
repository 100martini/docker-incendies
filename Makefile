NAME = inception
COMPOSE = docker-compose -f srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

all: setup up

setup:
	@echo "Setting up data directories..."
	@sudo mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	@sudo chown -R $(USER):$(USER) $(DATA_PATH)
	@echo "Data directories created"

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v
	docker system prune -af

fclean: clean
	@echo "Removing data directories..."
	@sudo rm -rf $(DATA_PATH)

re: fclean all

.PHONY: all setup up down clean fclean re