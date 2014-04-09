# build rhq docker image from Dockerfile 

# remove old docker image first
source env.properties
\curl -sSL ${CLEANUP_GIST} | bash -x

sudo docker build -t ${DOCKER_REPO}:${DOCKER_TAG} .
