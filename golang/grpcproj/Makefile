ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

clean:
	find . -type f -name '*.pb.go' | xargs -I % rm %
	find . -type f -name '*.pb.gw.go' | xargs -I % rm %

gen: clean
	buf generate
	widdershins --language_tabs 'go:Go' 'shell:curl' --summary docs/apidocs.swagger.json -o docs/index.html.md
	docker build . -t gen_api -f ./infrafiles/genapi/Dockerfile
	docker run --rm  -v $(ROOT_DIR)/docs/slatedocs/:/srv/slate/build -it gen_api
