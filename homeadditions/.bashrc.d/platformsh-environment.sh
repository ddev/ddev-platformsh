#ddev-generated

export PATH=$PATH:$PLATFORM_APP_DIR/.global/bin

for item in .global/environment .environment; do
  if [ -f "${item}" ]; then
    . "${item}"
  fi
done
