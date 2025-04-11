## Build Docker Image

```shell
docker build -t renukafernando/netty-http-echo-service:0.4.6 .
```

```shell
docker build -t renukafernando/netty-http-echo-service:0.4.6-arm -f Dockerfile.ubuntu.arm .
```

## Run Docker Image

```shell
docker run --rm --name netty \
    -v ./keystore.p12:/keys/keystore.p12 \
    -p 8688:8688 renukafernando/netty-http-echo-service:0.4.6-arm \
    -m 2g -- --ssl --key-store-file /keys/keystore.p12 --key-store-password '1234'
```
