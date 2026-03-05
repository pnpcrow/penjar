#!/usr/bin/env bash

#########################################
## Air Gapped config
#########################################

if [[ $PENJAR_FLAGS == *"enable-air-gapped-conf"* ]]; then
    rm /etc/nginx/overrides/location.d/external-locations.conf;
    export PENJAR_FLAGS="$PENJAR_FLAGS disable-google-fonts-provider disable-dashboard-templates-section"
fi

#########################################
## App Frontend config
#########################################

update_flags() {
  if [ -n "$PENJAR_FLAGS" ]; then
    echo "$(sed \
      -e "s|^//var penjarFlags = .*;|var penjarFlags = \"$PENJAR_FLAGS\";|g" \
      "$1")" > "$1"
  fi
}

update_flags /var/www/app/js/config.js

#########################################
## Nginx Config
#########################################

export PENJAR_BACKEND_URI=${PENJAR_BACKEND_URI:-http://penjar-backend:6060}
export PENJAR_EXPORTER_URI=${PENJAR_EXPORTER_URI:-http://penjar-exporter:6061}
export PENJAR_NITRATE_URI=${PENJAR_NITRATE_URI:-http://penjar-nitrate:3000}
export PENJAR_HTTP_SERVER_MAX_BODY_SIZE=${PENJAR_HTTP_SERVER_MAX_BODY_SIZE:-367001600} # Default to 350MiB
envsubst "\$PENJAR_BACKEND_URI,\$PENJAR_EXPORTER_URI,\$PENJAR_NITRATE_URI,\$PENJAR_HTTP_SERVER_MAX_BODY_SIZE" \
         < /tmp/nginx.conf.template > /etc/nginx/nginx.conf

PENJAR_DEFAULT_INTERNAL_RESOLVER="$(awk 'BEGIN{ORS=" "} $1=="nameserver" { sub(/%.*$/,"",$2); print ($2 ~ ":")? "["$2"]": $2}' /etc/resolv.conf)"
export PENJAR_INTERNAL_RESOLVER=${PENJAR_INTERNAL_RESOLVER:-$PENJAR_DEFAULT_INTERNAL_RESOLVER}
envsubst "\$PENJAR_INTERNAL_RESOLVER" \
         < /tmp/resolvers.conf.template > /etc/nginx/overrides/http.d/resolvers.conf

exec "$@";
