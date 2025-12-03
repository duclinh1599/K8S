# Ingress NGINX và NetworkPolicy trong Kubernetes

## 1. Ingress NGINX

### 1.1 Ingress là gì?

Ingress là một API object trong Kubernetes cho phép định tuyến
HTTP/HTTPS từ bên ngoài cluster vào các service nội bộ.\
Ingress hỗ trợ: - Host-based routing (theo domain) - Path-based routing
(theo đường dẫn) - TLS termination - Load balancing - Redirect, rewrite
URL

Lưu ý: Ingress cần **Ingress Controller** mới hoạt động.

------------------------------------------------------------------------

### 1.2 Ingress NGINX là gì?

Ingress NGINX là Ingress Controller phổ biến nhất, dùng NGINX làm
reverse proxy & load balancer.

Nhiệm vụ: - Theo dõi các Ingress resource - Sinh file config NGINX tương
ứng - Tự động reload khi cấu hình thay đổi - Điều phối traffic từ bên
ngoài vào service/pod

------------------------------------------------------------------------

### 1.3 Kiến trúc hoạt động của Ingress NGINX

    Client → Ingress Controller (NGINX) → Service → Pod

Ingress NGINX đảm nhận: - Nhận request từ Internet/Load Balancer - Kiểm
tra host + path - Forward về service tương ứng

------------------------------------------------------------------------

### 1.4 Ưu điểm của Ingress NGINX

-   TLS termination mạnh mẽ
-   Rewrite URL dễ dàng
-   Hỗ trợ rate limit, basic-auth
-   Hoạt động ổn định, phổ biến
-   Nhiều annotation tùy biến

------------------------------------------------------------------------

### 1.5 Ví dụ Ingress cơ bản

``` yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: example.local
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: example-service
              port:
                number: 80
```
### 1.6 Cài đặt Ingress NGINX

    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true

- Tham khảo: https://cystack.net/vi/tutorial/cai-dat-nginx-ingress-cho-kubernetes
------------------------------------------------------------------------

## 2. NetworkPolicy trong Kubernetes

### 2.1 NetworkPolicy là gì?

NetworkPolicy là cơ chế bảo mật mạng dùng để kiểm soát traffic: - Pod ↔
Pod\
- Pod ↔ Namespace\
- Pod ↔ Internet

Sau khi enable NetworkPolicy: - Mặc định **pod sẽ bị chặn** trừ khi bạn
cho phép.

------------------------------------------------------------------------

### 2.2 NetworkPolicy dùng để làm gì?

-   Cô lập traffic giữa các ứng dụng
-   Chặn pod không liên quan truy cập database
-   Chống lateral movement trong cluster
-   Tách môi trường dev / staging / prod
-   Hạn chế outbound traffic đi Internet

------------------------------------------------------------------------

### 2.3 Lưu ý quan trọng

NetworkPolicy yêu cầu CNI plugin hỗ trợ:

Hỗ trợ: - **Calico** - **Cilium** - **Kube-router** - **Weave Net**

Không hỗ trợ: - **Flannel (mặc định)**

------------------------------------------------------------------------

### 2.4 Ví dụ: Chỉ cho phép web truy cập database

``` yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-allow-web
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: database
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: web
    ports:
    - protocol: TCP
      port: 3306
```

------------------------------------------------------------------------

### 2.5 Ví dụ: Chặn toàn bộ outbound traffic

``` yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-egress
spec:
  podSelector: {}  # áp dụng cho tất cả pod
  policyTypes:
  - Egress
  egress: []
```

------------------------------------------------------------------------

## 3. So sánh Ingress và NetworkPolicy

  ------------------------------------------------------------------------
  Thành phần                Chức năng                 Phạm vi
  ------------------------- ------------------------- --------------------
  **Ingress NGINX**         Điều phối HTTP/HTTPS từ   Inbound từ Internet
                            bên ngoài vào cluster     

  **NetworkPolicy**         Kiểm soát giao tiếp giữa  Nội bộ + outbound
                            các pod và outbound       
                            traffic                   
  ------------------------------------------------------------------------

------------------------------------------------------------------------

## 4. Khi nào dùng Ingress và NetworkPolicy?

  Tình huống                                    Thành phần
  --------------------------------------------- -------------------
  Expose web-app ra Internet bằng domain        **Ingress NGINX**
  Giới hạn database chỉ cho phép web truy cập   **NetworkPolicy**
  Chống traffic không mong muốn giữa các pod    **NetworkPolicy**
  Tách biệt dev / staging / prod                **NetworkPolicy**
  Định tuyến host/path                          **Ingress NGINX**

------------------------------------------------------------------------

## 5. Kết luận

-   **Ingress NGINX** phù hợp cho việc expose ứng dụng ra ngoài theo
    domain, path, SSL.
-   **NetworkPolicy** dùng để bảo vệ nội bộ cluster theo mô hình
    Zero-Trust.

Hai thành phần này bổ sung cho nhau để đảm bảo: - Traffic vào: **đúng
tuyến -- an toàn -- có kiểm soát** - Traffic trong cluster: **được cô
lập -- được kiểm soát chặt chẽ**
