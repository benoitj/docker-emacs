FROM archlinux:latest

LABEL maintainer="Benoit Joly <benoit@benoitj.ca>"

RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm xorg-xauth emacs

RUN pacman -S --noconfirm \
    curl \
    ditaa \
    fakeroot \
    git \
    graphviz \
    jdk11-openjdk \
    plantuml \
    plantuml-ascii-math \
    sudo \
    unzip \
    wget \
    xorg-xeyes

RUN mkdir /root/FiraCode && \
    cd /root/FiraCode && \
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip && \
    unzip /root/FiraCode/FiraCode.zip -d /root/FiraCode/ && \
    find ~/FiraCode -iname "*.otf" -not -iname "*Windows Compatible.otf" -execdir install -Dm644 {} "/usr/share/fonts/OTF/{}" \; && \
    find ~/FiraCode -iname "*.ttf" -not -iname "*Windows Compatible.ttf" -execdir install -Dm644 {} "$pkgdir/usr/share/fonts/TTF/{}" \;

RUN useradd -m emacs

RUN echo "emacs ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/emacs

USER emacs

CMD "emacs"
