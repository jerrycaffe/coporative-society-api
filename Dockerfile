FROM openjdk:17-jdk-alpine AS builder
WORKDIR /application
COPY . .
RUN java -Djarmode=layertools -jar build/libs/Corporative-Society-API-0.0.1-SNAPSHOT.jar extract

FROM builder AS runtime

RUN set -x ;  \
    addgroup -g 1000 -S corporative-society-api-group && \
	adduser \
	--disabled-password \
	-g 1000 \
	-D \
	-s "/bin/bash" \
	-h "/home/corporative-society-api" \
	-u 1001 \
	-G corporative-society-api-group corporative-society-api && exit 0 ; exit 1

RUN echo "corporative-society-api ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER corporative-society-api

ADD --chown=corporative-society-api:corporative-society-api-group "." "/home/coporative-society-api/application"

COPY --from=builder /application/build/libs/Corporative-Society-API-0.0.1-SNAPSHOT.jar corporative-society-api.jar


ENTRYPOINT ["java","-jar","corporative-society-api.jar"]