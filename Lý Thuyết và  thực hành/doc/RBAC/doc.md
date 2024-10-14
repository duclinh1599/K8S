## 1. `BRAC (Role-Based Access Control) là gì?`

- Phương pháp quản lý quyền truy cập vào hệ thống và dữ liệu dựa trên vai trò của người dùng trong tổ chức.

- RBAC gán quyền cho các vai trò cụ thể và sau đó chỉ định các vai trò này cho người dùng

=> _Điều này giúp đơn giản hóa việc quản lý quyền truy cập và tăng cường bảo mật hệ thống._

## 2. `RBAC hoạt động dựa trên 3 khái niệm chính: người dùng, vai trò và quyền`

- Người dùng (Users): Là các cá nhân hoặc các hệ thống có nhu cầu truy cập vào tài nguyên của tổ chức.

- Vai trò (Roles): Là các tập hợp quyền được xác định trước, phản ánh các nhiệm vụ và trách nhiệm khác nhau trong tổ chức.
  
- Quyền (Permissions): Là các quyền truy cập cụ thể vào các tài nguyên hoặc hành động, chẳng hạn như đọc, ghi, sửa đổi hoặc xóa dữ liệu.

## 3. `Một số lợi ích RBAC`

- Quản lý đơn giản hơn: Thay vì quản lý quyền truy cập cho từng người, quản trị viên chỉ cần qlý các vai trò và gán các vai trò này cho user.

- Bảo mật nâng cao: RBAC giúp giảm nguy cơ truy cập trái phép bằng cách chỉ cung cấp quyền truy cập cần thiết cho từng vai trò cụ thể.
  
- Tuân thủ quy định: Nhiều tiêu chuẩn bảo mật và quy định pháp lý yêu cầu việc kiểm soát chặt chẽ quyền truy cập vào dữ liệu nhạy cảm -> RBAC giúp các tổ chức tuân thủ những yêu cầu này.
  
- Hiệu quả hơn: RBAC giúp giảm bớt gánh nặng quản lý và tăng cường hiệu quả làm việc của nhân viên CNTT.

## 4. `Cách thức triển khai RBAC cho hệ thống.`

### ĐỂ triển khai RBAC ta cần thực hiện 1 số bước:

- Phân tích hệ thống: Xác định các vai trò cần thiết trong hệ thống và các quyền truy cập liên quan đến từng vai trò.
  
- Xác định quyền truy cập: Xác định các quyền truy cập cần thiết cho từng vai trò, bao gồm quyền truy cập vào các tài nguyên và hành động cụ thể.
  
- Gán vai trò cho người dùng: Gán các vai trò đã xác định cho người dùng tương ứng trong tổ chức.
  
- Thiết lập hệ thống: Cấu hình hệ thống để thực thi RBAC, bao gồm việc tạo các vai trò và quyền truy cập trong hệ thống quản lý quyền truy cập.

## 5. `Hạn chế.`

- Vai trò: Việc xác định các vai trò và quyền truy cập phù hợp đòi hỏi phân tích chi tiết và có thể phức tạp trong các tổ chức lớn.
  
- Quản lý thay đổi: Quyền truy cập và vai trò của người dùng có thể thay đổi theo thời gian và việc duy trì RBAC đòi hỏi sự cập nhật liên tục.
  
- Đào tạo và nhận thức: Nhân viên cần được đào tạo về cách thức hoạt động của RBAC và cách sử dụng nó một cách hiệu quả.

## 6. `Cấu hình`

https://viblo.asia/p/kubernetes-series-bai-13-serviceaccount-and-role-based-access-control-security-kubernetes-api-server-07LKXQD4ZV4
