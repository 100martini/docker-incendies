NAME = inception
COMPOSE = docker-compose -f srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data
COLOR_RED    := \033[0;31m
COLOR_GREEN  := \033[0;32m
COLOR_YELLOW := \033[0;33m
COLOR_RESET  := \033[0m

all: setup up

setup:
	@sudo mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	@sudo chown -R $(USER):$(USER) $(DATA_PATH)
	@if [ ! -d "./secrets" ]; then \
		echo "$(COLOR_YELLOW)Warning: secrets directory not found!$(COLOR_RESET)"; \
		echo "Please make sure it contains the right files:"; \
		echo "$(COLOR_GREEN)secrets$(COLOR_RESET)/db_root_password.txt"; \
		echo "$(COLOR_GREEN)secrets$(COLOR_RESET)/db_password.txt"; \
		echo "$(COLOR_GREEN)secrets$(COLOR_RESET)/admin_password.txt"; \
		echo "$(COLOR_GREEN)secrets$(COLOR_RESET)/user_password.txt"; \
		echo "$(COLOR_GREEN)secrets$(COLOR_RESET)/ftp_password.txt"; \
		echo "$(COLOR_GREEN)secrets$(COLOR_RESET)/redis_password.txt"; \
		exit 1; \
	fi

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	@echo "($(COLOR_GREEN)data preserved$(COLOR_RESET))"
	$(COMPOSE) down

fclean:
	@read -p "⚠️  This will DELETE all WordPress x DB data. Continue? (y/N): " ans; \
	if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
		$(COMPOSE) down -v; \
		docker system prune -af; \
		sudo rm -rf $(DATA_PATH); \
	else \
		echo "$(COLOR_YELLOW)Aborted fclean.$(COLOR_RESET)"; \
	fi

re: fclean all

.PHONY: all setup up down clean fclean re
