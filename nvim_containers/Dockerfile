FROM fedora:latest

RUN dnf update -y && \
    dnf install -y ninja-build git cmake gcc g++ make unzip gettext curl tar nodejs fzf python3-pip ripgrep &&\
    git clone https://github.com/neovim/neovim.git

WORKDIR neovim

RUN make CMAKE_BUILD_TYPE=RelWithDebInfo &&\
    make install &&\
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\ 
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

RUN mkdir -p ~/.config

COPY nvim /app/nvim

RUN mv /app/nvim ~/.config/nvim &&\
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' &&\
    rm -rf /neovim

WORKDIR /app

ENTRYPOINT bash
