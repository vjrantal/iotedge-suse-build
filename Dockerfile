FROM registry.suse.com/suse/sles12sp4:latest

COPY etc/zypp/repos.d/* /etc/zypp/repos.d/
COPY etc/zypp/services.d/* /etc/zypp/services.d/
COPY etc/zypp/credentials.d/* /etc/zypp/credentials.d/

ADD http://smt-azure.susecloud.net/smt.crt /etc/pki/trust/anchors/smt.crt

RUN update-ca-certificates
RUN zypper --gpg-auto-import-keys ref -s

RUN zypper ref -s

RUN zypper -n install git-core
RUN zypper -n install --type pattern Basis-Devel
RUN zypper -n install --type pattern SDK-C-C++
RUN zypper -n install make cmake rpmbuild curl libopenssl-devel

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN git clone -b master --single-branch https://github.com/azure/iotedge.git
# Checkout the tested commit - remove below line when building latest from master
RUN git -C iotedge checkout c16bc50731677040d2a371c1374aa6941b9a34d8

WORKDIR /iotedge/edgelet
RUN source $HOME/.cargo/env; cargo build --release
RUN mkdir -p /root/rpmbuild && cd /root/rpmbuild && mkdir -p RPMS SOURCES SPECS SRPMS BUILD
RUN source $HOME/.cargo/env; make dist && make rpm rpmbuilddir=/root/rpmbuild RPMBUILDFLAGS="-v -bb --clean --define '_topdir /root/rpmbuild'"

RUN mkdir /iotedge/edgelet/hsm-sys/azure-iot-hsm-c/build
WORKDIR /iotedge/edgelet/hsm-sys/azure-iot-hsm-c/build
RUN cmake -DBUILD_SHARED=On -Drun_unittests=Off -Duse_emulator=Off -DCMAKE_BUILD_TYPE=Release -Duse_default_uuid=On -Duse_http=Off -DCPACK_GENERATOR=RPM ..
RUN make package
