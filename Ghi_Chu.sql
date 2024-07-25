- Lệnh tạo pod
    kubectl run <pod name> --image=<image name> --port=<port to expose>
- Expose 
    kubectl expose pod hello-kube --type=LoadBlancer --port=80
    kubectl expose <resource kind to expose> <resource name> --type=<type of service to create> --port=<port to expose>
- Để truy cập vào bằng web
    minikube service hello-kube url






--------Replicaset----------




---------Deployment----------
- Lệnh chạy file yml: 
    kubectl apply -f .yml
- Lệnh kiểm tra deployment
    kubectl get deployments
- Kiểm tra status triển khai:
    kubectl rollout status deployment
- Kiểm tra log pod/service/deployment:
    kubectl logs <pod>

    
-----Tham Khao-----
https://www.freecodecamp.org/news/the-kubernetes-handbook/
https://www.freecodecamp.org/news/the-docker-handbook/
https://www.geeksforgeeks.org/kubernetes-tutorial/?ref=lbp ( tutorial )
https://www.geeksforgeeks.org/kubectl-cheatsheet/ ( Tổng hợp lệnh K8s)

https://viblo.asia/p/k8s-basic-cai-dat-lab-kubernetes-phan-1-3kY4gWdy4Ae
