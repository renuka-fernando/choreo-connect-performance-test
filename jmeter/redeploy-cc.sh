set -e

script_dir=$(dirname "$0")
root_dir="${script_dir}/.."

# Create deployment
cd "${root_dir}/k8s-artifacts"
kubectl delete -f choreo-connect/ -f netty-backend/ || true
kubectl apply -f choreo-connect/ -f netty-backend/

echo ""
echo "Waiting for Deployments..."
kubectl wait --for condition=available --all deploy
echo ""
kubectl get po
echo ""


