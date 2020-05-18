FROM ghdl/vunit:llvm

RUN apt update -qq \
 && apt install -y imagemagick \
 && python3 -m pip install pytest --progress-bar off
