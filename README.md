## SUMMARY
Installs RHQ 4.11 on Fedora 20 using docker.

## INSTALLATION

### RHEL 6.x
```
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install wget curl git docker-io; service docker start; chkconfig docker on
git clone https://github.com/gkhachik/rhq-docker.git
cd rhq-docker/
./build.sh
./run.sh
```
### Fedora 20+
```
yum -y install wget curl git docker-io
systemctl start docker
systemctl enable docker
git clone https://github.com/gkhachik/rhq-docker.git
cd rhq-docker/
./build.sh
./run.sh
```

