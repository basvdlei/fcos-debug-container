FROM registry.fedoraproject.org/fedora:41
ARG stream=stable
ARG release
RUN test -n "$stream" && test -n "$release"

COPY install-fcos-kernel-devel.sh /usr/local/bin/install-fcos-kernel-devel.sh
RUN dnf install -y curl \
                   conntrack-tools \
                   bcc-tools \
                   bind-utils \
                   bison \
                   bpftrace \
                   bpftool \
                   elfutils-libelf-devel \
                   fio \
                   flex \
                   gawk \
                   gdb \
                   git \
                   golang \
                   htop \
                   httpd-tools \
                   httperf \
                   iotop \
                   iperf \
                   iproute \
                   iptables \
                   jq \
                   less \
                   lsof \
                   man-db \
                   mtr \
                   netcat \
                   nmap \
                   openssl-devel \
                   openssh-clients \
                   procps-ng \
                   psmisc \
                   python \
                   siege \
                   socat \
                   strace \
                   sysstat \
                   tcpdump \
                   tcpflow \
                   tcptraceroute \
                   telnet \
                   traceroute \
                   wireshark-cli \
                   vim
RUN install-fcos-kernel-devel.sh "$stream" "$release"
RUN echo "export PATH=\"$PATH:/usr/share/bcc/tools:/usr/share/bpftrace/tools\"" > /root/.bashrc
