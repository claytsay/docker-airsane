# syntax=docker/dockerfile:1
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive
#RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

# Install packages
RUN apt-get update && apt-get install -y \
    sane \
    sane-utils \
#    libsane-extras \
    libsane-hpaio \
    dbus \
    avahi-utils \
    supervisor \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Configure saned
RUN adduser saned scanner \
    && adduser saned lp \
    && chown saned:lp /etc/sane.d/saned.conf /etc/sane.d/dll.conf

# Download, build, and install AirSane
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    git \
    libavahi-client-dev \
    libjpeg-dev \
    libpng-dev \
    libsane-dev \
    libusb-1.*-dev \
    && git clone https://github.com/SimulPiscator/AirSane.git \
    && mkdir AirSane-build && cd AirSane-build \
    && cmake ../AirSane \
    && make \
    && make install \
    && cd .. \
    && rm -rf AirSane \
    && rm -rf AirSane-build \
    && apt-get remove --purge -y \
    cmake \
    g++ \
    git \
    libavahi-client-dev \
    libjpeg-dev \
    libpng-dev \
    libsane-dev \
    libusb-1.*-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Configure apps
COPY configure.sh /configure.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start supervisord
CMD [ "supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf" ]

EXPOSE 6566 8090 10000 10001
