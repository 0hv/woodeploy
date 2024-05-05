#!/bin/bash
set -euo pipefail

# Fonction de journalisation
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Vérifier si le service Apache fonctionne
if ! sudo systemctl is-active --quiet apache2; then
    log "Démarrage du service Apache..."
    sudo systemctl start apache2 || { log "Erreur lors du démarrage d'Apache"; exit 1; }
fi

# Configurer Apache et PHP
configure_apache_php() {
    log "Configuration d'Apache et PHP..."
    sudo systemctl enable apache2 || { log "Erreur lors de l'activation d'Apache"; exit 1; }

    # Installer PHP et les modules nécessaires
    sudo apt-get install -y php php-mysql libapache2-mod-php || { log "Erreur lors de l'installation de PHP et des modules"; exit 1; }

    # Redémarrer Apache pour appliquer les changements
    sudo systemctl restart apache2 || { log "Erreur lors du redémarrage d'Apache"; exit 1; }
    log "Apache et PHP configurés."
}

# Appeler la fonction
configure_apache_php
