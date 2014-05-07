source env.properties
cointainer_id="cid-rhq:${DOCKER_TAG}"
if test -f ./$cointainer_id; then
  sudo docker kill $(cat ./${cointainer_id})
  sudo docker rm $(cat ./${cointainer_id})
fi
rm -f ./$cointainer_id
sudo docker run --cidfile=./$cointainer_id --sig-proxy=false -d -t -i -p ${DOCKER_PORT}:7080 ${DOCKER_REPO}:${DOCKER_TAG}
sudo docker logs -f $(cat ./$cointainer_id)
