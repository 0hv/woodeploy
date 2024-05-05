#!/bin/bash
set -euo pipefail

# Fonction de journalisation
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Charger les variables d'environnement
export $(grep -v '^#' ../common/.env | xargs) || { log "Erreur lors du chargement des variables d'environnement"; exit 1; }

# Télécharger et installer WordPress
install_wordpress() {
  log "Téléchargement et installation de WordPress..."
  wp_dir="/var/www/html/wordpress"
  if [ ! -d "$wp_dir" ]; then
    sudo mkdir -p "$wp_dir"
    cd "$wp_dir" || { log "Erreur lors de la création du dossier WordPress"; exit 1; }
    curl -O https://wordpress.org/latest.tar.gz || { log "Erreur lors du téléchargement de WordPress"; exit 1; }
    tar -xzf latest.tar.gz --strip-components=1 || { log "Erreur lors de l'extraction du fichier WordPress"; exit 1; }
    sudo chown -R www-data:www-data "$wp_dir" || { log "Erreur lors du changement des permissions"; exit 1; }
  else
    log "Le dossier WordPress existe déjà."
  fi

  # Configurer `wp-config.php`
  wp_config="$wp_dir/wp-config.php"
  if [ ! -f "$wp_config" ]; then
    cp "$wp_dir/wp-config-sample.php" "$wp_config" || { log "Erreur lors de la copie de wp-config-sample.php"; exit 1; }
    sed -i "s/database_name_here/$MYSQL_DATABASE/" "$wp_config" || { log "Erreur lors de la configuration de la base de données dans wp-config.php"; exit 1; }
    sed -i "s/username_here/$MYSQL_USER/" "$wp_config" || { log "Erreur lors de la configuration du nom d'utilisateur dans wp-config.php"; exit 1; }
    sed -i "s/password_here/$MYSQL_PASSWORD/" "$wp_config" || { log "Erreur lors de la configuration du mot de passe dans wp-config.php"; exit 1; }
  fi
  log "WordPress installé."
}

# Appeler la fonction
install_wordpress
