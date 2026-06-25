terraform {
  cloud {
    organization = "your-org"
    workspaces {
      name = "devops-k8s"
    }
  }
}
