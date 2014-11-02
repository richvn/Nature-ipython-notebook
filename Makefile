# Configuration parameters
CULL_PERIOD ?= 30
CULL_TIMEOUT ?= 60
LOGGING ?= info
POOL_SIZE ?= 5

default: images

images: nature-image tmpnb-image routing-image

# Cleanup the server, create the proxy, create tmpnb
dev: cleanup proxy tmpnb

nature-image: Dockerfile
	docker build -t jupyter/nature-demo .

routing-image:
	docker build -t jupyter/nature-demo-routing routing

proxy-image:
	docker pull jupyter/configurable-http-proxy

proxy: proxy-image
	docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=devtoken jupyter/configurable-http-proxy --default-target http://127.0.0.1:9999

tmpnb: nature-image
	docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=devtoken \
		-v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py \
		--image=jupyter/nature-demo --cull_timeout=$(CULL_TIMEOUT) --cull_period=$(CULL_PERIOD) \
		--logging=$(LOGGING) --pool_size=$(POOL_SIZE) --static-files=/srv/ipython/IPython/html/static/ \
	  --redirect-uri=/notebooks/Nature.ipynb --command="ipython3 notebook --NotebookApp.base_url={base_path}"

cleanup:
	-docker stop `docker ps -aq`
	-docker rm   `docker ps -aq`
	-docker images -q --filter "dangling=true" | xargs docker rmi

.PHONY: cleanup
