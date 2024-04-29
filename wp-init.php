<?php
require_once('/var/www/html/wp-load.php');

// S'assurer que WooCommerce est installé et activé.
include_once(ABSPATH . 'wp-admin/includes/plugin.php');
if (!is_plugin_active('woocommerce/woocommerce.php')) {
    activate_plugin('woocommerce/woocommerce.php');
}

// Chemin du fichier CSV
$file_path = '/var/www/html/wp-content/uploads/sample-products.csv';

// Importer les données en utilisant WP CLI ou un plugin approprié
if (file_exists($file_path)) {
    echo "Importing products...";
    shell_exec("wp wc product_csv_import --user=admin --file=$file_path");
    echo "Import completed successfully!";
} else {
    echo "CSV file not found!";
}

// Créer une clé API.
$api_keys = wc()->api_keys->create_keys(array(
    'description' => 'API Key for Testing',
    'permissions' => 'read_write',
    'user_id' => 1,
));

// Affiche les détails de la clé API pour utilisation ultérieure.
echo "Clé API : " . $api_keys['consumer_key'] . "\n";
echo "Secret API : " . $api_keys['consumer_secret'] . "\n";
?>
