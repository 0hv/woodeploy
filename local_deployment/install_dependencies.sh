#!/bin/bash
set -euo pipefail

# Fonction de journalisation
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Vérifier et installer les dépendances
check_and_install_dependencies() {
    dependencies=("mysql" "curl" "php" "apache2" "php-mysql")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log "Installation de $dep..."
            sudo apt-get install -y "$dep" || { log "Erreur lors de l'installation de $dep"; exit 1; }
        else
            log "$dep est déjà installé."
        fi
    done
}

# Appeler la fonction
check_and_install_dependencies
