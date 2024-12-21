#!/bin/bash

# Vérifier si les arguments nécessaires sont fournis
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <mot_de_passe> <fichier_entree.pdf> <fichier_sortie.pdf>"
    exit 1
fi

# Assigner les arguments à des variables
PASSWORD=$1
INPUT_FILE=$2
OUTPUT_FILE=$3

# Créer un fichier PostScript intermédiaire
TEMP_PS=$(mktemp).ps

# Convertir le PDF en PostScript
pdftops -upw "$PASSWORD" "$INPUT_FILE" "$TEMP_PS"

# Convertir le PostScript de nouveau en PDF
ps2pdf "$TEMP_PS" "$OUTPUT_FILE"

# Nettoyer le fichier temporaire
rm "$TEMP_PS"

echo "Le fichier PDF déchiffré a été créé : $OUTPUT_FILE"
