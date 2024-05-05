#!/bin/bash

# Fonction pour nettoyer les conteneurs et les images
cleanup() {
    echo "Nettoyage des conteneurs et images existants..."
    docker-compose down --remove-orphans
    echo "Nettoyage terminé."
}

# Vérification de la présence d'un fichier docker-compose
if [ ! -f "docker-compose.yml" ]; then
    echo "Fichier docker-compose.yml non trouvé !"
    exit 1
fi

cleanup

echo "Début du processus de construction..."
docker-compose build || { echo "Échec de la construction Docker"; exit 1; }

echo "Début du déploiement..."
docker-compose up -d || { echo "Échec du démarrage de Docker Compose"; exit 1; }

echo "Attente que WordPress soit totalement opérationnel..."
max_attempts=10
count=0
while true; do
    response=$(curl -s http://localhost:8000/wp-admin/install.php)
    echo "$response" | grep -q 'WordPress'
    if [ $? -eq 0 ]; then
        echo "WordPress est prêt."
        break
    else
        count=$((count+1))
        if [ "$count" -lt "$max_attempts" ]; then
            echo "WordPress n'est pas encore prêt. Attente... Tentative $count/$max_attempts"
            echo "Réponse non attendue reçue:"
            echo "$response" | grep 'html' | head -5  # Affiche les premières lignes de la sortie
            sleep 10
        else
            echo "Délai d'attente dépassé pour WordPress."
            exit 1
        fi
    fi
done

# Exécuter le script de provisionnement
echo "Lancement du provisionnement..."
if ! ./provision.sh; then
    echo "Échec du provisionnement."
    exit 1
fi

# Vérification de la santé du conteneur WordPress
echo "Vérification de l'état du conteneur WordPress..."
health_status=$(docker inspect --format='{{json .State.Health.Status}}' wordpress_container)
echo "Health status: $health_status"

# Afficher l'état de santé complet du conteneur
docker inspect --format='{{json .State.Health}}' wordpress_container

echo "Déploiement et provisionnement complétés !"
