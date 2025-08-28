content = """# StatefulSet trong Kubernetes

## 1. StatefulSet là gì?
- **StatefulSet** là một **controller** trong Kubernetes dùng để quản lý **Pod có trạng thái (stateful)**.  
- Khác với Deployment (dùng cho ứng dụng **stateless** như web server), StatefulSet dùng cho ứng dụng **cần nhận diện Pod duy nhất, lưu trữ dữ liệu ổn định**, ví dụ: **MySQL, PostgreSQL, Kafka, Cassandra, Redis cluster**.  

---

## 2. Đặc điểm chính của StatefulSet
1. **Stable Pod Identity** (Danh tính cố định cho Pod)  
   - Pod do StatefulSet tạo ra có **tên cố định** theo thứ tự:  
     ```
     <statefulset-name>-0, <statefulset-name>-1, <statefulset-name>-2 ...
     ```
   - Ví dụ StatefulSet tên `mysql` và replicas=3 → sẽ có:  
     - mysql-0  
     - mysql-1  
     - mysql-2  

2. **Stable Storage** (Dữ liệu ổn định)  
   - StatefulSet thường đi kèm **PersistentVolumeClaim (PVC)** cho mỗi Pod.  
   - PVC này **gắn cố định** vào Pod, dù Pod bị reschedule sang node khác thì dữ liệu vẫn giữ nguyên.  

3. **Ordered Deployment & Scaling** (Triển khai theo thứ tự)  
   - Khi khởi tạo, Pod được tạo **theo thứ tự** (từ 0 → N).  
   - Khi scale down, Pod bị xóa **ngược thứ tự** (từ N → 0).  
   - Điều này giúp ứng dụng có tính phụ thuộc lẫn nhau (cluster database) hoạt động ổn định.  

4. **Ordered Rolling Updates** (Cập nhật tuần tự)  
   - Khi update image/version, StatefulSet sẽ update **lần lượt từng Pod** → đảm bảo hệ thống không downtime toàn bộ.  

---

## 3. So sánh với Deployment
| Tiêu chí             | Deployment (Stateless)            | StatefulSet (Stateful)                   |
|----------------------|-----------------------------------|------------------------------------------|
| Pod Identity         | Tên Pod ngẫu nhiên                | Tên Pod cố định, có số thứ tự            |
| Storage              | Chia sẻ hoặc không cần            | PVC riêng cho từng Pod                   |
| Scale                | Tăng/giảm Pod đồng loạt           | Tạo/xóa theo thứ tự                      |
| Use Case             | Web server, API, worker stateless | Database, Kafka, Redis cluster, Zookeeper |

---

## 4. Ví dụ YAML StatefulSet (MySQL 3 replicas)
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: "mysql"   # Headless Service
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpass
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumeClaimTemplates:   # PVC tự động cho từng Pod
  - metadata:
      name: mysql-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```
## 5. Khi nào dùng StatefulSet?
- Ứng dụng yêu cầu:
  + Dữ liệu bền vững (không mất khi Pod restart).
  + Pod có danh tính cố định (ví dụ mysql-0 là master, mysql-1 là slave).
  + Triển khai và cập nhật tuần tự.

Ví dụ thực tế:
- MySQL cluster: mysql-0 làm master, mysql-1 và mysql-2 làm replica.
- Kafka: mỗi broker cần ID riêng biệt.
- Zookeeper: quorum đòi hỏi node thứ tự ổn định.

👉 Tóm gọn:
- `StatefulSet = Deployment cho ứng dụng stateful. Nó giúp Pod có tên cố định + dữ liệu ổn định + khởi tạo/scale tuần tự → rất quan trọng khi triển khai database hoặc hệ thống phân tán.`
