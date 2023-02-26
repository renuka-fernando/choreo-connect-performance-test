set -e
script_dir=$(dirname "$0")
root_dir="${script_dir}/.."
# Change directory to make sure logs directory is created inside $script_dir
cd $script_dir

test_name="cpu-1"
user_count=10
# heap_size="500m"
heap_size="1g"
duration=1200
payload_size=50B
host=3.141.180.55
remote_hosts=""

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 [-n test_name>] [-u <user_count>] [-s <payload_size>] [-r <remote_hosts>]"
    echo ""
    echo "-n: Test Name."
    echo "-u: User Count."
    echo "-s: The Payload Size."
    echo "-r: Remote Servers."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "n:u:s:r:h" opts; do
    case $opts in
    n)
        test_name=${OPTARG}
        ;;
    u)
        user_count=${OPTARG}
        ;;
    s)
        payload_size=${OPTARG}
        ;;
    r)
        remote_hosts=${OPTARG}
        ;;
    h)
        usage
        exit 0
        ;;
    \?)
        usage
        exit 1
        ;;
    esac
done

if [[ -z $user_count ]]; then
    echo "Please specify user count."
    exit 1
fi

if [[ -z $payload_size ]]; then
    echo "Please specify payload size."
    exit 1
fi

if [[ -z $remote_hosts ]]; then
    echo "Please specify remote hosts."
    exit 1
fi

# Local Machine
## Create deployment
cd "${root_dir}/k8s-artifacts"
kubectl delete -f choreo-connect/ -f netty-backend/ || true
kubectl apply -f choreo-connect/ -f netty-backend/

echo ""
echo "Waiting for Deployments..."
kubectl wait --for condition=available --all deploy
echo ""
kubectl get po
echo ""

results_dir="${root_dir}/results/${test_name}/passthrough/${heap_size}_heap/${user_count}_users/${payload_size}/0ms_sleep"
echo "Results Dir: ${results_dir}"
mkdir -p ${results_dir}
kubectl top po --containers > "${results_dir}/start-resources.txt"
nohup sh -c "sleep 600 && kubectl top po --containers > ${results_dir}/middle-resources.txt" > /dev/null &

# Client
ssh cc-perf-test-client \
    heap_size=$heap_size user_count=$user_count payload_size=$payload_size duration=$duration host=$host remote_hosts=$remote_hosts test_name=$test_name \
    'bash -s' <<'ENDSSH'
echo ""
echo "Start Test"
echo "HOME: ${HOME}"
echo "Heap: ${heap_size}"
echo "Users: ${user_count}"
echo "Paylod: ${payload_size}"

export HEAP="-Xms${heap_size} -Xmx${heap_size}"

results_dir="${HOME}/results/${test_name}/passthrough/${heap_size}_heap/${user_count}_users/${payload_size}/0ms_sleep"
echo "Results Dir: ${results_dir}"
rm -rf ${results_dir}

user_count_per_server=$(($user_count / 2))
echo "Users per server: ${user_count_per_server}"

cd ./apache-jmeter-5.5/bin
./jmeter -n -t ${HOME}/apim-test.jmx \
    -j "${results_dir}/jmeter.log" \
    -Gusers=$user_count_per_server \
    -Gduration=$duration \
    -Ghost=$host \
    -GhostHeader=gw.wso2.com \
    -Gport=443 \
    -Gpath=/echo/1.0.0 \
    -Gpayload="${HOME}/${payload_size}.json" \
    -Gresponse_size=$payload_size \
    -Gprotocol=https \
    -Gtokens=${HOME}/jwt-tokens-${user_count}.csv \
    -l "${results_dir}/results.jtl" \
    -R "${remote_hosts}"

cd "$results_dir"
java -jar ~/jtl-splitter-0.4.6-SNAPSHOT.jar -f results.jtl -p -s -u MINUTES -t 5

tar -czf results.jtl.gz results.jtl
rm results.jtl
rm results-warmup.jtl
rm results-warmup-summary.json
rm results-measurement.jtl

echo ""
echo ""
echo "####################### RESULTS "#######################"
echo ""
cat results-measurement-summary.json
ENDSSH

kubectl top po --containers > "${results_dir}/end-resources.txt"

echo ""
echo ""
echo "Resources"
echo ""
echo "Start"
cat "${results_dir}/start-resources.txt"
echo ""
echo "10 min"
cat "${results_dir}/middle-resources.txt"
echo ""
echo "End"
cat "${results_dir}/end-resources.txt"