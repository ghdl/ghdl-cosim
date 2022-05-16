FROM ghdl/cosim:py AS build

RUN apt-get update -qq && \
DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  autoconf \
  automake \
  bison \
  ca-certificates \
  curl \
  cmake \
  gcc \
  make \
  g++ \
  gfortran \
  libfl-dev \
  libfftw3-dev \
  libsuitesparse-dev \
  libblas-dev \
  liblapack-dev \
  libtool

ENV XYCE_OUTDIR=/usr/local/
ENV PATH="${PATH}:/tmp/xyce${XYCE_OUTDIR}bin"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/tmp/xyce${XYCE_OUTDIR}lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/tmp/xyce${XYCE_OUTDIR}lib"
ENV CPATH="${CPATH}:/tmp/xyce${XYCE_OUTDIR}include"

WORKDIR /tmp/build/

# Get Trilinos and Xyce
RUN mkdir -p Trilinos/trilinos-source && \
curl -fsSL https://github.com/trilinos/Trilinos/archive/trilinos-release-12-12-1.tar.gz | \
tar xz -C Trilinos/trilinos-source --strip-components=1

# Build Trilinos
RUN cd Trilinos && \
FLAGS="-O3 -fPIC" && \
cmake \
  -G "Unix Makefiles" \
  -DCMAKE_CXX_FLAGS="$FLAGS" \
  -DCMAKE_C_FLAGS="$FLAGS" \
  -DCMAKE_Fortran_FLAGS="$FLAGS" \
  -DCMAKE_INSTALL_PREFIX="$XYCE_OUTDIR" \
  -DCMAKE_MAKE_PROGRAM="make" \
  -DBUILD_SHARED_LIBS=ON \
  -DTrilinos_ENABLE_EXPLICIT_INSTANTIATION=ON \
  -DTrilinos_ENABLE_NOX=ON \
    -DNOX_ENABLE_LOCA=ON \
  -DTrilinos_ENABLE_EpetraExt=ON \
    -DEpetraExt_BUILD_BTF=ON \
    -DEpetraExt_BUILD_EXPERIMENTAL=ON \
    -DEpetraExt_BUILD_GRAPH_REORDERINGS=ON \
  -DTrilinos_ENABLE_TrilinosCouplings=ON \
  -DTrilinos_ENABLE_Ifpack=ON \
  -DTrilinos_ENABLE_AztecOO=ON \
  -DTrilinos_ENABLE_Belos=ON \
  -DTrilinos_ENABLE_Teuchos=ON \
    -DTeuchos_ENABLE_COMPLEX=ON \
  -DTrilinos_ENABLE_Amesos=ON \
    -DAmesos_ENABLE_KLU=ON \
  -DTrilinos_ENABLE_Amesos2=ON \
    -DAmesos2_ENABLE_KLU2=ON \
    -DAmesos2_ENABLE_Basker=ON \
  -DTrilinos_ENABLE_Sacado=ON \
  -DTrilinos_ENABLE_Stokhos=ON \
  -DTrilinos_ENABLE_Kokkos=ON \
  -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
  -DTrilinos_ENABLE_CXX11=ON \
  -DTPL_ENABLE_AMD=ON \
  -DAMD_LIBRARY_DIRS="/usr/lib" \
  -DTPL_AMD_INCLUDE_DIRS="/usr/include/suitesparse" \
  -DTPL_ENABLE_BLAS=ON \
  -DTPL_ENABLE_LAPACK=ON \
  ./trilinos-source && \
make DESTDIR=/tmp/xyce/ -j$(nproc) install

# Get Xyce
RUN mkdir -p Xyce && \
curl -fsSL https://codeload.github.com/Xyce/Xyce/tar.gz/master | \
tar xz -C Xyce --strip-components=1

# Build Xyce
RUN cd Xyce && ./bootstrap \
 && mkdir xyce-build && cd xyce-build \
 && xyceBuildDir=/opt/Xyce/xyce-build/ \
 && ../configure \
      CXXFLAGS="-O3" \
      LDFLAGS="-Wl,-rpath=$xyceBuildDir/utils/XyceCInterface -Wl,-rpath=$xyceBuildDir/lib" \
      CPPFLAGS="-I/usr/include/suitesparse" \
      ARCHDIR=$XYCE_OUTDIR \
      --enable-shared \
      --enable-xyce-shareable \
      --enable-stokhos \
      --enable-amesos2 \
 && make DESTDIR=/tmp/xyce/ -j$(nproc) install

#--

FROM ghdl/cosim:py

COPY --from=build /tmp/xyce/ /

RUN apt-get update -qq && \
DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  ca-certificates \
  libamd2 \
  libgfortran5 \
  libfftw3-3 \
  libblas3 \
  liblapack3 \
  libsuitesparseconfig5 \
  && \
apt-get autoclean && apt-get clean && apt-get -y autoremove && \
update-ca-certificates && \
rm -rf /var/lib/apt/lists/* && \
pip3 install tox pytest
