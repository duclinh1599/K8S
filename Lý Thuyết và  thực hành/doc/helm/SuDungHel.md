1. Lợi ích từ Helm

- Deployment đơn giản hơn mang tính chất lặp lại với chỉ vài câu lệnh ngắn
- Quản lý sự phụ thuộc của ứng dụng với các version cụ thể
- Thực hiện nhiều deployment với các môi trường khác nhau như: test, staging, production ...
- Dễ dàng update rollback và test deployment khi có vấn đề xảy ra hay muốn cập nhật phiên bản mới (zero downtime server)

2. Helm chart là gì?

- Helm là một trình quản lý gói và công cụ quản lý ứng dụng cho Kubernetes, nó đóng gói nhiều tài nguyên Kubernetes vào một đơn vị triển khai logic duy nhất được gọi là Chart.

- Bên trong của Chart sẽ có phần chính là các "template, là định nghĩa các tài nguyên sẽ triển khai lên k8s.

- Để deploy một app lên k8s mình cần tạo 3 file yaml gồm deployment.yaml, service.yaml và ingress.yaml. Các file này định nghĩa rõ ràng các tham số cấu hình cho việc triển khai ứng dụng. Tuy nhiên khi cần thay đổi tham số thì việc sử dụng các file đó sẽ trở nên cồng kềnh và khó kiểm soát, không có quản lý version trên k8s.

- Còn khi dùng helm, thì ta sẽ có các file tương tự như vậy nhưng ở dạng "template", tức là nó ở mức độ linh động hơn.

- Khung các file cơ bản vẫn vậy nhưng thay vì các gtri cụ thể như ban đầu thì nó sẽ kết hợp với các "gtri" được khai báo từ 1 file value.yaml trong helm chart --> ra file yaml cuối cùng để apply vào hệ thống
