## Setup VMs

SSH to VMs and execute the following.

```sh
sudo amazon-linux-extras install java-openjdk11 -y

wget https://dlcdn.apache.org/jmeter/binaries/apache-jmeter-5.5.tgz
tar -xzf apache-jmeter-5.5.tgz
rm apache-jmeter-5.5.tgz
```

Generate rmi_keystore.jks and copy it to servers.
Ref: [https://jmeter.apache.org/usermanual/remote-test.html](https://jmeter.apache.org/usermanual/remote-test.html)
```sh
cd $(which jmeter)/..
rsync -chavzP ./rmi_keystore.jks cc-perf-test-client:~/apache-jmeter-5.5/bin/rmi_keystore.jks
rsync -chavzP ./rmi_keystore.jks cc-perf-test-server-1:~/apache-jmeter-5.5/bin/rmi_keystore.jks
rsync -chavzP ./rmi_keystore.jks cc-perf-test-server-2:~/apache-jmeter-5.5/bin/rmi_keystore.jks
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

Refer [Copy Tokens](../jwt-tokens/)
