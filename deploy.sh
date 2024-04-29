#!/bin/bash

# Fonction pour nettoyer les conteneurs et les images
cleanup() {
    echo "Cleaning up existing containers and images..."
    # Arrête et supprime les conteneurs spécifiques si ils existent
    docker-compose down --remove-orphans

    # Facultatif: Décommentez pour supprimer les images aussi
    # docker rmi $(docker images 'wordpress:latest' -q)
    # docker rmi $(docker images 'mariadb:10.5' -q)
}

# Vérification de la présence d'un fichier docker-compose
if [ ! -f "docker-compose.yml" ]; then
    echo "docker-compose.yml file not found!"
    exit 1
fi

cleanup

echo "Build process starts..."
# Construction des images Docker avec Docker Compose
docker-compose build || { echo "Docker build failed"; exit 1; }

echo "Deployment starts..."
# Démarrage des conteneurs avec Docker Compose
docker-compose up -d || { echo "Docker Compose failed to start"; exit 1; }

echo "Waiting for WordPress to be fully operational..."
# Boucle pour attendre que WordPress soit accessible
max_attempts=10
count=0
while ! curl -s http://localhost:8000/wp-admin/install.php | grep -q '<html>'; do
  count=$((count+1))
  if [ "$count" -lt "$max_attempts" ]; then
    echo "WordPress is not ready yet. Waiting..."
    sleep 10
  else
    echo "Timed out waiting for WordPress to be ready."
    exit 1
  fi
done

echo "Initializing WordPress and WooCommerce..."
# Vérification que le script PHP s'exécute sans erreur
if ! docker exec -it wordpress_container php /var/www/html/wp-init.php; then
  echo "Failed to initialize WordPress and WooCommerce."
  exit 1
fi

echo "Deployment and initialization complete!"
