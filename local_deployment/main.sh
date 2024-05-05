#!/bin/bash
set -euo pipefail

# Fonction pour afficher les messages
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Exécuter chaque étape avec des messages de journalisation
log "Installation des dépendances"
bash ./install_dependencies.sh || { log "Erreur lors de l'installation des dépendances"; exit 1; }

log "Configuration de MySQL"
bash ./configure_mysql.sh || { log "Erreur lors de la configuration de MySQL"; exit 1; }

log "Configuration d'Apache et PHP"
bash ./configure_apache_php.sh || { log "Erreur lors de la configuration d'Apache et PHP"; exit 1; }

log "Installation de WordPress"
bash ./install_wordpress.sh || { log "Erreur lors de l'installation de WordPress"; exit 1; }

log "Configuration de WordPress"
bash ./configure_wordpress.sh || { log "Erreur lors de la configuration de WordPress"; exit 1; }

log "Déploiement local complet."
