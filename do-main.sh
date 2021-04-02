#! /bin/bash
# branch="injectorx"
# BuilderKernel="clang"

# if [ "$BuilderKernel" != "clang" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "mystic" ] ;then
#     exit;
# fi
# . main.sh 'initial' 'full'

# FolderUp="BrokenNucleus"
# spectrumFile="ryuu.rc"
# TypeBuild="Stable"
# TypeBuildTag="Yeah"
# getInfo ">> Building kernel . . . . <<"

# # CompileKernel
# # CompileKernel "65"
# # CompileKernel "68"
# # CompileKernel "71"
# # CompileKernel "72"

# SwitchOFI

# CompileKernel
# # CompileKernel "65"
# # CompileKernel "68"
# # CompileKernel "71"
# # CompileKernel "72"

mainDir=$PWD
GdriveDir=$mainDir/Gdrive-Uploader

git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/gd-up -b master $GdriveDir
echo 'test' > test.txt
fileNya="$(pwd)/test.txt"
cd FOLDERUPLOADNYA
chmod +x gdrive
chmod +x run.sh
. run.sh "$fileNya" "x01bd"
cd ..
rm -rf *
