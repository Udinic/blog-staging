# install once if needed: brew install pandoc
POST_DATE=$(date +%F)                     # or set manually, e.g. 2025-10-14
SLUG="Tagity-tag"                      # kebab-case
DOCX="/Users/udinic/Projects/TagReader/post/Tagity-tag.docx"     # path to your exported docx

ASSET_DIR="assets/posts/${SLUG}"
POST_FILE="_posts/${POST_DATE}-${SLUG}.md"

mkdir -p "${ASSET_DIR}"
pandoc "${DOCX}" \
  -f docx -t gfm \
  --extract-media="${ASSET_DIR}" \
  --wrap=none \
  -o "${POST_FILE}"

# Add minimal Jekyll front matter if missing
if ! head -n1 "${POST_FILE}" | grep -q '^---$'; then
  TMP=$(mktemp)
  cat > "${TMP}" <<'YAML'
---
layout: post
title: "REPLACE ME"
date: REPLACE_DATE
categories: []
tags: []
# If you use a custom permalink structure, add it here
# permalink: /blog/REPLACE-SLUG/
---
YAML
  sed -i '' "s/REPLACE ME/${SLUG//-/ /}/" "${TMP}" 2>/dev/null || sed -i "s/REPLACE ME/${SLUG//-/ /}/" "${TMP}"
  sed -i '' "s/REPLACE_DATE/${POST_DATE}/" "${TMP}" 2>/dev/null || sed -i "s/REPLACE_DATE/${POST_DATE}/" "${TMP}"
  cat "${POST_FILE}" >> "${TMP}"
  mv "${TMP}" "${POST_FILE}"
fi

echo "✅ Wrote ${POST_FILE} with images in ${ASSET_DIR}"