#GKE
helm repo add elastic https://helm.elastic.co
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
cd charts
helm install blockscout ./blockscout --namespace quorum --create-namespace --values ./blockscout/values.yaml
helm repo update
cd ..
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack --version 34.10.0 --namespace=quorum --create-namespace --values ./values/monitoring.yml --wait
kubectl --namespace quorum apply -f  ./values/monitoring/
helm install genesis ./charts/besu-genesis --namespace quorum --create-namespace --values ./values/genesis-besu.yml
sleep 60
helm install bootnode-1 ./charts/besu-node --namespace quorum --values ./values/bootnode.yml
sleep 60
helm install bootnode-2 ./charts/besu-node --namespace quorum --values ./values/bootnode.yml
sleep 60
helm install validator-1 ./charts/besu-node --namespace quorum --values ./values/validator.yml
# helm install validator-2 ./charts/besu-node --namespace quorum --values ./values/validator.yml
# helm install validator-3 ./charts/besu-node --namespace quorum --values ./values/validator.yml
# helm install validator-4 ./charts/besu-node --namespace quorum --values ./values/validator.yml
# helm install member-1 ./charts/besu-node --namespace quorum --values ./values/txnode.yml
# helm install rpc-1 ./charts/besu-node --namespace quorum --values ./values/reader.yml
# helm install quorum-monitoring-ingress ingress-nginx/ingress-nginx \
#     --namespace quorum \
#     --set controller.ingressClassResource.name="monitoring-nginx" \
#     --set controller.ingressClassResource.controllerValue="k8s.io/monitoring-ingress-nginx" \
#     --set controller.replicaCount=1 \
#     --set controller.nodeSelector."kubernetes\.io/os"=linux \
#     --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
#     --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
#     --set controller.service.externalTrafficPolicy=Local
# kubectl apply -f ../ingress/ingress-rules-besu.yml

