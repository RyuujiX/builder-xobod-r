#! /bin/bash
KranulVer="419"
branch="r3/s"
CODENAME="X01BD"
WithSpec="Y"
PrivBuild="N"
PureKernel="Y"
CUSKERNAME="LA.UM.11.2.1.r1-02500-sdm660.0" # Add "DCKN" on ResetBranch if u don't want Kernel Name Changed again
CUSKERLINK=""
CUSBUILDDATE=""
CUSSPEC=""
CUSCLANGVER=""
CUSLLDVER=""
CUSMSGWORD=""
TypeBuild="TEST"
BuilderKernel="neutron"

if [ "$KranulVer" = "419" ];then
CAFTAG="02500"
fi

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "gcc12" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "sdclang" ] && [ "$BuilderKernel" != "atom" ] && [ "$BuilderKernel" != "zyc" ] && [ "$BuilderKernel" != "neutron" ];then
    exit;
fi

source main.sh

getInfo ">> Starting Build . . . . <<"
if [ ! -z "$CUSKERNAME" ];then
ChangeKName "$CUSKERNAME"
fi

if [ "$PureKernel" == "N" ] && [ $TypeBuild = "RELEASE" ];then
BuildAll
else
ResetBranch
CompileKernel
SwitchDevice "M1"
CompileKernel
fi;