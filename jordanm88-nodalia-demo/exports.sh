# NodaLia was listed as "jordanm88-lia-demo" before the rename, and Umbrel derives each app's secrets from
# its id. An install whose data hooks/pre-install copied from that app (it leaves a marker) keeps
# using the old id's seed as its encryption key, or its encrypted data couldn't be read.
if [[ -f "${EXPORTS_APP_DIR}/data/db/.from-jordanm88-lia-demo" ]]; then
  export APP_NODALIA_DEMO_DATA_SEED="$(derive_entropy "app-jordanm88-lia-demo-seed")"
else
  export APP_NODALIA_DEMO_DATA_SEED="$(derive_entropy "app-jordanm88-nodalia-demo-seed")"
fi
