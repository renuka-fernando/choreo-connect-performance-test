## Run Tests

### 1. Reinstall ingress controller and APIM (Optional)

```sh
kubectl delete -f ../k8s-artifacts/apim/ -f ../k8s-artifacts/choreo-connect
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/aws/deploy.yaml

sleep 60
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/aws/deploy.yaml
kubectl apply -f ../k8s-artifacts/apim/ -f ../k8s-artifacts/choreo-connect
```

### 2. Start Servers

SSH to servers and execute the following.

```sh
heap_size="1g"

echo "Start Server"
echo "Heap: ${heap_size}"

cd ./apache-jmeter-5.5/bin
export HEAP="-Xms${heap_size} -Xmx${heap_size}"
nohup ./jmeter-server >> ~/perf_test.out 2>&1 &
echo $! > nohupid.txt
tail ~/perf_test.out -f
cd -
```

### 3. Run Test and Get Results

```sh
nohup ./run-test-jmeter-client.sh -n 'cpu-2' -r '<remote_hosts_1>,<remote_hosts_2>' -i '<ingress_host>' >> ~/perf_test.out 2>&1 &
echo $! > nohupid.txt
tail -f ~/perf_test.out
```

You can derive "Little's law verification" having the following function in a Google Sheet.
```py
<Throughput (Requests/sec)> * <Average Response Time (ms)> / 1000
```
