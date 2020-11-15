# syntax=docker/dockerfile:experimental

ARG IMAGE="ghdl/cosim:py"

#--

FROM $IMAGE AS build

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    g++ \
    git \
    python3-dev

RUN git clone -b stable/1.4 --recurse-submodules https://github.com/cocotb/cocotb /tmp/cocotb \
 && cd /tmp/cocotb \
 && python3 setup.py bdist_wheel \
 && mv dist/*.whl /tmp \
 && git clone -b master --recurse-submodules https://github.com/VUnit/vunit /tmp/vunit \
 && cd /tmp/vunit \
 && python3 setup.py bdist_wheel \
 && mv dist/*.whl /tmp

#--

FROM $IMAGE

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libpython3.7-dev \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,from=build,src=/tmp/,target=/tmp/ pip3 install -U /tmp/*.whl --progress-bar off \
 && rm -rf ~/.cache
