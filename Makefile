NAME = inception
COMPOSE = docker-compose -f srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

all: setup up

setup:
	@echo "Setting up data directories..."
	@sudo mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	@sudo chown -R $(USER):$(USER) $(DATA_PATH)
	@echo "Checking secrets..."
	@if [ ! -d "./secrets" ]; then \
		echo "Error: secrets directory not found!"; \
		echo "Please create it with:"; \
		echo "  mkdir -p secrets"; \
		echo "  echo 'your_root_password' > secrets/db_root_password.txt"; \
		echo "  echo 'your_db_password' > secrets/db_password.txt"; \
		echo "  echo 'your_admin_password' > secrets/admin_password.txt"; \
		echo "  echo 'your_user_password' > secrets/user_password.txt"; \
		echo "  echo 'your_ftp_password' > secrets/ftp_password.txt"; \
		echo "  echo 'your_redis_password' > secrets/redis_password.txt"; \
		exit 1; \
	fi
	@echo "Setup complete"

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	@echo "(data preserved)"
	$(COMPOSE) down

fclean:
	@read -p "⚠️  This will DELETE all WordPress x DB data. Continue? (y/N): " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		$(COMPOSE) down -v; \
		docker system prune -af; \
		sudo rm -rf $(DATA_PATH); \
	else \
		echo "Aborted fclean."; \
	fi

re: fclean all

.PHONY: all setup up down clean fclean re
