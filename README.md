# Infra-app

It contains an HTTP server implementation. It responds to all HTTP requests to the URI paths `/app` and `/healthz`.

## Basic instructions

To run in development, just run:

```sh
PORT=5000 go run main.go
```

To build, just run:

```sh
go build -o app
PORT=5000 ./app
```

By using the GOOS and GOARCH environment variables, you can control which OS and architecture your final binary is built fo.

```sh
GOOS=linux GOARCH=amd64 go build -o app

# to check the type of file
file app
app: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, Go BuildID=VlCWiOY1myXoArwKJ8-P/gL-oXKeuH4tOr4nCvhNv/6WUnDAZ95hnz49f7CeAV/Lg9OfRg0c1768RSFbAi4, not stripped
```

#### Docker

Using Docker for test:

```
docker build -t yaip/infra-app .

docker run --rm -ti -e PORT=5000 -p 5000:5000 alexlopes/yaip:latest
```

## How to use

```sh
$ curl -i http://127.0.0.1:5000/app
HTTP/1.1 200 OK
Content-Type: application/json
Date: Fri, 26 Jun 2020 20:14:57 GMT
Content-Length: 95

{
  "app": "Infra Go App",
  "hostname": "ebc919dc7272",
  "version": "0.0.2"
}
```

```sh
$ curl -i http://127.0.0.1:5000/healthz
HTTP/1.1 200 OK
Date: Fri, 26 Jun 2020 20:14:53 GMT
Content-Length: 0
```

