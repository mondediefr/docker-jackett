#!/bin/bash

JACKETT_VERSION=$(grep "JACKETT_VER=" Dockerfile | cut -d"=" -f2)
NEW_JACKETT_VERSION=$(curl https://github.com/Jackett/Jackett/releases/latest 2> /dev/null | sed 's#.*tag/##;s#">.*##' |  cut -dv -f2)

f_gen_tag() {
    VERSION=$1

    TAGS="latest ${VERSION} $(echo ${VERSION} | cut -d'.' -f '1 2') $(echo ${VERSION} | cut -d'.' -f '1')"
}

f_maj_dockerfile() {
    BUILD_VER=$(date +%Y%m%d01)

    ## Edit dockerfile
    sed -i 's/JACKETT_VER=.*/JACKETT_VER='${NEW_JACKETT_VERSION}'/;
        s/tags=".*"/tags="'"${TAGS}"'"/;
        s/build_ver=".*"/build_ver="'${BUILD_VER}'"/' Dockerfile
    
}

f_maj_readme() {
    VERSION=$1
    TAGS=$(echo $TAGS | sed 's/ /, /g')

    sed -i 's#\* .*/Dockerfile)#\* '"${TAGS}"' \[(Dockerfile)\](https://github.com/xataz/dockerfiles/blob/master/Jackett/Dockerfile)#' README.md
}

if [ "${JACKETT_VERSION}" != "${NEW_JACKETT_VERSION}" ]; then
    echo "Upgrade jackett ${JACKETT_VERSION} to ${NEW_JACKETT_VERSION}"
    f_gen_tag $NEW_JACKETT_VERSION
    f_maj_dockerfile
    f_maj_readme
fi
