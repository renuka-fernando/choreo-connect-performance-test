REGION=us-east-2
NAME=choreo-connect-120-perf-test

# Create VPC
aws cloudformation create-stack \
  --region "${REGION}" \
  --stack-name "${NAME}-eks-vpc-stack" \
  --template-url https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml

# Create IAM Role and attach required Amazon EKS managed IAM policy
aws iam create-role \
  --role-name "${NAME}-AmazonEKSClusterRole" \
  --assume-role-policy-document file://"eks-cluster-role-trust-policy.json"
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy \
  --role-name "${NAME}-AmazonEKSClusterRole"

# Create EKS Cluster "choreo-connect-120-perf-test-cluster"
# Cluster service role: "${NAME}-AmazonEKSClusterRole"
# Select VPC
# Wait...


# Create Node Role and Attach the required managed IAM policies to the role
aws iam create-role \
  --role-name "${NAME}AmazonEKSNodeRole" \
  --assume-role-policy-document file://"node-role-trust-policy.json"
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy \
  --role-name "${NAME}AmazonEKSNodeRole"
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
  --role-name "${NAME}AmazonEKSNodeRole"
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy \
  --role-name "${NAME}AmazonEKSNodeRole"

# Create EKS Nodes "choreo-connect-120-perf-test-nodegroup"
# Select IAM Role for Node


aws eks update-kubeconfig --region "${REGION}" --name "${NAME}-cluster"
