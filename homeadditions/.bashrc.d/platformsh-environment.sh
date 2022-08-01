#ddev-generated

for item in .global/environment .environment; do
  if [ -f "${item}" ]; then
    . "${item}"
  fi
done
