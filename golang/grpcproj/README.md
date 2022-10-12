# grpc-gateway go

This is a template project to setup grpc-gateway with golang support. In the end `make gen` should generate your api docs.

#### Bootstrap

Go to your project env and run.


```
curl -sk 'https://raw.githubusercontent.com/amitavaghosh1/setup/main/golang/grpcproj/setup.sh' | bash
```

This should append some `make` [commands](https://raw.githubusercontent.com/amitavaghosh1/setup/main/golang/grpcproj/Makefile) to your existing Makefile.

Run `make gen` to generate the docs and go structs.

In order to quickly run a server and test it. Run:

```
cp main.go.sample ./some/appropriate/path/main.go
go run ./some/appropriate/path/main.go
```

And browse to [localhost:3000](http://localhost:3000/greeterapp/apidocs) to see the docs. 

You can and should change the url path from `greeterapp/` to appropriate root path as per project requirements.




