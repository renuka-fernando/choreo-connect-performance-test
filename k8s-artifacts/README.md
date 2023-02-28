1.  Install ingress nginx.
    ```sh
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/aws/deploy.yaml
    ``` 
2.  Install AWS k8s metrics service
    https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
    ```sh
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    ```
