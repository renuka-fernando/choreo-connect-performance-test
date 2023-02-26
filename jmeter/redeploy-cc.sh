set -e

script_dir=$(dirname "$0")
root_dir="${script_dir}/.."

# Create deployment
cd "${root_dir}/k8s-artifacts"
kubectl delete -f choreo-connect/ -f netty-backend/ > /dev/null || true
kubectl apply -f choreo-connect/ -f netty-backend/ > /dev/null

echo ""
echo "Waiting for Deployments..."
kubectl wait --for condition=available --all --timeout 120s deploy
echo ""
kubectl get po
echo ""

echo "Waiting 30s to cool down..."
sleep 30
