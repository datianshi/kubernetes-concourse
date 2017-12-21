# Deploy Concourse CI To Kubernetes Cluster

### Using vSphere Storage Class

Assume the kubernetes cluster has vsphere provider. Below command is able to provision a disk through vCenter and mount to the postgres pod. When the pod is recreated, the storage is treated as persistant storage and all the pipelines/meta data still exist

```bash
kubectl create -f vsphere/storage-class.yml
kubectl create -f vsphere/postgres-volume-claim.yml
```

### Using GCP Storage Class

It is coming......

### Using AWS Storage Class

```bash
kubectl create -f aws/storage-class.yml
kubectl create -f aws/postgres-volume-claim.yml
```

### Using Minikube hostpath Storage Class

```bash
kubectl create -f minikube/postgres-volume-claim.yml
```

## Postgres DB

Postgres Database is concourse management plane backend

```kubectl create -f postgres.yml```


## Web pod (ATC and TSA)

web consume postgres cluster ip through kubernetes dns. It also creates an internal Cluster IP service so worker can register.

```kubectl create -f web.yml```

## Worker pod

```kubectl create -f worker.yml```

## Access Concourse

### Use NODE IP to access

  ```kubectl create -f nodeport.yml```

  ```
  kubectl get service
  concourse-external       NodePort    10.100.200.214   <none>        8080:30668/TCP    2h
  ```

  fly -t atc login -c http://NODE_IP:30668

### AWS ELB  

  ```bash
  kubectl create -f aws/elb.yml
  ```
  ```
  kubectl describe service concourse-external | grep 'LoadBalancer Ingress'
  LoadBalancer Ingress:     a7f8d86aed20211e7886906e5f61a9c9-952285343.us-west-2.elb.amazonaws.com
  fly -t atc login -c https://a7f8d86aed20211e7886906e5f61a9c9-952285343.us-west-2.elb.amazonaws.com
  ```
### NSX Load Balancer

  ```bash
  kubectl create -f vsphere/nsx-lb.yml
  kubectl describe service concourse-external | grep 'LoadBalancer Ingress'
  LoadBalancer Ingress:     10.193.54.218
  fly -t atc login -c http://10.193.54.218:8080
  ```

### Minikube
For A Minikube based Kubernetes cluster, use the following handy script to get the Concourse IP/Port

```bash
MINIKUBE_IP=$(minikube ip)
EXTERNAL_PORT=$(kubectl get services concourse-external -o json | jq ".spec.ports[0].nodePort")
CONCOURSE_URL="http://${MINIKUBE_IP}:${EXTERNAL_PORT}"
echo "Concourse Url: ${CONCOURSE_URL}"
fly -t atc login -c $CONCOURSE_URL
```

## Future work

* Expose concourse cluster through IAAS specific Load Balancer instead of NODE IP:Random_Port

* Use [Statefulsets ](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) and IAAS [Storerage Class](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) to configure a persisted HA postgres cluster

* Resource Limitation on postgres, worker, and web
