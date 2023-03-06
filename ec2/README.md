## Setup VMs

SSH to VMs and execute the following.

```sh
sudo su
rm -rf /opt/java/openjdk
BINARY_URL='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u362-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u362b09.tar.gz'; \
#BINARY_URL='https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_x64_linux_hotspot_17.0.6_10.tar.gz'; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;
exit
echo 'JAVA_HOME=/opt/java/openjdk' >> ~/.bashrc
echo 'PATH="/opt/java/openjdk/bin:$PATH"' >> ~/.bashrc
java -version

wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.3.tgz
tar -xzf apache-jmeter-5.3.tgz
rm apache-jmeter-5.3.tgz

sudo yum install jq -y
sudo yum install git -y
sudo yum install tree -y
```

Generate rmi_keystore.jks and copy it to servers.
Ref: [https://jmeter.apache.org/usermanual/remote-test.html](https://jmeter.apache.org/usermanual/remote-test.html)
```sh
cd $(which jmeter)/..
rsync -chavzP ./rmi_keystore.jks cc-perf-test-client:~/apache-jmeter-5.3/bin/rmi_keystore.jks
rsync -chavzP ./rmi_keystore.jks cc-perf-test-server-1:~/apache-jmeter-5.3/bin/rmi_keystore.jks
rsync -chavzP ./rmi_keystore.jks cc-perf-test-server-2:~/apache-jmeter-5.3/bin/rmi_keystore.jks
cd -
```

Copy test plan to the client.
```sh
rsync -chavzP ../jmeter/apim-test.jmx cc-perf-test-client:~

rsync -chavzP ../payloads/*.json cc-perf-test-server-1:~
rsync -chavzP ../payloads/*.json cc-perf-test-server-2:~

rsync -chavzP ../jtl-splitter/jtl-splitter-0.4.6-SNAPSHOT.jar cc-perf-test-client:~
```

Install kubectl and aws cli on the JMeter client VM and configure the connection to the cluster. So JMeter client VM can communicate with cluster via kubectl.
```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws configure
```

Refer [Copy Tokens](../jwt-tokens/)
