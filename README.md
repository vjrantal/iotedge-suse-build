# Introduction

This repository contains scripts to build [Azure IoT Edge](https://github.com/azure/iotedge) on SUSE Linux.

The scripts were tested on Azure using the virtual machine image SUSE Linux Enterprise Server (SLES) 12 SP4 (Standard Support).

# Usage

```
sudo ./prepare.sh
sudo docker build -t vjrantal/iotedge-suse-build . --add-host=smt-azure.susecloud.net:104.45.17.148
sudo docker run --add-host=smt-azure.susecloud.net:104.45.17.148 -it vjrantal/iotedge-suse-build
```

After steps above, the RPM packages are available at:

```
/iotedge/edgelet/hsm-sys/azure-iot-hsm-c/build/libiothsm-std-1.0.8-Linux.rpm
/root/rpmbuild/RPMS/x86_64/iotedge-1.0.8-0.1.dev.x86_64.rpm
```

Those packages can then be installed using `zypper`.

# Features tested

* Installation of the rpm packages with zypper succeeded

  * During installation, got a warning about packages being unsigned, but it was possible to ignore the warning:

  ```
  Signature verification failed [6-File is unsigned]
  ```

  * Package manager reported a problem about `shadow-utils`, which seems to have different package name on SUSE Linux, but it was possible to ignore this problem during installation:

  ```
  Problem: nothing provides shadow-utils needed by iotedge-1.0.8-0.1.dev.x86_64
  ```

* After installing packages, it was possible to run `sudo systemctl restart iotedge` to start IoT Edge

* It was possible to run `sudo systemctl enable iotedge` to make IoT Edge run after reboot and it was tested that this functionality worked

* IoT Edge runtime was able to start and connect to IoT Hub and deployment of the Marketplace module `Simulated Temperature Sensor` succeeded

* The `Simulated Temperature Sensor` was able to start and sending messages to IoT Hub worked

# Disclaimer

While this repository contains an example about how to build IoT Edge on SUSE Linux Enterprise Server 12 SP4, the author does not advice anything about the usage of the build results from licensing perspective.

At the time of writing this example, SUSE Linux was not in the list of [officially supported systems by Microsoft](https://docs.microsoft.com/en-us/azure/iot-edge/support).