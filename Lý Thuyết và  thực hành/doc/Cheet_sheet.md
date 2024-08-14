## 0. Command thông dụng

        kubectl run --generator=run-pod/v1 --rm mytest --image=yauritux/busybox-curl -it

        kubectl run my-nginx --restart=Never --image=nginx --port=80 --expose : Chạy NGINX và expose nó

        kubectl run my-nginx --image=nginx --port=80 --expose

        kubectl get nodes --show-labels

        kubectl get pods -l owner=denny

        kubectl label pods dummy-input owner=denny

        kubectl scale --replicas=3 deployment/nginx-app

        kubectl rollout app-v1 app-v2 --image=img:v2

        kubectl rollout app-v1 app-v2 --rollback

        kubectl rollout status deployment/nginx-app - Check update status

        kubectl rollout history deployment/nginx-app - Check update history

        kubectl rollout pause/resume deployment/nginx-deployment

        kubectl rollout undo deployment/nginx-deployment -Quay lại version trước

## 1. Cluster managament

        Kubectl cluster-info : Hiển thị thông tin điểm cuối về máy chủ và dịch vụ trong cụm

        Kubectl version

        Kubectl config view : lấy config của cụm

        kubectl api-resources

        kubectl get all --all-namespaces :list tất cả mọi thứ

## 2. Daemonsets (ds)

        kubectl get daemonset : list 1 or nhiều daemonset

        kubectl edit daemonset <daemonset_name> : Chỉnh sửa và cập nhật định nghĩa của một hoặc nhiều daemonset

        kubectl delete daemonset <daemonset_name>

        kubectl create daemonset <daemonset_name>

        kubectl rollout daemonset

        kubectl describe ds <daemonset_name> -n <namespace_name>

## 3. Deployment (deploy)

    kubectl get deployment/deploy

    kubetctl edit deployment <deployment_name>

    kubectl create/delete/describe deployment <deployment_name>

    kubectl rollout status deployment <deployment_name> - trang thái deployment

    kubectl set image deployment/<deployment name> <container name>=image:<new image version> - update image của container version mới

    kubectl rollout undo deployment/<deployment name> - Quay lại deployment trước đó.

    kubectl replace --force -f <configuration file> - Thực hiện Deployment thay thế, buộc thay thế, xoá rồi tạo lại resource.

## 4. Events

    kubectl get events

    kubectl get events --field-selector type=Warning – Chỉ liệt kê cảnh báo.

    kubectl get events --sort-by=.metadata.creationTimestamp – Liệt kê các sự kiện được sắp xếp theo dấu thời gian.

    kubectl get events --field-selector involvedObject.kind!=Pod– Liệt kê các sự kiện nhưng không bao gồm các sự kiện Pod.

## 5. log

    kubectl logs <pod_name>

    kubectl logs --since=6h <pod_name>– logs trong 6 giờ qua cho một pod.

    kubectl logs -f <service_name> [-c <$container>] – Nhận nhật ký từ một dịch vụ và tùy ý chọn vùng chứa.

    kubectl logs -c <container_name> <pod_name>– In nhật ký cho một container trong một pod.

## 6. NameSpace

    kubectl create namespace <namespace_name>

    kubectl get namespace <namespace_name>

    kubectl describe/delete/edit/top namespace <namespace_name>

## 7. Node

    kubectl taint node <node_name> – Update the taints on one or more nodes.

    kubectl delete/top node <node_name>

    kubectl get pods -o wide | grep <node_name> – Pods running on a node.

    kubectl annotate node <node_name> – Annotate a node.

    kubectl cordon/uncordon node <node_name>

## 8. Pod

    kubectl get pods --field-selector=status.phase=Running – Get all running pods in the namespace.

    kubectl delete/describe/create pod <pod_name>

    kubectl exec <pod_name> -c <container_name> <command>

    kubectl exec -it <pod_name> /bin/sh

    kubectl port-forward <pod name> <port number to listen on>:<port number to forward to>

## 9. Secrets

    kubectl create secret – Create a secret.

    kubectl get/describe/delete secrets

## 10. Service

    kubectl get services

    kubectl expose deployment [deployment_name] – Expose a
    replication controller, service, deployment, or pod as a new Kubernetes service.

    kubectl edit services
