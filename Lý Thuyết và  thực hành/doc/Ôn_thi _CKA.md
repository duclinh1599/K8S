----------- secret -----------
- Tạo 1 scret bằng cmd:
  
		kubectl create secret generic secret1 --from-literal=username=my_user1 --from-literal=password=mysecretpassword
	
- Kiểm tra:

		kubectl get secret -oyaml 
	
		--> ta lấy được username và password đã được mã hoá.

- Xác nhận secret
  
		echo '(password lấy từ trên)' | base64 -d	
	
----- RBAC------------
1. Tạo ServiceAccount

		kubectl create sa gitops -n project-1
		kubectl get sa -n project-1
	
2. Tạo role

		kubectl create role -n project-1 gitops-role --verb=create --resource=secrets,configmap
		kubectl get/describe role -n project-1
	
3. Tạo rolebinding
   
		kubectl create rolebinding -n project-1 gitops-rolebinding --role=gitops-role --serviceaccount=project-1:gitops
		kubectl get rolebinding -n project-1
	
4. Check

		kubectl -n project-1 auth can-i create pod/secret/configmap --as system:serviceaccount:project-1:gitops
