# Variables
CLUSTER_NAME := lab
IMAGE_NAME   := nginx-custom
IMAGE_TAG    := v1
NAMESPACE    := default

.PHONY: help cluster delete-cluster build-image import-image deploy port-forward status clean

help:
	@echo "Cibles disponibles :"
	@echo "  make cluster        - Crée le cluster K3d '$(CLUSTER_NAME)'"
	@echo "  make delete-cluster - Supprime le cluster K3d '$(CLUSTER_NAME)'"
	@echo "  make build-image    - Construit l'image Docker $(IMAGE_NAME):$(IMAGE_TAG) avec Packer"
	@echo "  make import-image   - Importe l'image dans le cluster K3d"
	@echo "  make deploy         - Déploie l'application avec Ansible"
	@echo "  make port-forward   - Fait un port-forward local 8081 -> svc/nginx-custom:80"
	@echo "  make status         - Affiche les ressources Kubernetes (deploy, pods, services)"
	@echo "  make clean          - Supprime le tar d'image local"

cluster:
	k3d cluster create $(CLUSTER_NAME) --agents 2 --servers 1

delete-cluster:
	k3d cluster delete $(CLUSTER_NAME) || true

build-image:
	cd packer && packer build nginx.pkr.hcl

import-image:
	docker save $(IMAGE_NAME):$(IMAGE_TAG) -o $(IMAGE_NAME)-$(IMAGE_TAG).tar
	k3d image import $(IMAGE_NAME):$(IMAGE_TAG) -c $(CLUSTER_NAME)

deploy:
	cd ansible && ansible-playbook -i inventory site.yml

port-forward:
	kubectl port-forward svc/nginx-custom -n $(NAMESPACE) 8082:80

status:
	kubectl get deploy,po,svc -n $(NAMESPACE)

clean:
	rm -f $(IMAGE_NAME)-$(IMAGE_TAG).tar
