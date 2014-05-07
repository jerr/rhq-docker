## SUMMARY
Installs RHQ 4.11 on Fedora 20 using docker.

## STEP-BY-STEP SETUP 

```
if [[ $(cat /etc/redhat-release | grep Fedora) ]]; then
  yum -y install wget curl git docker-io
  systemctl start docker 
  systemctl enable docker
else
  rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
  yum -y install wget curl git docker-io
  service docker start
  chkconfig docker on
fi
 
export RHQ_VERSION="4.11.0"
docker pull gkhachik/rhq-fedora.20:${RHQ_VERSION}
cid="$(docker run -d -i -p 17080:7080 -t gkhachik/rhq-fedora.20:${RHQ_VERSION} /bin/bash)"
docker logs -f ${cid}
```

## ONE-LINE SETUP
```
\curl -sSL https://gist.githubusercontent.com/gkhachik/6a0b9e296c661711fe88/raw/rhq-docker-fedora.20.sh | bash -x
```


## USEFUL
cleanup all images with given REPO:TAG
```
export DOCKER_REPO="<none>"
export DOCKER_TAG="<none>"
```

```
imgid="$(sudo docker images | grep -v "IMAGE" | grep -E "${DOCKER_REPO}" | grep -E " ${DOCKER_TAG} " | tail -1 | awk '{print $3}')"
while [[ "x$imgid" != "x" ]]; do
  for cid in $(sudo docker ps -a | grep "$imgid" | grep -v "CONTAINER ID" | awk '{print $1}'); do 
    sudo docker stop $cid
    sudo docker rm -f $cid
  done
  sleep 3
  sudo docker rmi -f $imgid
  imgid="$(sudo docker images | grep -v "IMAGE" | grep -E "${DOCKER_REPO}" | grep -E " ${DOCKER_TAG} " | tail -1 | awk '{print $3}')"
done
```
