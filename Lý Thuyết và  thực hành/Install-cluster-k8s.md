## `1.Update and Upgrade Ubuntu`

    sudo apt-get update
    sudo apt-get upgrade

## `2. Disable Swap`

    sudo swapoff -a
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

## `3.Add Kernel Parameters`

    sudo tee /etc/modules-load.d/containerd.conf <<EOF
    overlay
    br_netfilter
    EOF

---

    sudo modprobe overlay
    sudo modprobe br_netfilter

---

    sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    EOF

---

    sudo sysctl --system

## `4.Install Containerd Runtime`

    sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

---

    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

---

    sudo apt update
    sudo apt install -y containerd.io

---

    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

    sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

---

    sudo systemctl restart containerd
    sudo systemctl enable containerd

## `5.Install Kubernetes Components:`

    sudo apt-get update

    sudo apt-get install -y apt-transport-https ca-certificates curl gpg

    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

## `6.Update the package list and install kubelet, kubeadm, and kubectl.`

    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

### _---------------- only master_node---------------_

    sudo kubeadm init

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

### _---- worker-----_

    sudo kubeadm join 192.168.218.162:6443 --token 5gps4s.oltblsjntwieboaz --discovery-token-ca-cert-hash sha256:af1b4fe77f57afb1db6ae1ba8a17746ee22867c935a2018e8e419775d2f4c205

Lệnh xem lại key để join

    kubeadm token create --print-join-command

Để worker join một cluter mới thì ta cần reset cluster cũ đi bằng lệnh:

    sudo kubeadm reset
    
## `7. Tham khảo`
https://medium.com/@kvihanga/how-to-set-up-a-kubernetes-cluster-on-ubuntu-22-04-lts-433548d9a7d0

https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/

https://github.com/kubernetes/kubernetes/issues/123673

https://k21academy.com/docker-kubernetes/
container-runtime-is-not-running/
