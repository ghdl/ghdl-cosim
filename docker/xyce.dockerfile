FROM ghdl/cosim:py AS build

RUN apt-get update -qq && \
DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
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
ENV PATH="${PATH}:/tmp${XYCE_OUTDIR}bin"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/tmp${XYCE_OUTDIR}lib"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/tmp${XYCE_OUTDIR}lib"
ENV CPATH="${CPATH}:/tmp${XYCE_OUTDIR}include"

WORKDIR /tmp/build/

# Get Trilinos and Xyce
RUN mkdir -p Trilinos/trilinos-source && \
curl -fsSL https://github.com/trilinos/Trilinos/archive/trilinos-release-12-12-1.tar.gz | \
tar xz -C Trilinos/trilinos-source --strip-components=1 && \
mkdir -p Xyce && \
curl -fsSL https://xyce.sandia.gov/downloads/_assets/documents/Xyce-6.12.tar.gz | \
tar xz -C Xyce --strip-components=1

ENV ARCHDIR=$XYCE_OUTDIR
ENV FLAGS="-O3 -fPIC"

# Build Trilinos
RUN cd Trilinos && \
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
-DTrilinos_ENABLE_Isorropia=ON \
-DTrilinos_ENABLE_AztecOO=ON \
-DTrilinos_ENABLE_Belos=ON \
-DTrilinos_ENABLE_Triutils=ON \
-DTrilinos_ENABLE_Teuchos=ON \
-DTeuchos_ENABLE_COMPLEX=ON \
-DTrilinos_ENABLE_Amesos=ON \
-DAmesos_ENABLE_KLU=ON \
-DAmesos_ENABLE_UMFPACK=ON \
-DTrilinos_ENABLE_Sacado=ON \
-DTrilinos_ENABLE_Kokkos=OFF \
-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
-DTPL_ENABLE_AMD=ON \
-DAMD_LIBRARY_DIRS="/usr/lib" \
-DTPL_AMD_INCLUDE_DIRS="/usr/include/suitesparse" \
-DTPL_ENABLE_UMFPACK=ON \
-DUMFPACK_LIBRARY_DIRS="/usr/lib" \
-DTPL_UMFPACK_INCLUDE_DIRS="/usr/include/suitesparse" \
-DTPL_ENABLE_BLAS=ON \
-DTPL_ENABLE_LAPACK=ON \
./trilinos-source && \
make DESTDIR=/tmp -j$(nproc) install

ENV xyceBuildDir=/opt/Xyce/xyce-build/

# Build Xyce
RUN mkdir xyce-build && cd xyce-build && \
../Xyce/configure \
CXXFLAGS="-O3 -std=c++11" \
LDFLAGS="-Wl,-rpath=$xyceBuildDir/utils/XyceCInterface -Wl,-rpath=$xyceBuildDir/lib" \
CPPFLAGS="-I/usr/include/suitesparse" \
ADMS_CXXFLAGS="-O1" \
--disable-reaction_parser \
--disable-verbose_linear \
--disable-verbose_nonlinear \
--disable-verbose_time \
--enable-shared \
--enable-xyce-shareable && \
make DESTDIR=/tmp -j$(nproc) install

#--

FROM ghdl/cosim:py

COPY --from=build /tmp/usr/local /usr/local

RUN apt-get update -qq && \
DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
  ca-certificates \
  libgfortran5 \
  libfftw3-3 \
  libblas3 \
  liblapack3 \
  libsuitesparseconfig5 \
  libumfpack5 \
  && \
apt-get autoclean && apt-get clean && apt-get -y autoremove && \
update-ca-certificates && \
rm -rf /var/lib/apt/lists/* && \
pip3 install tox pytest
