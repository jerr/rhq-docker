
# source environment variables
source env.properties

# remove old docker image first
\curl -sSL ${CLEANUP_GIST} | bash -x

ORIGIN_DOCKER_REPO=$DOCKER_REPO
ORIGIN_DOCKER_TAG=$DOCKER_TAG

# cleanup also the ones that possibly will be having <none>:<none>-s there
DOCKER_REPO="<none>"; DOCKER_TAG="<none>"
\curl -sSL ${CLEANUP_GIST} | bash -x

sudo docker build -t ${ORIGIN_DOCKER_REPO}:${ORIGIN_DOCKER_TAG} .
