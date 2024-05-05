#!/bin/bash
set -euo pipefail

# Fonction de journalisation
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Charger les variables d'environnement
export $(grep -v '^#' ../common/.env | xargs)

# Vérifier si le service MySQL fonctionne
if ! sudo systemctl is-active --quiet mysql; then
    log "Démarrage du service MySQL..."
    sudo systemctl start mysql || { log "Erreur lors du démarrage de MySQL"; exit 1; }
fi

# Configurer MySQL
configure_mysql() {
    log "Configuration de MySQL..."
    sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" || { log "Erreur lors de la création de la base de données"; exit 1; }
    sudo mysql -u root -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';" || { log "Erreur lors de la création de l'utilisateur MySQL"; exit 1; }
    sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost';" || { log "Erreur lors de l'octroi des privilèges"; exit 1; }
    sudo mysql -u root -e "FLUSH PRIVILEGES;" || { log "Erreur lors de l'exécution de FLUSH PRIVILEGES"; exit 1; }
    log "MySQL configuré."
}

# Appeler la fonction
configure_mysql
