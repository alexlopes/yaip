FROM alpine as builder

ARG REPOSITORY
ARG GITHUB_URL
ARG GITHUB_API_URL

ENV GITHUB_URL ${GITHUB_URL}
ENV GITHUB_API_URL ${GITHUB_API_URL}
ENV REPOSITORY ${REPOSITORY}

COPY version .
COPY scripts/get-latest-asset.sh /usr/local/bin/get-latest-asset

RUN apk --no-cache update \
	&& apk add --no-cache curl jq \
    && get-latest-asset

FROM alpine

COPY --from=builder /tmp/infra-app /usr/local/bin/

RUN chmod +x /usr/local/bin/infra-app

EXPOSE 5000

ENTRYPOINT [ "infra-app" ]