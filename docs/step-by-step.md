# Step-by-Step Guide: RKE2 Kubernetes Cluster on Google Cloud

This guide will walk you through manually installing and configuring an RKE2 cluster on Google Cloud, after provisioning infrastructure using the provided script.

---

## 🧰 Prerequisites

- A GCP project with billing enabled
- VM infrastructure created using the `create_rke2_resources.sh` script
- `gcloud` CLI and internet access
- Basic Linux command-line knowledge

---

## 🔑 1. SSH into the Master Node

```bash
gcloud compute ssh rke2-master --zone=us-central1-a
```
## ⚙️ 2. Install RKE2 on the Master
```
curl -sfL https://get.rke2.io | sudo sh -
sudo systemctl enable rke2-server
sudo systemctl start rke2-server
#Wait 20–30 seconds for the service to start.
```
## 🔗 3. Enable kubectl on the Master
```
sudo ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
```
## 📂 4. Configure Kubeconfig
```
mkdir -p ~/.kube
sudo cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
#Verify cluster access:
kubectl get nodes

```
## 🔐 5. Get Join Token and Master Internal IP
```
cat /var/lib/rancher/rke2/server/node-token
hostname -I | awk '{print $1}'
#Save both values — you’ll need them on the worker node.
```

## 🔧 6. SSH into the Worker Node
```
gcloud compute ssh rke2-worker --zone=us-central1-a
```

## 🛠️ 7. Configure the Worker Node (RKE2 Agent)
```
Create the agent config file:

sudo mkdir -p /etc/rancher/rke2
sudo nano /etc/rancher/rke2/config.yaml
#Paste the following (replace placeholders):

server: https://<MASTER_INTERNAL_IP>:9345
token: <JOIN_TOKEN>
```
## 📥 8. Install RKE2 Agent on the Worker
```
curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE="agent" sh -
sudo systemctl enable rke2-agent
sudo systemctl start rke2-agent
#(Optional) Enable kubectl:

sudo ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
```
## ✅ 9. Verify Cluster from the Master Node
## SSH back into the master node:
```
gcloud compute ssh rke2-master --zone=us-central1-a
#Then run:
kubectl get nodes
#You should now see both rke2-master and rke2-worker listed as Ready.
```

## 🏷️ 10. Label the Worker Node
```
kubectl label node rke2-worker node-role.kubernetes.io/worker=worker
#Verify:


kubectl get nodes --show-labels
```
## 🧪 11. Test with NGINX Deployment
```
kubectl create deployment nginx --image=nginx
kubectl get pods -o wide
kubectl delete deployment nginx
```
## 🧹 12. Cleanup (Optional)
```
gcloud compute instances delete rke2-master rke2-worker --zone=us-central1-a
gcloud compute firewall-rules delete allow-rke2-ports
```
# 📌 Notes
All ports are opened in the firewall rule created by the provisioning script.

This guide assumes the default GCP zone: us-central1-a.

👨‍💻 Author
Abhay Dandge

[LinkedIn](https://www.linkedin.com/in/abhaydandge)
 • [Twitter](https://x.com/ABHAYDPATIL96)

