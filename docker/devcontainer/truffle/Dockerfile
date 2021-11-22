ARG IMAGE

FROM ${IMAGE} as parent

# [Optional] Uncomment if you want to install more global node modules
# Install eslint
USER node

RUN umask 0002 && npm install -g eslint && \
  npm install -g truffle && \
  npm cache clean --force > /dev/null 2>&1