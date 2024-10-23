## `Node Affinity`

### 1. Introduce

- Node Affinity cho phép bạn chỉ định rằng một pod chỉ nên được lên lịch trên các node đáp ứng các điều kiện cụ thể (tương tự như NodeSelector nhưng linh hoạt hơn).
- Node Affinity sử dụng nhãn (label) của các node để quyết định pod sẽ được đặt ở đâu.
- Node Affinity có hai loại:

  - `RequiredDuringSchedulingIgnoredDuringExecution`: Bắt buộc. Nếu không có node nào khớp với điều kiện, pod sẽ không được lên lịch.
  - `PreferredDuringSchedulingIgnoredDuringExecution`: Ưu tiên. Kubernetes sẽ cố gắng đặt pod trên các node khớp điều kiện, nhưng nếu không có node nào phù hợp, nó vẫn có thể lên lịch ở các node khác.

### 2. Config

#### requiredDuringSchedulingIgnoredDuringExecution:

    apiVersion: v1
    kind: Pod
    metadata:
      name: example-pod
    spec:
    affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                - key: disktype
                  operator: In
                  values:
                  - ssd
    containers:
    - name: nginx
      image: nginx

Ở trên giá trị key ta chỉ định là `disktype`, operator là `In`, `values` là một mảng với giá trị là `ssd` => `disktype` in `ssd`.

![affinity](../image/affinity.png)

#### PreferredDuringSchedulingIgnoredDuringExecution: Có thể ưu tiên deploy pod tới node nào trước hơn so với các node còn lại trong những node ta đã chọn.

    $ kubectl get node
    high-cpu-1                    Ready    <none>                 302d   v1.22.3
    high-cpu-2                    Ready    <none>                 302d   v1.20.2
    medium-cpu-1                  Ready    <none>                 302d   v1.20.2
    medium-cpu-2                  Ready    <none>                 302d   v1.20.2
    kube-master                   Ready    control-plane,master   304d   v1.20.1

Ta đánh label cho các node:

    $ kubectl label node high-cpu-1 cpu=high
    node "high-cpu-1" labeled

    $ kubectl label node high-cpu-2 cpu=high
    node "high-cpu-2" labeled

    $ kubectl label node medium-cpu-1 cpu=medium
    node "medium-cpu-1" labeled

    $ kubectl label node medium-cpu-2 cpu=medium
    node "medium-cpu-2" labeled

File cấu hình Deployment như sau:

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: trader
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: trader
      template:
        metadata:
          labels:
            app: trader
        spec:
          affinity:
            nodeAffinity:
              preferredDuringSchedulingIgnoredDuringExecution:
                - weight: 50
                  preference:
                    matchExpressions:
                    - key: cpu
                      operator: In
                      values:
                        - "high"
                - weight: 30
                  preference:
                    matchExpressions:
                    - key: cpu
                      operator: In
                      values:
                        - "medium"
          containers:
            - image: trader
              name: trader

_Để chỉ định độ ưu tiên thì ta sử dụng thuộc tính weight và đánh giá trị cho nó, ở file trên ta chỉ định node có label cpu: high có giá trị weight là 50, đây là giá trị cao nhất, nên các pod của ta sẽ ưu tiên deploy tới node có label cpu: high trước tiên_

## `Pod Affinity và Pod anti-affinity`

### `Pod Affinity`

_Bạn đã thấy cách hoạt động của node selector và node affinity, chúng sẽ tác động tới pod trong quá trình schedule. Nhưng các rule này chỉ liên quan tới pod và node, giả sử chúng ta không muốn deploy pod tới node nào cả mà chỉ muốn deploy một pod tới gần một pod khác được gọi là pod affinity_

#### 1. Intro

- Giúp bạn sắp xếp các pod trên các node đã có các pod cụ thể khác chạy sẵn. Điều này giúp bạn gom nhóm các pod gần nhau.
- Ví dụ như để cải thiện hiệu năng hoặc giao tiếp giữa các pod.

#### 2. Config

Ví dụ ta tạo một pod database như sau:

    kubectl run database -l app=database --image busybox -- sleep 999999

Sau đó, ta sẽ tạo pod backend và chỉ định pod affinity để nó được deploy gần với pod database.

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: backend
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: backend
      template:
        metadata:
          labels:
            app: backend
        spec:
          affinity:
            podAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                - topologyKey: kubernetes.io/hostname
                  labelSelector:
                      matchLabels:
                        app: database
          containers:
            - name: main
              image: alpine
              command: ["/bin/sleep", "999999"]

Khi pod mà ta chỉ định `podAffinity` được deploy, nó sẽ kiếm những pod nào mà có label trong trường `matchLabels`, sau đó sẽ deploy pod tới pod đã được chọn cùng trong một node. Ta có thể tăng scope này lên bằng trường `topologyKey`.

![affinity1](../image/affinity1.png)

### `Pod anti-affinity`

#### 1. Intro

- Giúp bạn tách các pod ra, ngăn chúng không được lên lịch trên cùng một node.
- Điều này thường được sử dụng để cải thiện tính khả dụng bằng cách phân tán các pod giống nhau ra trên nhiều node.

#### 2. Config

    apiVersion: v1
    kind: Pod
    metadata:
      name: example-pod
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            labelSelector:
              matchLabels:
                app: frontend
            topologyKey: "kubernetes.io/hostname"
      containers:
      - name: nginx
        image: nginx

Trong ví dụ này, pod sẽ không được lên lịch trên cùng node với các pod khác có label `app=frontend`.

### So sách

![affinity3](../image/affinity3.png)

### Kết luận

- Node Affinity tập trung vào việc chọn node nào mà pod nên được lên lịch dựa trên nhãn node.
- Pod Affinity/Anti-Affinity giúp kiểm soát cách các pod tương tác với nhau, xác định liệu chúng có nên được đặt gần nhau hay tách biệt trên các node khác nhau.

## Tài liệu tham khảo

1. https://viblo.asia/p/kubernetes-series-bai-18-advanced-scheduling-node-affinity-and-pod-affinity-gAm5y7jqZdb#_pod-affinity-5

2. https://docs.openshift.com/container-platform/3.11/admin_guide/scheduling/node_affinity.html
