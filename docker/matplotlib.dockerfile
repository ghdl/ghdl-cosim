FROM ghdl/cosim:py

RUN apt update -qq \
 && apt install -y imagemagick libssl-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/* \
 && python3 -m pip install matplotlib numpy --progress-bar off
