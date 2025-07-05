#!/usr/bin/env bash
# create_rke2_resources.sh
# Provision firewall + 2 Ubuntu VMs on GCP. No software install.

set -euo pipefail

# ─── Edit these four lines ──────────────────────────────────
PROJECT_ID="YOUR_GCP_PROJECT"
REGION="us-central1"
ZONE="${REGION}-a"
SOURCE_RANGE="0.0.0.0/0"          # Restrict for prod
# ────────────────────────────────────────────────────────────
MASTER_NAME="rke2-master"
WORKER_NAME="rke2-worker"
MACHINE_TYPE="e2-medium"
BOOT_DISK_SIZE="20GB"
FIREWALL_RULE="allow-rke2-ports"
NETWORK="default"
NETWORK_TAG="rke2"

gcloud config set project "$PROJECT_ID" --quiet

# Firewall
if ! gcloud compute firewall-rules describe "$FIREWALL_RULE" --quiet >/dev/null 2>&1; then
  gcloud compute firewall-rules create "$FIREWALL_RULE" \
    --direction=INGRESS \
    --priority=1000 \
    --network="$NETWORK" \
    --action=ALLOW \
    --target-tags="$NETWORK_TAG" \
    --rules=tcp:22,tcp:6443,tcp:9345,tcp:10250,tcp:8472,tcp:30000-32767 \
    --source-ranges="$SOURCE_RANGE" --quiet
fi

# Master VM
gcloud compute instances create "$MASTER_NAME" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size="$BOOT_DISK_SIZE" \
  --tags="$NETWORK_TAG" --quiet

# Worker VM
gcloud compute instances create "$WORKER_NAME" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size="$BOOT_DISK_SIZE" \
  --tags="$NETWORK_TAG" --quiet

echo
echo "Resources created. Next: SSH in and follow docs/step-by-step.md"
