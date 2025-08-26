# Sidecar trong Kubernetes — 20% kiến thức cốt lõi nắm 80% bản chất

---

## 🔑 1. Định nghĩa cơ bản
- **Sidecar container** là một container chạy **cùng Pod** với container chính (main app).  
- Nó **không thay thế** container chính, mà bổ sung các chức năng hỗ trợ (logging, monitoring, proxy, config reload...).  

📌 *Tư duy*: **Ứng dụng chính làm việc chính, sidecar làm trợ lý.**

---

## 🔑 2. Đặc điểm quan trọng
- **Chia sẻ tài nguyên Pod**: cùng network namespace, có thể giao tiếp qua `localhost`, và có thể chia sẻ volume.  
- **Được quản lý cùng Pod**: tạo, xóa, scale đồng bộ với Pod chính.  
- **Không tách biệt** như service riêng (nếu sidecar chết, pod có thể restart).  

📌 *Tư duy*: **Cả Pod là một đơn vị triển khai, sidecar chỉ là thành phần trong đó.**

---

## 🔑 3. Các use-case điển hình (80% gặp trong thực tế)
1. **Logging/Monitoring agent**  
   - Ví dụ: Fluentd sidecar tail log file rồi gửi về Elasticsearch.  
2. **Proxy / Service Mesh**  
   - Ví dụ: Envoy sidecar trong Istio để quản lý traffic.  
3. **Configuration updater**  
   - Container phụ theo dõi ConfigMap/Secret, cập nhật file config cho container chính.  
4. **Data sync / backup**  
   - Sidecar đồng bộ dữ liệu từ main container sang object storage (S3, MinIO…).  

📌 *Tư duy*: **Ứng dụng chính tập trung vào business logic, sidecar lo việc phụ trợ.**

---

## 🔑 4. So sánh với các mô hình khác
- **Init container**: chạy trước rồi thoát, dùng để chuẩn bị môi trường.  
- **Sidecar container**: chạy song song, liên tục hỗ trợ main container.  

📌 *Tư duy*: **Init = chuẩn bị, Sidecar = đồng hành.**

---

## 🔑 5. Khi nào nên dùng / không nên dùng
✅ **Dùng khi**:  
- Cần bổ sung **cross-cutting concerns** (logging, monitoring, security, proxy) mà không muốn chỉnh sửa ứng dụng.  
- Muốn tách biệt rõ ràng logic chính và logic phụ trợ.  

❌ **Không nên dùng khi**:  
- Sidecar **nặng nề** → tăng resource usage.  
- Chức năng có thể được quản lý **ở cluster level** (ví dụ: logging DaemonSet thay vì sidecar).  

📌 *Tư duy*: **Chỉ dùng sidecar khi logic phụ phải đi cùng ứng dụng.**

---

## 📌 Tóm tắt
Để hiểu **80% nội dung cốt lõi về Sidecar** trong K8s, bạn chỉ cần nắm:
1. Nó là container phụ trong Pod.  
2. Chia sẻ network/volume với container chính.  
3. Use-case chính: logging, monitoring, proxy, config updater.  
4. Phân biệt với Init container.  
5. Biết khi nào nên/không nên dùng.  
