#!/bin/bash
set -euo pipefail

# Fonction de journalisation
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Charger les variables d'environnement
export $(grep -v '^#' ../common/.env | xargs) || { log "Erreur lors du chargement des variables d'environnement"; exit 1; }

# Vérifier que WP-CLI est installé
if ! command -v wp &> /dev/null; then
  log "WP-CLI n'est pas installé. Veuillez l'installer et réessayer."
  exit 1
fi

# Configurer WordPress
configure_wordpress() {
  log "Configuration de WordPress..."
  wp_path="/var/www/html/wordpress"
  cd "$wp_path" || { log "Erreur lors de la navigation vers le dossier WordPress"; exit 1; }

  # Vérifier si WordPress est déjà installé
  if ! wp core is-installed --path="$wp_path" &> /dev/null; then
    wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_EMAIL" --path="$wp_path" \
        || { log "Erreur lors de l'installation de WordPress"; exit 1; }
  else
    log "WordPress est déjà installé."
  fi

  # Exécuter le fichier wp-init.php
  php ../common/wp-init.php || { log "Erreur lors de l'exécution du fichier wp-init.php"; exit 1; }
}

# Appeler la fonction
configure_wordpress
