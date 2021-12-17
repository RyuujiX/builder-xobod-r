#! /bin/bash
KranulVer="44"
branch="r6/hmp"
CODENAME="X01BD"
WithSpec="Y"
PrivBuild="N"
PureKernel="N"
CUSKERNAME="" # Add "DCKN" on ResetBranch if u don't want Kernel Name Changed again
CUSKERLINK=""
CUSBUILDDATE=""
CUSSPEC=""
CUSCLANGVER=""
CUSLLDVER=""
TypeBuild="RELEASE"
BuilderKernel="00000"

if [ "$KranulVer" = "419" ];then
CAFTAG="02700"
fi

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "gcc12" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "sdclang" ] && [ "$BuilderKernel" != "atom" ] && [ "$BuilderKernel" != "zyc" ];then
    exit;
fi

source main.sh

getInfo ">> Starting Build . . . . <<"
if [ ! -z "$CUSKERNAME" ];then
ChangeKName "$CUSKERNAME"
fi

if [ $TypeBuild = "TEST" ];then
ResetBranch
LEDVib
StockFreq
SwitchOFI
CompileKernel
SwitchDevice "M1"
ResetBranch
LEDVib
StockFreq
SwitchOFI
CompileKernel
elif [ "$PureKernel" == "N" ] && [ $TypeBuild = "RELEASE" ];then
BuildAll
fi