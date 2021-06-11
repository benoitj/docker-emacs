FROM archlinux:latest

LABEL maintainer="Benoit Joly <benoit@benoitj.ca>"

RUN pacman -Syu --noconfirm \
    bc \
    curl \
    cmake \
    emacs \
    fakeroot \
    gcc \
    git \
    make \
    sudo \
    unzip \
    wget \
    xorg-xauth \
    xorg-xeyes

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
