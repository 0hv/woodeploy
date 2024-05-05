#!/bin/bash

# Installer WP-CLI dans le conteneur WordPress
echo "Installation de WP-CLI dans le conteneur WordPress..."
docker exec wordpress_container bash -c "
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&
    chmod +x wp-cli.phar &&
    mv wp-cli.phar /usr/local/bin/wp
" || { echo "Échec de l'installation de WP-CLI."; exit 1; }

# Configurer les permissions pour WP-CLI
echo "Configuration des permissions pour le cache WP-CLI..."
docker exec wordpress_container bash -c "
    mkdir -p /var/www/.wp-cli/cache &&
    chown -R www-data:www-data /var/www/.wp-cli
" || { echo "Échec de la configuration des permissions."; exit 1; }

# Activer WooCommerce via WP-CLI
echo "Activation du plugin WooCommerce..."
docker exec wordpress_container bash -c "wp plugin install woocommerce --activate --allow-root" || {
    echo "Échec de l'activation du plugin WooCommerce.";
    exit 1;
}

# Création automatique de la clé API WooCommerce via PHP
echo "Création automatique de la clé API WooCommerce..."
docker exec wordpress_container php /var/www/html/wp-init.php || {
    echo "Échec de la génération automatique des clés API WooCommerce.";
    exit 1;
}

echo "Provisionnement terminé : WP-CLI installé et WooCommerce activé."
