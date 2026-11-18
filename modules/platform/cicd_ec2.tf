data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- IAM Role for Jenkins & SonarQube EC2 ---
resource "aws_iam_role" "jenkins" {
  name = "${var.project_name}-${var.environment}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Allow Jenkins to push/pull Docker images to Amazon ECR
resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.jenkins.name
}

# Allow Jenkins to query EKS cluster details for kubectl deployments
resource "aws_iam_role_policy" "jenkins_eks_access" {
  name = "${var.project_name}-${var.environment}-jenkins-eks-policy"
  role = aws_iam_role.jenkins.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["eks:DescribeCluster", "eks:ListClusters"]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.project_name}-${var.environment}-jenkins-profile"
  role = aws_iam_role.jenkins.name
}

# --- EC2 Instance in Public Subnet B ---
resource "aws_instance" "jenkins_sonarqube" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.large" # Recommended for running both Jenkins and SonarQube
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins.name

  root_block_device {
    volume_size = 40
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-sonarqube"
  }
}
