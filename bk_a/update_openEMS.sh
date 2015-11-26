
#!/bin/bash

# Compiling OpenEMS may require installing the following packages:
# apt-get install cmake qt4-qmake libtinyxml-dev libcgal-dev libvtk5-qt4-dev
# Compiling hyp2mat may require installing the following packages:
# apt-get install gengetopt help2man groff pod2pdf bison flex libhpdf-dev libtool

if [ $# -lt 1 ]
then
  echo "Usage: `basename $0` <path-to-install> [<options>]"
  echo ""
  echo "  options:"
  echo "	--with-hyp2mat:		enable hyp2mat build"
  echo "	--with-CTB		enable circuit toolbox"
  echo "	--disable-GUI		disable GUI build (AppCSXCAD)"
  exit $E_BADARGS
fi

# defaults
BUILD_HYP2MAT=0
BUILD_CTB=0
BUILD_GUI="YES"

# parse arguments
for varg in ${@:2:$#}
do
  case "$varg" in
    "--with-hyp2mat")
      echo "enabling hyp2mat build"
      BUILD_HYP2MAT=1
      ;;
    "--with-CTB")
      echo "enabling CTB build"
      BUILD_CTB=1
      ;;
    "--disable-GUI")
      echo "disabling AppCSXCAD build"
      BUILD_GUI="NO"
      ;;
    *)
      echo "error, unknown argumennt: $varg"
      exit 1
      ;;
  esac
done

basedir=$(pwd)
INSTALL_PATH=${1%/}
LOG_FILE=$basedir/build_$(date +%Y%m%d_%H%M%S).log

echo "setting install path to: $INSTALL_PATH"
echo "logging build output to: $LOG_FILE"

function build {
cd $1
make clean &> /dev/null

if [ -f bootstrap.sh ]; then
  echo "bootstrapping $1 ... please wait"
  sh ./bootstrap.sh >> $LOG_FILE
  if [ $? -ne 0 ]; then
    echo "bootstrap for $1 failed"
    cd ..
    exit
  fi
fi

if [ -f configure ]; then
  echo "configuring $1 ... please wait"
  ./configure $2 >> $LOG_FILE
  if [ $? -ne 0 ]; then
    echo "configure for $1 failed"
    cd ..
    exit
  fi
fi

echo "compiling $1 ... please wait"
make -j4 >> $LOG_FILE
if [ $? -ne 0 ]; then
  echo "make for $1 failed"
  cd ..
  exit
fi
cd ..
}

function install {
cd $1
echo "installing $1 ... please wait"
make ${@:2:$#} install >> $LOG_FILE
if [ $? -ne 0 ]; then
  echo "make install for $1 failed"
  cd ..
  exit
fi
cd ..
}

##### build openEMS and dependencies ####
tmpdir=`mktemp -d` && cd $tmpdir
echo "running cmake in tmp dir: $tmpdir"
cmake -DBUILD_APPCSXCAD=$BUILD_GUI -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $basedir >> $LOG_FILE
if [ $? -ne 0 ]; then
  echo "cmake failed"
  cd $basedir
  echo "build incomplete, cleaning up tmp dir ..."
  rm -rf $tmpdir
  exit
fi
echo "build openEMS and dependencies ... pleae wait"
make >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
  echo "make failed, build incomplete, please see logfile for more details..."
  cd $basedir
  echo "build incomplete, cleaning up tmp dir ..."
  rm -rf $tmpdir
  exit
fi
echo "build successful, cleaning up tmp dir ..."
rm -rf $tmpdir
cd $basedir

#####  addtional packages ####

if [ $BUILD_HYP2MAT -eq 1 ]; then
  #build hyp2mat
  build hyp2mat --prefix=$INSTALL_PATH
  install hyp2mat
fi

if [ $BUILD_CTB -eq 1 ]; then
  #install circuit toolbox (CTB)
  install CTB PREFIX=$INSTALL_PATH
fi

#####

echo " -------- "
echo "openEMS and all modules have been updated successfully..."
echo ""
echo "% add the required paths to Octave/Matlab:"
echo "addpath('$INSTALL_PATH/share/openEMS/matlab')"
echo "addpath('$INSTALL_PATH/share/CSXCAD/matlab')"
echo ""
echo "% optional additional pckages:"
if [ $BUILD_HYP2MAT -eq 1 ]; then
  echo "addpath('$INSTALL_PATH/share/hyp2mat/matlab'); % hyp2mat package"
fi
if [ $BUILD_CTB -eq 1 ]; then
  echo "addpath('$INSTALL_PATH/share/CTB/matlab'); % circuit toolbox"
fi
echo ""
echo "Have fun using openEMS"
