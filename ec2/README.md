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
scp ./rmi_keystore.jks cc-perf-test-server-1:~/apache-jmeter-5.5/bin/rmi_keystore.jks
scp ./rmi_keystore.jks cc-perf-test-server-2:~/apache-jmeter-5.5/bin/rmi_keystore.jks
```

Copy test plan to the client.
```sh
scp ../jmeter/apim-test.jmx cc-perf-test-client:~
```

