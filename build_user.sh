#!/usr/bin/env bash
# Written and placed into the public domain by
# Elias Oenal <cg@eliasoenal.com>
set -e
export DEVKITPRO=/opt/devkitpro
export PATH=/opt/devkitpro/tools/bin:$PATH
export PKG_CONFIG_PATH="/opt/devkitpro/portlibs/switch/lib/pkgconfig/"
export C_INCLUDE_PATH="/opt/devkitpro/portlibs/switch/include:/opt/devkitpro/libnx/include"
export CPLUS_INCLUDE_PATH="/opt/devkitpro/portlibs/switch/include:/opt/devkitpro/libnx/include"
export CFLAGS="-march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE -ffunction-sections -fdata-sections -D__SWITCH__ -march=armv8-a -mtune=cortex-a57 -mtp=soft -ftls-model=local-exec -DUSE_FILE32API -DIOAPI_NO_64"
export CXXFLAGS="-march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE -ffunction-sections -fdata-sections -D__SWITCH__ -march=armv8-a -mtune=cortex-a57 -mtp=soft -ftls-model=local-exec -DUSE_FILE32API -DIOAPI_NO_64 -DLUA_C89_NUMBERS"
export LDFLAGS="-Wl,--gc-sections -specs=/opt/devkitpro/libnx/switch.specs -L/opt/devkitpro/libnx/lib -L/opt/devkitpro/portlibs/switch/lib"
mkdir -p /artifacts/debug
mkdir -p /artifacts/log
DATE="$(date -u +"%Y-%m-%d_%T")"
LOGFILE="/artifacts/log/$DATE.log"
exec > >(tee -a "${LOGFILE}" )
exec 2> >(tee -a "${LOGFILE}" >&2)
echo ""
echo "###########################"
echo "#      Build Docker:      #"
echo "#    Commander Genius     #"
echo "#           for           #"
echo "#    Nintendo Switch      #"
echo "###########################"
echo ""
echo "Date: $DATE"
echo ""
echo "###########################"
echo "#   Updating repository   #"
echo "###########################"
echo ""
cd
cd Commander-Genius
rm -rf build
git pull
mkdir -p build
cd build
echo ""
echo "###########################"
echo "#     Executing CMake     #"
echo "###########################"
echo ""
cmake .. -DCMAKE_SYSTEM_NAME=generic -DCMAKE_C_COMPILER=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-gcc -DCMAKE_CXX_COMPILER=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-g++ -DCMAKE_RANLIB=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-ranlib -DCMAKE_AR=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-arcmake .. -DCMAKE_SYSTEM_NAME=generic -DCMAKE_C_COMPILER=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-gcc -DCMAKE_CXX_COMPILER=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-g++ -DCMAKE_RANLIB=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-ranlib -DCMAKE_AR=/opt/devkitpro/devkitA64/bin/aarch64-none-elf-ar -DCMAKE_PREFIX_PATH=/opt/devkitpro/portlibs/switch/ -DUSE_BOOST=NO -DPKG_CONFIG_EXECUTABLE=/opt/devkitpro/tools/bin/pkg-config -DUSE_OPENGL=No -DSDL2=Yes -DUSE_VIRTUALPAD=ON -DUSE_CRASHHANDLER=OFF -DNINTENDO_SWITCH=ON && tr -d '\n' < src/CMakeFiles/CGeniusExe.dir/link.txt > src/CMakeFiles/CGeniusExe.dir/link2.txt && echo "-lEGL -lGLESv2 -lglapi -ldrm_nouveau -lcurl -lmbedtls -lmbedcrypto -lmbedx509 -lmodplug -lmpg123 -lvorbisidec -logg -lopusfile -lopus -lpng -lwebp -lfreetype -ljpeg -lz -lbz2 -lnx -lm -lSDL2" >> src/CMakeFiles/CGeniusExe.dir/link2.txt && mv src/CMakeFiles/CGeniusExe.dir/link2.txt src/CMakeFiles/CGeniusExe.dir/link.txt
VERSION="$(grep "Release" ../version.h | cut -d '"' -f2 | sed  "s/-Release//g")-$(git rev-parse --short HEAD)"
nacptool --create "Commander Genius" "Gerhard Stein Build: Elias Oenal" "$VERSION" ../switch/cg.nacp
echo ""
echo "###########################"
echo "#  Executing Compilation  #"
echo "###########################"
echo ""
make -j$(nproc) && elf2nro src/CGeniusExe CommanderGenius.nro --nacp=../switch/cg.nacp --icon=../switch/cglogo256.jpg
cp src/CGeniusExe "/artifacts/debug/CGeniusExe-$VERSION" # Only needed for debugging
cp CommanderGenius.nro "/artifacts/CommanderGenius-$VERSION.nro"
echo ""
echo "###########################"
echo "#    Build completed!     #"
echo "#  Ver.: $VERSION  #"
echo "#   Binaries stored in:   #"
echo "#       /artifacts        #"
echo "###########################"
sleep 1 # allow tee to finish writing logs
