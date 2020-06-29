# Yet Another Infra Project

Web API para demonstrar alguns conceitos da cultura Devops. Características: 

- API construída em Go.
- Responde nos paths `/app` e `/healthz`.
- Processo de CI no SemaphoreCI
- Deploy com manifestos do Kubernetes

## Estrutura de diretórios e arquivos

- **.semaphore/semaphore.yml**: Arquivo de workflow do SemaphoreCI com task responsável pelo Build da imagem Docker e posteriormente Push da mesma no Docker Hub
- **kubernetes**: Manifestos do Kubernetes para deploy da aplicação.
- **scripts**: Arquivos para auxílio no processo de CI.
  - **build-push-image.sh**: Realiza o build e push da Imagem Docker.
  - **get-latest-asset.sh**: Efetua o download da última versão do asset conforme o repositório no GitHub.
  - **get-version.sh**: Obtém a versão mais recente da tag conforme o repositório no GitHub.
- **Dockerfile**: Arquivo com instrução de build da imagem Docker.
- **main.go**: Código web API em Go
- **version**: Arquivo para controle da última versão obtida do respoitório no GitHub.

## Para desenvolvimento local

### Con Docker Instalado

```
# org/repo
export REPOSITORY_NAME=
export GITHUB_URL=
export GITHUB_API_URL=
export IMAGE_NAME=

docker build --build-arg REPOSITORY=${REPOSITORY_NAME} \
    --build-arg GITHUB_URL=${GITHUB_URL} \
    --build-arg GITHUB_API_URL=${GITHUB_API_URL} -t "${IMAGE_NAME}" .

docker run --rm -ti -e PORT=5000 -p 5000:5000 ${IMAGE_NAME}
```

### Sem Docker Instalado

Para rodar diretamente a app

```sh
PORT=5000 go run main.go
```

Para construir o binário

To build, just run:

```sh
go build -o app
PORT=5000 ./app
```

Para controlar o Sistema Operacional e o tipo de arquitetura

```sh
GOOS=linux GOARCH=amd64 go build -o app

file app
app: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, Go BuildID=VlCWiOY1myXoArwKJ8-P/gL-oXKeuH4tOr4nCvhNv/6WUnDAZ95hnz49f7CeAV/Lg9OfRg0c1768RSFbAi4, not stripped
```

## End-to-End

### Semaphore

- Necessário criar um projeto associado ao repositório do GitHub para criação dos hooks e keys.
- Criar as seguintes secretes com suas respectivas variáveis de ambiente:
  - **docker**
    - `DOCKERHUB_TOKEN: <token do repositório>`
    - `DOCKER_USER: <username associado do repositório`
  - **repository**
    - `REPOSITORY_NAME: <nome do repositório de onde será feito download do asset, no formato org/repo-name> `

- Após o primeiro push na branch `master`, certificar-se de que a imagem encontra-se publicada no docker hub do respectivo repositório.

### Kubernetes

#### Pré-requisitos

- Necessário a instalação do [envsubst](https://github.com/a8m/envsubst) no ambiente de deployment para substituição das variáveis ee ambiente .

- Caso opte pelo `ingress-nginx` como Ingress Controller, seguir instruções de instalção conforme ambiente seguindo o [guia](https://kubernetes.github.io/ingress-nginx/deploy)

#### Deploy local

(alterar o arquivo version conforme versão desejada)

```sh
export IMAGE_NAME=lopesalex/yaip
export APP_VERSION=$(cat version)

kubectl apply -f kubernetes/infra_app-service.yml
kubectl apply -f kubernetes/infra_app-ingress.yml
cat kubernetes/infra_app-deployment.yml | envsubst | kubectl apply -f -
```


## Uso


```sh
echo "localhost infra-app.info >> /etc/hosts"

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

$ curl -i http://127.0.0.1:5000/healthz
HTTP/1.1 200 OK
Date: Fri, 26 Jun 2020 20:14:53 GMT
Content-Length: 0
```

