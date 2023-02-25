### Start Servers

ssh to servers and execute below

```sh
heap_size="500m"

echo "Start Server"
echo "Heap: ${heap_size}"

cd ./apache-jmeter-5.5/bin
export HEAP="-Xms${heap_size} -Xmx${heap_size}"
./jmeter-server
cd -
```
