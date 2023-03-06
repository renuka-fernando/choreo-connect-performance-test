set -e

script_dir=$(dirname "$0")
root_dir="${script_dir}/.."
cd "${root_dir}/k8s-artifacts"

# Deploy if the deployment is not present
kubectl apply -f choreo-connect/ -f netty-backend/ > /dev/null

# Restart
echo "Restarting Choreo Connect, Netty Backend and Nginx Ingress ..."
kubectl delete po -l app=choreo-connect-adapter > /dev/null || true
kubectl delete po -l app=choreo-connect-deployment > /dev/null || true
kubectl delete po -l app=netty-backend > /dev/null || true
kubectl delete po -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

echo ""
echo "Waiting for Deployments..."
kubectl wait -n ingress-nginx --for condition=available --all --timeout 120s deploy
kubectl wait --for condition=available --all --timeout 120s deploy
echo ""
kubectl get po
echo ""

echo "Waiting 60s to cool down..."
sleep 60
