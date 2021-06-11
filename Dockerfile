FROM archlinux:latest

LABEL maintainer="Benoit Joly <benoit@benoitj.ca>"

RUN curl -L -o /tmp/s6-overlay.tgz https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay.tgz -C /  --exclude="./bin" && \
    tar xzf /tmp/s6-overlay.tgz -C /usr ./bin

RUN pacman -Sy --noconfirm && \
    pacman -S --noconfirm xorg-xauth emacs


RUN pacman -S --noconfirm \
    curl \
    cmake \
    ditaa \
    fakeroot \
    gcc \
    git \
    graphviz \
    jdk11-openjdk \
    make \
    plantuml \
    plantuml-ascii-math \
    stow \
    sudo \
    unzip \
    wget \
    xorg-xeyes

RUN pacman -S --noconfirm \
    bc

RUN mkdir /root/FiraCode && \
    cd /root/FiraCode && \
    curl -s -L -o /root/FiraCode/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip && \
    unzip -q /root/FiraCode/FiraCode.zip -d /root/FiraCode/ && \
    find ~/FiraCode -iname "*.otf" -not -iname "*Windows Compatible.otf" -execdir install -Dm644 {} "/usr/share/fonts/OTF/{}" \; && \
    find ~/FiraCode -iname "*.ttf" -not -iname "*Windows Compatible.ttf" -execdir install -Dm644 {} "$pkgdir/usr/share/fonts/TTF/{}" \;


RUN git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && chmod ug+x su-exec \
    && mv su-exec /usr/local/bin


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV USER="emacs" \
    UID="1000" \
    GROUP="emacs" \
    GID="1000"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["emacs"]
