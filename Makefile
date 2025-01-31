all: run

# fore-ground
run:
	@echo "Run in fore-ground"
	@sudo mkdir -p /home/donghank/data/wordpress
	@sudo mkdir -p /home/donghank/data/mysql
	@docker-compose -f ./srcs/docker-compose.yml up

# back-ground
up:
	@echo "Run in back-ground"
	@sudo mkdir -p /home/donghank/data/wordpress
	@sudo mkdir -p /home/donghank/data/mysql
	@docker-compose -f ./srcs/docker-compose.yml up -d

debug:
	@echo "Enter to debug mode"
	@sudo mkdir -p /home/donghank/data/wordpress
	@sudo mkdir -p /home/donghank/data/mysql
	@docker-compose -f ./srcs/docker-compose.yml --verbose up

list:
	@echo "List up docker"
	@docker ps -a

volumes:
	@echo "Volumes docker"
	@docker volume list

clean:
	@echo "Unmount all services..."
	@docker-compose -f ./srcs/docker-compose.yml down
	@echo "Delete docker container..."
	@docker stop $(docker ps -qa) 2>/dev/null || true
	@docker rm $(docker ps -qa) 2>/dev/null || true
	@echo "Delete images..."
	@docker rmi -f $(docker images -qa) 2>/dev/null || true
	@echo "Delete volumes..."
	@docker volume prune -f
	@echo "Delete networks..."
	@docker network ls | grep "bridge\|host\|none" -v | awk '{print $1}' | xargs docker network rm 2>/dev/null || true
	@echo "Delete all data wordpress and mysql..."
	@sudo rm -rf /home/donghank/data/wordpress
	@sudo rm -rf /home/donghank/data/mysql
	@echo "Delete completed!"

.PHONY: all run up debug list volumes clean
