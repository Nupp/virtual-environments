ARG IMAGE

FROM ${IMAGE} as parent

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install needed packages, yarn, nvm and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG NPM_GLOBAL=/usr/local/share/npm-global

ENV NVM_DIR=/usr/local/share/nvm \
    NVM_SYMLINK_CURRENT=true \ 
    PATH=${NPM_GLOBAL}/bin:${NVM_DIR}/current/bin:${PATH}

COPY library/*.sh library/*.env /tmp/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    # Install common packages, non-root user, update yarn and install nvm
    && bash /tmp/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Install yarn, nvm
    && rm -rf /opt/yarn-* /usr/local/bin/yarn /usr/local/bin/yarnpkg \
    && bash /tmp/node-debian.sh "${NVM_DIR}" "none" "${USERNAME}" \
    # Configure global npm install location, use group to adapt to UID/GID changes
    && if ! cat /etc/group | grep -e "^npm:" > /dev/null 2>&1; then groupadd -r npm; fi \
    && usermod -a -G npm ${USERNAME} \
    ## umask es una orden y una función en entornos POSIX que establece los permisos por defecto para los nuevos archivos y directorios creados por el proceso actual.
    && umask 0002 \
    && mkdir -p ${NPM_GLOBAL} \
    && touch /usr/local/etc/npmrc \
    && chown ${USERNAME}:npm ${NPM_GLOBAL} /usr/local/etc/npmrc \
    && chmod g+s ${NPM_GLOBAL} \
    && npm config -g set prefix ${NPM_GLOBAL} \
    && sudo -u ${USERNAME} npm config -g set prefix ${NPM_GLOBAL} \
    # Install python-is-python3 on bullseye to prevent node-gyp regressions
    && . /etc/os-release \
    && if [ "${VERSION_CODENAME}" = "bullseye" ]; then apt-get -y install --no-install-recommends python-is-python3; fi \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /root/.gnupg /tmp/library-scripts

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment if you want to install an additional version of node using nvm
# ARG EXTRA_NODE_VERSION=10
# RUN su node -c "source /usr/local/share/nvm/nvm.sh && nvm install ${EXTRA_NODE_VERSION}"

# [Optional] Uncomment if you want to install more global node modules
# Install eslint
USER node

RUN umask 0002 && npm install -g eslint && \
    npm install -g yarn && \
    npm cache clean --force > /dev/null 2>&1