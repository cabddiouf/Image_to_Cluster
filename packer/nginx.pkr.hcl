packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.0"
    }
  }
}

source "docker" "nginx_custom" {
  image  = "nginx:alpine"
  commit = true
}

build {
  name    = "nginx-custom-image"
  sources = ["source.docker.nginx_custom"]

  # On copie le index.html du repo dans l'image
  provisioner "file" {
    source      = "../index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = [
      "cp /tmp/index.html /usr/share/nginx/html/index.html"
    ]
  }

  post-processor "docker-tag" {
    repository = "nginx-custom"
    tags        = ["v1"]
  }
}
