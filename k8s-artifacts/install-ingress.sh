# Used the v1.1.3

## Latest
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/aws/deploy.yaml

## Ingress used for CC 1.1.0-Beta
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/aws/deploy.yaml

## Ingress used for CC 1.0.0-Beta
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/aws/deploy.yaml

## Request large amount of CPU for nginx
kubectl set resources deployment -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx --requests=cpu=3000m,memory=1000Mi
