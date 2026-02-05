🚀 Image_to_Cluster – Packer + K3d + Ansible + Nginx custom

🎯 1. Objectif du projet

Ce projet illustre un flux complet Infrastructure as Code permettant de :

🐳 Construire une image Docker Nginx custom avec Packer à partir de nginx:alpine
☸️ L’importer dans un cluster Kubernetes K3d
🤖 Déployer l’application avec Ansible (Deployment + Service)
🌐 Exposer une page web HTML servie par Nginx
💻 Le tout dans un environnement GitHub Codespaces
🏗️ 2. Architecture

L’architecture cible repose sur :

🐳 Une image Docker basée sur nginx:alpine, construite avec Packer
☸️ Un cluster Kubernetes local géré par K3d (Docker + k3s)
📦 Un Deployment Kubernetes utilisant l’image Nginx custom
🌐 Un Service Kubernetes (NodePort) pour exposer l’application
🤖 Ansible pour appliquer les manifests Kubernetes sur le cluster
🔗 Un port-forward pour accéder à l’application depuis le navigateur
Un schéma de l’architecture est disponible dans le fichier Architecture_cible.png.

📁 3. Contenu du dépôt

Arborescence principale :

ansible/
inventory
site.yml
templates/
deployment.yaml
service.yaml
packer/
nginx.pkr.hcl
index.html
Architecture_cible.png
Makefile
README.md
🛠️ 4. Pré-requis

Dans un GitHub Codespace, les outils suivants sont déjà installés :

🐳 Docker
☸️ k3d
🕹️ kubectl
📦 Packer
🤖 Ansible
🛠️ Make
En local, vous devez installer :

Docker
k3d
kubectl
Packer
Ansible
⚡ 5. Utilisation rapide avec make

Toutes les étapes principales sont automatisées dans le Makefile.

Pour afficher les commandes disponibles, tapez :

make help

Principales cibles :

🟢 make cluster – Crée le cluster K3d lab
🔴 make delete-cluster – Supprime le cluster K3d lab
🏗️ make build-image – Construit l’image Docker nginx-custom:v1 avec Packer
📦 make import-image – Importe l’image dans le cluster K3d
🤖 make deploy – Déploie l’application avec Ansible
🔗 make port-forward – Fait un port-forward local 8082 -> svc/nginx-custom:80
📊 make status – Affiche les ressources Kubernetes du namespace default
🧹 make clean – Supprime le tar d’image local
5.1. Créer le cluster K3d

Tapez : make cluster
Cela crée un cluster K3d nommé lab avec 1 serveur et 2 agents.

5.2. Construire l’image Nginx custom avec Packer

Tapez : make build-image
Cette commande utilise packer/nginx.pkr.hcl, part de l’image nginx:alpine, copie le fichier index.html à l’intérieur de l’image, et produit l’image nginx-custom:v1 dans Docker.

Pour vérifier la présence de l’image :
docker images | grep nginx-custom

5.3. Importer l’image dans le cluster K3d

Tapez : make import-image
Cette cible sauvegarde l’image nginx-custom:v1 dans un tar, puis l’importe dans le cluster K3d lab.

5.4. Déployer l’application sur le cluster avec Ansible

Tapez : make deploy
Cette commande exécute le playbook ansible/site.yml qui applique les manifests deployment.yaml et service.yaml sur le cluster.

Pour vérifier l’état des ressources :
make status

Exemple de sortie attendue :
deployment.apps/nginx-custom 1/1 1 1 1m
pod/nginx-custom-xxxxx 1/1 Running 0 1m
service/nginx-custom NodePort 10.43.xx.yy <none> 80:30080/TCP 1m

🌐 6. Accéder à l’application dans le navigateur

L’application est exposée via un Service Kubernetes.

Pour y accéder, tapez : make port-forward
Cette commande exécute : kubectl port-forward svc/nginx-custom -n default 8082:80

Laissez cette commande tourner dans un terminal.
Dans GitHub Codespaces, ouvrez l’onglet PORTS.
Recherchez le port 8082.
Cliquez sur l’URL associée (ex : https://<votre-codespace>-8082.app.github.dev).
Vous devriez voir la page :

Bravo !
Cette page est servie depuis une image Nginx custom construite avec Packer,
déployée automatiquement sur un cluster K3d via Ansible,
le tout depuis GitHub Codespaces.

🧑‍💻 7. Détails techniques

7.1. Construction de l’image avec Packer

Base : nginx:alpine
Copie index.html dans /tmp/index.html
Copie ensuite dans /usr/share/nginx/html/index.html
Tag final : nginx-custom:v1
7.2. Manifests Kubernetes

deployment.yaml : Deployment Nginx utilisant l’image nginx-custom:v1 (1 replica)
service.yaml : Service de type NodePort exposant le port 80 du pod
Ces fichiers sont appliqués par le playbook ansible/site.yml.

🧹 8. Nettoyage

Pour supprimer les artefacts temporaires :
make clean

Pour supprimer complètement le cluster K3d :
make delete-cluster

📝 9. Résumé du flux complet

🏗️ Construire l’image Nginx custom :
make build-image

📦 Importer l’image dans K3d :
make import-image

🤖 Déployer sur le cluster avec Ansible :
make deploy

📊 Vérifier les ressources :
make status

🌐 Accéder à l’application dans le navigateur :
make port-forward
Puis cliquez sur le port 8082 dans l’onglet PORTS de GitHub Codespaces.

Ce projet illustre un flux complet Infrastructure as Code :

Code source → Packer → Image Docker → K3d → Manifests Kubernetes → Ansible → Application accessible en HTTP.

