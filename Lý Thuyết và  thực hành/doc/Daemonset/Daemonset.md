# DaemonSet trong Kubernetes

## 🔹 DaemonSet là gì?
DaemonSet là một loại **Kubernetes controller** đảm bảo rằng một pod cụ thể sẽ chạy trên **tất cả** hoặc một số node trong cluster.

### 📌 **Tính năng của DaemonSet:**
- Đảm bảo mỗi node có **một pod duy nhất** chạy ứng dụng được chỉ định.
- Khi có node mới tham gia cluster, DaemonSet sẽ tự động tạo pod trên node đó.
- Khi node bị xóa khỏi cluster, các pod của DaemonSet trên node đó cũng bị xóa.
- **Pod của DaemonSet không bị xóa khi dùng `kubectl drain --ignore-daemonsets`**, vì Kubernetes coi chúng là cần thiết để đảm bảo hệ thống hoạt động ổn định.

---

## 🔹 **Ví dụ về DaemonSet**

### **1. Triển khai một DaemonSet với Fluentd**
Fluentd thường được triển khai dưới dạng DaemonSet để thu thập log từ tất cả các node.

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-logging
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd
        resources:
          limits:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

### 🔹 **Giải thích:**
- Mỗi node trong cluster sẽ có một pod Fluentd chạy, giúp thu thập log từ `/var/log` trên node.
- `hostPath: /var/log` giúp pod truy cập thư mục log của node.
- **DaemonSet sẽ đảm bảo có một pod Fluentd trên mỗi node.**

---

## 🔹 **2. Khi nào sử dụng DaemonSet?**
✅ Khi cần chạy **một pod trên tất cả các node**, ví dụ:
- Thu thập log (Fluentd, Filebeat).
- Thu thập số liệu hệ thống (Prometheus Node Exporter, Telegraf).
- Các chương trình giám sát và bảo mật (Falco, Cilium).
- Network plugins (Calico, CNI).

---

## 🔹 **Quản lý DaemonSet**

📌 **Tạo DaemonSet**  
```bash
kubectl apply -f fluentd-daemonset.yaml
```

📌 **Xem danh sách DaemonSet**  
```bash
kubectl get daemonset -A
```

📌 **Xóa DaemonSet**  
```bash
kubectl delete daemonset fluentd -n kube-logging
```

📌 **Xem pod của DaemonSet chạy trên node nào**  
```bash
kubectl get pods -o wide -n kube-logging
```

---

## 🔹 **Tóm lại**
- DaemonSet giúp đảm bảo một pod chạy trên tất cả hoặc một nhóm node.
- Dùng cho logging, monitoring, networking, security.
- Không bị ảnh hưởng khi dùng `kubectl drain --ignore-daemonsets`.
