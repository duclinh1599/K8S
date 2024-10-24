## `1.Intro`

- `NetworkPolicy` là một cơ chế để kiểm soát luồng lưu lượng mạng trong cụm Kubernetes. Nó cho phép bạn xác định Pod nào của bạn được phép trao đổi lưu lượng mạng.
- Bạn nên sử dụng chúng trong cụm của mình để ngăn các app tiếp cận nhau qua mạng, điều này sẽ giúp hạn chế thiệt hại nếu một trong các app của bạn bị xâm nhập.

_Mỗi `NetworkPolicy` bạn tạo nhắm mục tiêu vào một nhóm Pod và đặt các điểm cuối mạng Ingress (đến) và Egress (đi) mà các Pod đó có thể giao tiếp_.

Có 3 cách xác định rule áp dụng vào đâu:

- Specific Pods (Pods matching a label are allowed)
- Specific Namespaces (all Pods in the namespace are allowed)
- IP address blocks (endpoints with an IP address in the block are allowed)

Một số case cần tới networkpolicy:

- Ensuring a database can only be accessed by the app it’s part of.
- Isolating Pods from your cluster’s network.
- Allow specific apps or namespaces to communicate with each other.

## `2.Config`

Tạo 1 cặp pod và kiểm tra có giao tiếp với nhau hay không:

    $ kubectl run pod1 --image nginx:latest -l app=pod1
    pod/pod1 created

    $ kubectl run pod2 --image nginx:latest -l app=pod2
    pod/pod2 created

Kiểm tra ip của pod vừa tạo

    $ kubectl get pods
    NAME   READY   STATUS    RESTARTS   AGE   IP              NODE       NOMINATED NODE   READINESS GATES
    pod1   1/1     Running   0          59s   10.244.120.70   minikube   <none>           <none>
    pod2   1/1     Running   0          57s   10.244.120.71   minikube   <none>           <none>

Chạy lệnh bên trong pod1 để xác minh nó có thể giao tiếp với pod2:

    $ kubectl exec -it pod1 -- curl 10.244.120.71 --max-time 1
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>

Tạo 1 networkpolicy sau nó sẽ chặn tất cả lưu lượng vào và ra của pod:

    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: network-policy
      namespace: default
    spec:
      podSelector:
        matchLabels:
        app: pod2
      policyTypes:
        - Ingress
        - Egress

Test kết nối lại sẽ báo lỗi:

    $ kubectl exec -it pod1 -- curl 10.244.120.71 --max-time 1
    curl: (28) Connection timed out after 1001 milliseconds
    command terminated with exit code 28

Tiếp theo ta thêm thông tin vào file yaml trên như sau:

    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: network-policy
      namespace: default
    spec:
      podSelector:
        matchLabels:
        app: pod2
      policyTypes:
        - Ingress
        - Egress
      ingress:
        - from:
        - podSelector:
            matchLabels:
                app: pod1
      egress:
        - to:
        - podSelector:
            matchLabels:
                app: pod1

_Chính sách mạng này nêu rõ rằng `pod2` chấp nhận lưu lượng truy cập vào và ra khi đầu bên kia của kết nối là một Pod được gắn nhãn `app=pod1`_

Thử kết nối lại bằng lệnh sau:

    $ kubectl exec -it pod1 -- curl 10.244.120.71 --max-time 1

## `3. Tài liệu tham khảo`

1. https://spacelift.io/blog/kubernetes-network-policy

2. https://viblo.asia/p/restrict-network-trong-k8s-voi-networkpolicy-Eb85ozA4l2G
