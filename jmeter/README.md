## Run Tests

### 1. Start Servers

SSH to servers and execute the following.

```sh
heap_size="1g"

echo "Start Server"
echo "Heap: ${heap_size}"

cd ./apache-jmeter-5.5/bin
export HEAP="-Xms${heap_size} -Xmx${heap_size}"
./jmeter-server
cd -
```

### 2. Run Test and Get Results

```sh
./run-test.sh -u 10 -s 50B -n 'cpu-1' -r <remote_hosts>
```

You can derive "Little's law verification" having the following function in a Google Sheet.
```py
<Throughput (Requests/sec)> * <Average Response Time (ms)> / 1000
```
