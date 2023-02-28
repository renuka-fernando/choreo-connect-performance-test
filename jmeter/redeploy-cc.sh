set -e

script_dir=$(dirname "$0")
root_dir="${script_dir}/.."

# Create deployment
cd "${root_dir}/k8s-artifacts"
kubectl delete -f choreo-connect/ -f netty-backend/ > /dev/null || true
kubectl delete po -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

echo "Waiting 30s to cool down..."
sleep 30
kubectl apply -f choreo-connect/ -f netty-backend/ > /dev/null

echo ""
echo "Waiting for Deployments..."
kubectl wait -n ingress-nginx --for condition=available --all --timeout 120s deploy
kubectl wait --for condition=available --all --timeout 120s deploy
echo ""
kubectl get po
echo ""

echo "Waiting 60s to cool down..."
sleep 60
