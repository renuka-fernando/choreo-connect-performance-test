## Run Tests

### 1. Start Servers

SSH to servers and execute the following.

```sh
heap_size="4g"

echo "Start Server"
echo "Heap: ${heap_size}"

cd ./apache-jmeter-5.5/bin
export HEAP="-Xms${heap_size} -Xmx${heap_size}"
nohup ./jmeter-server >> ~/perf_test.out 2>&1 &
echo $! > nohupid.txt
tail ~/perf_test.out -f
cd -
```

### 2. Run Test and Get Results

```sh
nohup ./run-test-jmeter-client.sh -n 'cpu-1' -r '<remote_hosts_1>,<remote_hosts_2>' -i '<ingress_host>' >> ~/perf_test.out 2>&1 &
echo $! > nohupid.txt
tail -f ~/perf_test.out
```

You can derive "Little's law verification" having the following function in a Google Sheet.
```py
<Throughput (Requests/sec)> * <Average Response Time (ms)> / 1000
```
