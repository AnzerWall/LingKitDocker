FROM emscripten/emsdk:4.0.7

RUN apt-get update;\
    apt-get install -y git build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev;\
    apt-get install -y build-essential libxi-dev libglu1-mesa-dev libglew-dev pkg-config xvfb libgl1-mesa- curl; \
    rm -rf /var/lib/apt/lists/*


RUN git clone --recursive https://github.com/xmake-io/xmake.git;\
    cd ./xmake; \
    ./configure --toolchain=gcc --plat=linux  --arch=x86_64;\
    make -j8;\
    ./scripts/get.sh __local__ __install_only__;\
    cd ..;\
    rm -rf xmake


ARG NODE_VERSION=20
# install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# set env
ENV NVM_DIR=/root/.nvm
# install node
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION"
RUN bash -c "source $NVM_DIR/nvm.sh && nvm use $NODE_VERSION && npm i pnpm -g"
RUN bash -c "source $NVM_DIR/nvm.sh && nvm use $NODE_VERSION && npx -y playwright install --with-deps --only-shell"
