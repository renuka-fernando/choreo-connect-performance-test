set -e
script_dir=$(dirname "$(readlink -f "$0")")

heap_size="1g"
user_count=10
payload_size=50B
duration=1200
ingress_host=
jmeter_servers=""
results_dir=""

function usage() {
    echo ""
    echo "Usage: "
    echo "$0 [-m heap_size] [-u <user_count>] [-p <payload_size>] [-d <duration>] [-i <ingress_host>] [-s <jmeter_servers>] [-r <results_dir>]"
    echo ""
    echo "-m: Heap Size."
    echo "-u: User Count."
    echo "-p: The Payload Size."
    echo "-d: Duration."
    echo "-i: Ingress Host."
    echo "-s: Remote Servers."
    echo "-r: Results Dir."
    echo "-h: Display this help and exit."
    echo ""
}

while getopts "m:u:p:d:i:s:r:h" opts; do
    case $opts in
    m)
        heap_size=${OPTARG}
        ;;
    u)
        user_count=${OPTARG}
        ;;
    p)
        payload_size=${OPTARG}
        ;;
    d)
        duration=${OPTARG}
        ;;
    i)
        ingress_host=${OPTARG}
        ;;
    s)
        jmeter_servers=${OPTARG}
        ;;
    r)
        results_dir=${OPTARG}
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

if [[ -z $jmeter_servers ]]; then
    echo "Please specify remote hosts."
    exit 1
fi

if [[ -z $ingress_host ]]; then
    echo "Please specify ingress hosts."
    exit 1
fi

echo ""
echo "Start Test"
echo "HOME: ${HOME}"
echo "Heap: ${heap_size}"
echo "Users: ${user_count}"
echo "Payload: ${payload_size}"
echo "Results Dir: ${results_dir}"

export HEAP="-Xms${heap_size} -Xmx${heap_size}"

user_count_per_server=$(($user_count / 2))
echo "Users per server: ${user_count_per_server}"

set -x
cd "${HOME}/apache-jmeter-5.3/bin"
./jmeter -n -t "${script_dir}/apim-test.jmx" \
    -j "${results_dir}/jmeter.log" \
    -Gusers="$user_count_per_server" \
    -Gduration="$duration" \
    -Ghost="$ingress_host" \
    -GhostHeader=gw.wso2.com \
    -Gport=443 \
    -Gpath=/echo/1.0.0/ \
    -Gpayload="${HOME}/${payload_size}.json" \
    -Gresponse_size="$payload_size" \
    -Gprotocol=https \
    -Gtokens="${HOME}/jwt-tokens-${user_count}.csv" \
    -l "${results_dir}/results.jtl" \
    -R "${jmeter_servers}"
set +x

cd "$results_dir"
java -jar "${script_dir}/../jtl-splitter/jtl-splitter-0.4.6-SNAPSHOT.jar" -f results.jtl -p -s -u MINUTES -t 5

tar -czf results.jtl.gz results.jtl
rm results.jtl
rm results-warmup.jtl
rm results-warmup-summary.json
rm results-measurement.jtl

echo ""
echo ""
echo "############## RESULTS ##############"
echo ""
cat results-measurement-summary.json
echo ""

echo "############## RESULTS SUMMARY ##############"
echo "Users: ${user_count}"
echo "Payload: ${payload_size}"
echo ""

# print as a table
columns='["Total","AGV","TPS","ERR%","ERR","90th","95th","99th"]'
separator='["------","------","------","------","------","------","------","------"]'
column_values='([."HTTP Request".samples, ."HTTP Request".mean, ."HTTP Request".throughput, ."HTTP Request".errorPercentage, ."HTTP Request".errors, ."HTTP Request".p90, ."HTTP Request".p95, ."HTTP Request".p99])'

jq -r "${columns}, ${separator}, ${column_values} | @tsv" < results-measurement-summary.json
echo ""
