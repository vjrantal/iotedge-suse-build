zypper -n install docker

mkdir -p etc/zypp/repos.d && cp /etc/zypp/repos.d/* etc/zypp/repos.d/
mkdir -p etc/zypp/services.d && cp /etc/zypp/services.d/* etc/zypp/services.d/
mkdir -p etc/zypp/credentials.d && cp /etc/zypp/credentials.d/* etc/zypp/credentials.d
