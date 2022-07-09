#ddev-generated
export PATH=$PATH:/var/www/html/.global/bin
for item in .global/environment .environment; do
  if [ -f "${item}" ]; then
    . "${item}"
  fi
done
