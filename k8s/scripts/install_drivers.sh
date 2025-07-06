#!/bin/bash

set -e  # Exit immediately if any command fails

echo "Starting installation of CSI drivers and Metrics Server..."

# Add and update AWS EFS CSI Driver Helm repository
echo "Adding and updating AWS EFS CSI Driver Helm repository..."
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update
echo "Installing AWS EFS CSI Driver..."
helm upgrade --install aws-efs-csi-driver --namespace kube-system aws-efs-csi-driver/aws-efs-csi-driver

# Add and update Secrets Store CSI Driver Helm repository
echo "Adding and updating Secrets Store CSI Driver Helm repository..."
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo update
echo "Installing Secrets Store CSI Driver..."
helm install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver

# Install AWS Provider for Secrets Store CSI Driver
echo "Applying AWS provider for Secrets Store CSI Driver..."
kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

# Add and update AWS Secrets Manager provider Helm repository
echo "Adding and updating AWS Secrets Manager provider Helm repository..."
helm repo add aws-secrets-manager https://aws.github.io/secrets-store-csi-driver-provider-aws
helm repo update
echo "Installing AWS Secrets Manager provider..."
helm install -n kube-system secrets-provider-aws aws-secrets-manager/secrets-store-csi-driver-provider-aws

# Add and update Metrics Server Helm repository
echo "Adding and updating Metrics Server Helm repository..."
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
echo "Installing Metrics Server..."
helm install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --set args={--kubelet-insecure-tls}

echo "Installation completed successfully!"
