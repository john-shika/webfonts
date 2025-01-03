#!/usr/bin/env bash

CurrWorkDir=$(pwd)
ScriptRootDir=$(dirname "$0")
cd "$ScriptRootDir" || exit 1
cd ..

FONTS=$(find fonts -type f | grep -Ei '\.ttf$')

while IFS= read -r line; do
  # shellcheck disable=SC2001
  FILE=$(echo "$line" | sed -e 's/\.ttf//g')
  # shellcheck disable=SC2116
  CONVERT=$(echo "fontforge -lang=ff -c 'Open(\"$FILE.ttf\"); Generate(\"$FILE.otf\"); Generate(\"$FILE.woff\"); Generate(\"$FILE.woff2\"); Generate(\"$FILE.eot\"); Close();'")
  echo "$CONVERT" && eval "$CONVERT" &>/dev/null

done <<< "$FONTS"

AFMS=$(find fonts -type f | grep -Ei '\.afm$')

while IFS= read -r line; do
  FILE="$line"
  if [ -f "$FILE" ]; then
    rm -fv "$FILE"
  fi

done <<< "$AFMS"

echo -en | tee fonts.lst
find fonts -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | sed -e 's/\.\///g' | tee -a fonts.lst

DIRS=$(cat << 'EOF' | bash | sort -u
FONTS=$(find fonts -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$')

while IFS= read -r line; do
  FILE="$line"
  BASEDIR=$(dirname "$FILE")
  echo "$BASEDIR"

done <<< "$FONTS"
EOF
)

OUTPUT_FILE="index.css"

echo -en | tee $OUTPUT_FILE

while IFS= read -r line; do
  DIR="$line"
  NAME=$(basename "$DIR")

  echo "$NAME"

  FONTS_REGULAR=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-regular\.')
  FONTS_LIGHT=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-light\.')
  FONTS_ITALIC=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-italic\.')
  FONTS_OBLIQUE=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-oblique\.')
  FONTS_MEDIUM=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-medium\.')
  FONTS_BOLD=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-bold\.')
  FONTS_SEMIBOLD=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-semibold\.')
  FONTS_THIN=$(find "$DIR" -type f | grep -Ei '\.(ttf|otf|woff2?|eot)$' | grep -i '\-thin\.')

  if [ -n "$FONTS_REGULAR" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-Regular.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-Regular.woff') format('woff'),
       url('fonts/$NAME/$NAME-Regular.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
}
EOF
  fi

  if [ -n "$FONTS_LIGHT" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-Light.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-Light.woff') format('woff'),
       url('fonts/$NAME/$NAME-Light.ttf') format('truetype');
  font-weight: 300;
  font-style: normal;
}
EOF
  fi

  if [ -n "$FONTS_ITALIC" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-Italic.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-Italic.woff') format('woff'),
       url('fonts/$NAME/$NAME-Italic.ttf') format('truetype');
  font-weight: normal;
  font-style: italic;
}
EOF
  fi

  if [ -n "$FONTS_OBLIQUE" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-Oblique.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-Oblique.woff') format('woff'),
       url('fonts/$NAME/$NAME-Oblique.ttf') format('truetype');
  font-weight: normal;
  font-style: italic;
}
EOF
  fi

  if [ -n "$FONTS_MEDIUM" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-Medium.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-Medium.woff') format('woff'),
       url('fonts/$NAME/$NAME-Medium.ttf') format('truetype');
  font-weight: 500;
  font-style: normal;
}
EOF
  fi

  if [ -n "$FONTS_BOLD" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-Bold.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-Bold.woff') format('woff'),
       url('fonts/$NAME/$NAME-Bold.ttf') format('truetype');
  font-weight: bold;
  font-style: normal;
}
EOF
  fi

  if [ -n "$FONTS_SEMIBOLD" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-SemiBold.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-SemiBold.woff') format('woff'),
       url('fonts/$NAME/$NAME-SemiBold.ttf') format('truetype');
  font-weight: 600;
  font-style: normal;
}
EOF
  fi

  if [ -n "$FONTS_THIN" ]; then

cat << 'EOF' | sed -e "s/\$NAME/$NAME/g" | tee -a $OUTPUT_FILE

@font-face {
  font-family: '$NAME';
  src: url('fonts/$NAME/$NAME-Thin.woff2') format('woff2'),
       url('fonts/$NAME/$NAME-Thin.woff') format('woff'),
       url('fonts/$NAME/$NAME-Thin.ttf') format('truetype');
  font-weight: 100;
  font-style: normal;
}
EOF
  fi
  
done <<< "$DIRS"

cd "$CurrWorkDir" || exit 1
