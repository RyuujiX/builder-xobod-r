#! /bin/bash
branch="injectorx"
BuilderKernel="00000"

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "evagcc" ] ;then
    exit;
fi
. main.sh 'initial' 'full'

FolderUp="BrokenNucleus"
spectrumFile="ryuu.rc"
TypeBuild="Stable"
TypeBuildTag="Yeah"
getInfo ">> Building kernel . . . . <<"

CompileKernel
# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

SwitchOFI

CompileKernel
# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"
