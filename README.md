# GCHP_14.6
**GCHP Build and Run Instructions**
# Step 1: Load Required Modules
module load openmpi hdf5
# Step 2: Clone the GCHP Repository
git clone --recurse-submodules https://github.com/geoschem/GCHP.git ~/GCHP

cd ~/GCHP
# Step 3: Create Run Directory
cd run
./createRunDir.sh

**After this, configure your run settings as needed and set the run directory path**
# Step 4: Prepare Build Directory
cd ~/GCHP

mkdir -p build

cd build
# Step 5: Set Environment Variables (adjust paths as per your setup)
export NETCDF_ROOT=/data/lab/meng/jahidul/netcdf

export NETCDF_C_LIBRARY=$NETCDF_ROOT/lib/libnetcdf.so

export NETCDF_F_LIBRARY=$NETCDF_ROOT/lib/libnetcdff.so

export NETCDF_C_INCLUDE_DIR=$NETCDF_ROOT/include

export NETCDF_F90_INCLUDE_DIR=$NETCDF_ROOT/include

export LD_LIBRARY_PATH=$NETCDF_ROOT/lib:$LD_LIBRARY_PATH

export OPENMPI_ROOT=/home/mdjahidul.islam/software/openmpi/5.0.0

export PATH=$OPENMPI_ROOT/bin:$PATH

export LD_LIBRARY_PATH=$OPENMPI_ROOT/lib:$LD_LIBRARY_PATH

export INCLUDE=$OPENMPI_ROOT/include:$INCLUDE

export FPATH=$OPENMPI_ROOT/include:$FPATH

export LD_LIBRARY_PATH=/home/rohit.dhariwal/cadence/installs/SPECTRE211/tools.lnx86/lib/64bit/SuSE/SLES12:$LD_LIBRARY_PATH
# Step 6: Configure Build with CMake
cmake .. \
  -DCMAKE_C_COMPILER=/opt/apps/gcc/11.5/bin/gcc \
  -DCMAKE_CXX_COMPILER=/opt/apps/gcc/11.5/bin/g++ \
  -DCMAKE_Fortran_COMPILER=/opt/apps/gcc/11.5/bin/gfortran \
  -DCMAKE_PREFIX_PATH="$NETCDF_ROOT;/data/lab/meng/jahidul/ESMF/DEFAULTINSTALLDIR;$OPENMPI_ROOT" \
  -DNETCDF_DIR="$NETCDF_ROOT" \
  -DNETCDF_C_LIBRARY="$NETCDF_C_LIBRARY" \
  -DNETCDF_F_LIBRARY="$NETCDF_F_LIBRARY" \
  -DNETCDF_C_INCLUDE_DIR="$NETCDF_C_INCLUDE_DIR" \
  -DNETCDF_F90_INCLUDE_DIR="$NETCDF_F90_INCLUDE_DIR" \
  -DNETCDF_FORTRAN_INCLUDE_DIR="$NETCDF_F90_INCLUDE_DIR" \
  -DNETCDF_FORTRAN_LIBRARY="$NETCDF_F_LIBRARY" \
  -DMPI_C_COMPILER=$OPENMPI_ROOT/bin/mpicc \
  -DMPI_CXX_COMPILER=$OPENMPI_ROOT/bin/mpicxx \
  -DMPI_Fortran_COMPILER=$OPENMPI_ROOT/bin/mpif90 \
  -DMPI_HOME=$OPENMPI_ROOT \
  -DMPI_C_INCLUDE_DIR=$OPENMPI_ROOT/include \
  -DMPI_C_LIBRARIES=$OPENMPI_ROOT/lib/libmpi.so \
  -DMPI_Fortran_INCLUDE_DIR=$OPENMPI_ROOT/include \
  -DMPI_Fortran_LIBRARIES=$OPENMPI_ROOT/lib/libmpi_usempif08.so \
  -DESMF_DIR=/data/lab/meng/jahidul/ESMF/DEFAULTINSTALLDIR \
  -DESMF_MOD_DIR=/data/lab/meng/jahidul/ESMF/mod/modO/Linux.gfortran.64.openmpi.default \
  -DESMF_HEADERS_DIR=/data/lab/meng/jahidul/ESMF/DEFAULTINSTALLDIR/include \
  -DESMF_LIBRARY=/data/lab/meng/jahidul/ESMF/lib/libO/Linux.gfortran.64.openmpi.default/libesmf.a
# Step 7: Build GCHP
make -j
# Step 8: Setup Run Directory for Build
cmake . -DRUNDIR=/data/lab/meng/jahidul/trialgchp146  # Your run directory path
# Step 9: Install the Build
make install
# Step 10: Prepare to Run GCHP
**- Go to your run directory:**
cd /data/lab/meng/jahidul/trialgchp146 # Your run directory path

**- Edit `setCommonRunSettings.sh` to configure your simulation settings.**
nano setCommonRunSettings.sh
**- Source the settings:**
./setCommonRunSettings.sh
# Step 11: Setup Restart and Input File Links
**- Download required restart and input files to appropriate locations.**
**- Then run the restart linking script:**
./setRestartLink.sh
# Step 12: Submit the Job via Slurm
**Assuming you have a batch script named `gchp_run.sh`, submit your job:**

sbatch gchp_run.sh

