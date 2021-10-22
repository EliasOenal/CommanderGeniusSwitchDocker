# Written and placed into the public domain by
# Elias Oenal <cg@eliasoenal.com>
FROM devkitpro/devkita64
# Install ccache so it can be used during the build
RUN apt-get update && apt-get install --yes --no-install-recommends ccache cron
# Pacman requires mtab
RUN if [ ! -f "/etc/mtab" ]; then ln -s /proc/self/mounts /etc/mtab ; fi
# Update devkit pro
RUN /opt/devkitpro/pacman/bin/pacman --noconfirm -Syu

RUN useradd --create-home user
USER user
WORKDIR /home/user
RUN ln -s /ccache /home/user/.ccache
# Clone Commander Genius so the build will later only have to pull new commits
RUN cd && git clone https://gitlab.com/Dringgstein/Commander-Genius.git

USER root
COPY fix_perm.sh /fix_perm.sh
RUN chmod 755 /fix_perm.sh
COPY cron.sh /cron.sh
RUN chmod 755 /cron.sh
COPY build.sh /build.sh
RUN chmod 755 /build.sh
COPY build_user.sh /home/user/build_user.sh
RUN chmod 755 /home/user/build_user.sh
COPY crontab /etc/crontab
RUN chmod 644 /etc/crontab

CMD ["/cron.sh"]
