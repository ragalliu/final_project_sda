output "ecr_repo_url" {
    value = aws_ecr_repository.repo.repository_url
    description = "Image repo URL"
  
}

output "ecr_repo_name" {
    value = aws_ecr_repository.repo.name
  
}

output "cluster_name" {
    value = aws_eks_cluster.ra-eks.name
  
}