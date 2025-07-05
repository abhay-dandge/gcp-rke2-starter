# RKE2 Cluster Starter on Google Cloud

This repository provides a simple, beginner-friendly way to set up the **infrastructure** required for an [RKE2](https://docs.rke2.io/) (Rancher Kubernetes Engine 2) cluster on Google Cloud Platform.

> 🛠️ It provisions only the **resources**: firewall rules and two Ubuntu virtual machines (one master, one worker).  
> 🧠 All installation and configuration of RKE2 is done **manually**, following clear steps in the documentation.

---

## What’s Included

- Bash script to create:
  - ✅ GCP firewall rule for Kubernetes and SSH
  - ✅ 2 Ubuntu 22.04 VMs (master + worker)
- Detailed, beginner-focused installation guide
- Clean separation between provisioning and configuration

---

## Folder Structure

```text
gcp-rke2-starter/
├── scripts/
│   └── create_rke2_resources.sh    # Only creates GCP resources
├── docs/
│   └── step-by-step.md             # Manual RKE2 installation guide
├── .gitignore
├── LICENSE
└── README.md
```
Prerequisites
A Google Cloud Platform (GCP) project with billing enabled

The gcloud CLI installed and authenticated

Bash or compatible shell environment

How to Use
Step 1: Clone the repository
bash
Copy
Edit
git clone https://github.com/YOUR_USERNAME/gcp-rke2-starter.git
cd gcp-rke2-starter/scripts
Step 2: Run the provisioning script
Edit the variables in the script for your project and zone:

bash
Copy
Edit
chmod +x create_rke2_resources.sh
./create_rke2_resources.sh
This creates:

Firewall rule: allow-rke2-ports

VMs: rke2-master and rke2-worker

What’s Next?
Follow the full step-by-step manual installation guide here:

📘 docs/step-by-step.md

This guide walks you through:

Installing RKE2 server and agent

Joining nodes

Labeling worker

Testing with an NGINX deployment

Cleanup Resources
To remove the created infrastructure:

bash
Copy
Edit
gcloud compute instances delete rke2-master rke2-worker --zone=us-central1-a
gcloud compute firewall-rules delete allow-rke2-ports
License
This project is licensed under the MIT License.

Author
Abhay Dandge
LinkedIn • Twitter

yaml
Copy
Edit
