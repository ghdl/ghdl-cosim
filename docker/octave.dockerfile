FROM ghdl/vunit:llvm-master

RUN apt-get update -qq && \
DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  octave
