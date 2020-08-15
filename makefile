#MAKEFLAGS += --silent

NGINX_IMAGE=ng_image
NGINX_CONTAINER=ng_container
GO_IMAGE=go_image
GO_CONTAINER=go_container
MONGO_IMAGE=mongo_image
MONGO_CONTAINER=mongo_container

help:
	echo "\n*** Makefile Commands ***\n  build-nginx\n  run-nginx\n  shell-nginx\n  kill-nginx\n  logs-nginx\n\n\
  build-go\n  run-go\n  shell-go\n  test-go\n  kill-go\n  logs-go\n\n\
  build-mongo\n  run-mongo\n  test-mongo\n  shell-mongo\n  kill-mongo\n  remove-mongo\n  logs-mongo\n\n\
  website\n  clean\n"

build-nginx:
	docker build -t $(NGINX_IMAGE) -f nginx.dockerfile .
run-nginx:
	docker run -p 443:443 -d --rm --name $(NGINX_CONTAINER) $(NGINX_IMAGE)
shell-nginx:
	docker exec -it $(NGINX_CONTAINER) bash
test-nginx:
	docker run -p 443:443 --rm --name $(NGINX_CONTAINER) $(NGINX_IMAGE)
kill-nginx:
	docker rm $(NGINX_CONTAINER) -f
logs-nginx:
	docker logs $(NGINX_CONTAINER)

build-go:
	docker build -t $(GO_IMAGE) -f go-app.dockerfile .
run-go:
	docker run -p 9000:80 -d --rm --name $(GO_CONTAINER) $(GO_IMAGE)
shell-go:
	docker exec -it $(GO_CONTAINER) bash
test-go:
	docker run -p 9000:80 --rm --name $(GO_CONTAINER) $(GO_IMAGE)
kill-go:
	docker rm $(GO_CONTAINER) -f
logs-go:
	docker logs $(GO_CONTAINER)

build-mongo:
	perl setup_create_admin.pl
	docker build -t $(MONGO_IMAGE) -f mongodb.dockerfile .
run-mongo:
	docker run -p 10000:10000 -d -v /home/chris/MONGO:/data/db --rm --name $(MONGO_CONTAINER) $(MONGO_IMAGE)
shell-mongo:
	docker exec -it $(MONGO_CONTAINER) bash
kill-mongo:
	docker kill $(MONGO_CONTAINER)
remove-mongo:
	docker rm $(MONGO_CONTAINER) -f
	rm -rf /home/chris/MONGO/*
logs-mongo:
	docker logs $(MONGO_CONTAINER)


clean:
	docker system prune
	make kill-nginx
	make kill-go
website:
	make build-nginx
	make build-go
	make run-nginx
	make run-go
