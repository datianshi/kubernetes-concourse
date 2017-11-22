# Deploy Concourse CI To Kubernetes Cluster

## Postgres DB

Postgres Database is concourse management plane backend

```kubectl create -f postgres.yml```

## Web pod (ATC and TSA)

web consume postgres cluster ip through kubernates dns. It also creates an internal Cluster IP service so worker can register.

```kubectl create -f web.yml```

## Worker pod

```kubectl create -f worker.yml```

## Expose concourse cluster with a NODE IP

```kubectl create -f nodeport.yml```

## Access Concourse

```
kubectl get service
concourse-external       NodePort    10.100.200.214   <none>        8080:30668/TCP    2h
```

fly -t atc login -c http://NODE_IP:30668

## Future work

* Expose concourse cluster through IAAS specific Load Balancer instead of NODE IP:Random_Port

* Use [Statefulsets ](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) and IAAS [Storerage Class](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) to configure a persisted HA postgres cluster

* Resource Limitation on postgres, worker, and web
