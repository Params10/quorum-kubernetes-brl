helm repo add elastic https://helm.elastic.co
helm repo update
helm install elasticsearch --version 7.17.1 elastic/elasticsearch --namespace quorum --create-namespace --values ./values/elasticsearch.yml
helm install kibana --version 7.17.1 elastic/kibana --namespace quorum --values ./values/kibana.yml
helm install filebeat --version 7.17.1 elastic/filebeat  --namespace quorum --values ./values/filebeat.yml
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack --version 34.10.0 --namespace=quorum --create-namespace --values ./values/monitoring.yml --wait
kubectl --namespace quorum apply -f  ./values/monitoring/
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install quorum-monitoring-ingress ingress-nginx/ingress-nginx \
    --namespace quorum \
    --set controller.ingressClassResource.name="monitoring-nginx" \
    --set controller.ingressClassResource.controllerValue="k8s.io/monitoring-ingress-nginx" \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.service.externalTrafficPolicy=Local
kubectl edit -n quorum configmaps quorum-monitoring-ingress-ingress-nginx-controller
kubectl apply -f ../ingress/ingress-rules-monitoring.yml
kubectl -n quorum get services quorum-monitoring-ingress-ingress-nginx-controller
helm dependency update ./charts/blockscout
helm install blockscout ./charts/blockscout --namespace quorum --values ./values/blockscout-besu.yml
helm install quorum-explorer ./charts/explorer --namespace quorum --create-namespace --values ./values/explorer-besu.yaml
helm install genesis ./charts/besu-genesis --namespace quorum --create-namespace --values ./values/genesis-besu.yml
sleep 60
helm install bootnode-1 ./charts/besu-node --namespace quorum --values ./values/bootnode.yml
sleep 60
helm install bootnode-2 ./charts/besu-node --namespace quorum --values ./values/bootnode.yml
sleep 60
helm install validator-1 ./charts/besu-node --namespace quorum --values ./values/validator.yml
sleep 120
helm install validator-2 ./charts/besu-node --namespace quorum --values ./values/validator.yml
sleep 120
helm install validator-3 ./charts/besu-node --namespace quorum --values ./values/validator.yml
sleep 120
helm install validator-4 ./charts/besu-node --namespace quorum --values ./values/validator.yml
sleep 120
#helm install member-1 ./charts/besu-node --namespace quorum --values ./values/txnode.yml
#sleep 60
helm install rpc-1 ./charts/besu-node --namespace quorum --values ./values/reader.yml
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install quorum-network-ingress ingress-nginx/ingress-nginx \
    --namespace quorum \
    --set controller.ingressClassResource.name="network-nginx" \
    --set controller.ingressClassResource.controllerValue="k8s.io/network-ingress-nginx" \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.service.externalTrafficPolicy=Local

kubectl apply -f ../ingress/ingress-rules-besu.yml

