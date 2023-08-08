
# I think this is close to the HDF US version?
FROM ubuntu:22.04

RUN apt-get update

RUN apt-get install -y vim tmux libncurses5-dev flex bison build-essential gcc gdb curl git autoconf libsqlite3-dev tar locales openssh-server python3 sqlite3

RUN locale-gen en_US.UTF-8

RUN useradd -m build

#RUN mkdir -p /opt/nethack/chroot/dgldir

RUN git clone https://github.com/NHTangles/dgamelaunch.git /home/build/dgamelaunch

WORKDIR /home/build/dgamelaunch

RUN ./autogen.sh --enable-shmem --enable-sqlite --with-config-file=/opt/nethack/chroot/etc/dgamelaunch.conf

RUN make

RUN sed -i -e "s/nethack.alt.org/chroot/" dgl-create-chroot

RUN ./dgl-create-chroot

RUN ./install-to-chroot.sh

RUN chmod +s /opt/nethack/chroot/dgamelaunch

RUN useradd -m -s /opt/nethack/chroot/dgamelaunch nethack

RUN passwd -d nethack

RUN sed -i '1s;^;auth    sufficient      pam_succeed_if.so quiet user = nethack;' /etc/pam.d/common-auth

# I hate how this isn't cross architecture
#RUN tar cf - \
#  /lib/x86_64-linux-gnu/libncurses* \
#  | tar xf - -C /opt/nethack/chroot/
#
#RUN cp -r /lib/terminfo /opt/nethack/chroot/lib


COPY entry.sh /entry.sh

COPY sshd_config /etc/ssh/sshd_config

COPY dgamelaunch.conf /opt/nethack/chroot/etc/dgamelaunch.conf

COPY dgl_main_menu_anon.txt /opt/nethack/chroot/dgldir/dgl_menu_main_anon.txt

COPY dgl_main_menu_user.txt /opt/nethack/chroot/dgldir/dgl_menu_main_user.txt

COPY dgl-banner /opt/nethack/chroot/dgldir/dgl-banner

CMD /entry.sh
