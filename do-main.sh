#! /bin/bash
branch="injectorx"
BuilderKernel="00000"

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "evagcc" ] ;then
    exit;
fi
. main.sh 'initial' 'full'

FolderUp="BrokenNucleus"
TypeBuild="RELEASE"
if [ "$branch" = "injectorx-eas" ];then
TypeBuildTag="EAS"
TypeScript="EAS Advanced Configuration"
spectrumFile="eas.rc"
else
TypeBuildTag="HMP"
TypeScript="Spectrum"
spectrumFile="ryuu.rc"
fi
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
