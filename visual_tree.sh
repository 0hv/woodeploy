#!/bin/bash

# Déclaration des variables globales
EXPORT_FILE="tree.txt"
LIMIT=5
MAX_DISPLAY=15
DOSSIERS=0
FICHIERS=0

# Fonction pour afficher l'arborescence de fichiers et dossiers, et l'exporter dans un fichier texte
function afficher_arborescence {
    local prefix=$1
    local dir=$2
    local indent=${3:-}
    local dernier=${4:-1}

    # Initialisation ou écrasement du fichier d'arborescence si c'est la première fois
    if [ "$indent" == "" ]; then
        echo "" > "$EXPORT_FILE"
    fi

    # Ajouter le nom du répertoire actuel et incrémenter le compteur de dossiers
    echo "${indent}${prefix} $(basename "$dir")" >> "$EXPORT_FILE"
    ((DOSSIERS++))
    indent="$indent$(test $dernier == 1 && echo '    ' || echo '│   ')"

    # Récupérer les fichiers et dossiers à partir du répertoire courant
    local fichiers=("$dir"/*)
    local count=${#fichiers[@]}
    local i=0

    # Limiter le nombre d'éléments affichés si le répertoire contient trop d'éléments
    if [ $count -gt "$MAX_DISPLAY" ]; then
        fichiers=("${fichiers[@]:0:$LIMIT}")
        fichiers+=("[...]")
    fi

    # Parcourir chaque élément pour créer la structure
    for fichier in "${fichiers[@]}"; do
        ((i++))
        test $i == ${#fichiers[@]} && local dernier=1 || local dernier=0
        if [ "$fichier" == "[...]" ]; then
            echo "${indent}└── ${fichier}" >> "$EXPORT_FILE"
        elif [ -d "$fichier" ]; then
            afficher_arborescence "└──" "$fichier" "$indent" $dernier
        else
            echo "${indent}└── $(basename "$fichier")" >> "$EXPORT_FILE"
            ((FICHIERS++))
        fi
    done
}

# Lancer la fonction d'affichage depuis le répertoire actuel
afficher_arborescence "" "."

# Afficher un message récapitulatif
echo "L'arborescence a été créée dans '$EXPORT_FILE'."
echo "Elle contient $DOSSIERS dossiers et $FICHIERS fichiers."
