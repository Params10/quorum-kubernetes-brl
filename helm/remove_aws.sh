kubectl delete svc --all -n quorum
kubectl delete ConfigMaps --all -n quorum
kubectl delete Secrets --all -n quorum
kubectl delete PersistentVolumeClaims --all -n quorum
kubectl delete StorageClasses --all -n quorum
kubectl delete pods --all -n quorum
kubectl delete jobs --all -n quorum
kubectl delete Ingresses --all -n quorum
kubectl delete IngressClasses --all -n quorum
kubectl delete Deployments --all -n quorum
kubectl delete StatefulSets --all -n quorum