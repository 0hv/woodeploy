<?php
// Charger les fichiers WordPress nécessaires
require_once('/var/www/html/wp-load.php');
require_once('/var/www/html/wp-admin/includes/plugin.php');

// S'assurer que WooCommerce est installé et activé
if (!is_plugin_active('woocommerce/woocommerce.php')) {
    echo "Activation du plugin WooCommerce...";
    if (!activate_plugin('woocommerce/woocommerce.php')) {
        echo "Impossible d'activer WooCommerce.";
        exit(1);
    }
}

// Créer automatiquement les clés API WooCommerce
if (function_exists('wc') && wc()) {
    global $wpdb;

    // Générer automatiquement les clés
    $consumer_key = 'ck_' . wp_generate_password(32, false);
    $consumer_secret = 'cs_' . wp_generate_password(32, false);

    // Insérer les clés API dans la base de données
    $result = $wpdb->insert(
        $wpdb->prefix . 'woocommerce_api_keys',
        array(
            'user_id' => 1,
            'description' => 'Ma Clé API',
            'permissions' => 'read_write',
            'consumer_key' => wc_api_hash($consumer_key),
            'consumer_secret' => $consumer_secret,
            'truncated_key' => substr($consumer_key, -7)
        )
    );

    if ($result !== false) {
        echo "Clé API générée avec succès.\n";
        echo "Clé API : " . $consumer_key . "\n";
        echo "Secret API : " . $consumer_secret . "\n";
    } else {
        echo "Erreur lors de la création des clés API.";
    }
} else {
    echo "Erreur : WooCommerce n'est pas activé.";
}
