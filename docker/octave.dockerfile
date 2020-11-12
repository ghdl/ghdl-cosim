FROM ghdl/cosim:py

RUN apt-get update -qq && \
DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  octave
