helm uninstall elasticsearch --namespace quorum
helm uninstall kibana --namespace quorum
helm uninstall filebeat --namespace quorum
helm uninstall monitoring --namespace=quorum
helm uninstall quorum-monitoring-ingress --namespace quorum

helm uninstall blockscout --namespace quorum
helm uninstall quorum-explorer --namespace quorum
helm uninstall genesis  --namespace quorum
helm uninstall bootnode-1  --namespace quorum
helm uninstall bootnode-2 --namespace quorum
helm uninstall validator-1 --namespace quorum
helm uninstall validator-2 --namespace quorum
helm uninstall validator-4 --namespace quorum
helm uninstall member-1 --namespace quorum
helm uninstall rpc-1 --namespace quorum
helm uninstall quorum-network-ingress --namespace quorum
kubectl delete jobs --all -n quorum
kubectl delete pods --all -n quorum
kubectl delete ConfigMaps --all -n quorum
kubectl delete Secrets --all -n quorum
kubectl delete PersistentVolumeClaims --all -n quorum


