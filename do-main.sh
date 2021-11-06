#! /bin/bash
KranulVer="44"
branch="r5/hmp"
WithSpec="Y"
CODENAME="X01BD"
FolderUp=""
PrivBuild="N"
PureKernel="N"
CUSKERNAME=""
CUSKERLINK=""
CUSBUILDDATE=""
CUSSPEC=""
TypeBuild="RELEASE"
BuilderKernel="00000"

if [ "$KranulVer" = "419" ];then
CAFTAG="08700"
fi

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "gcc12" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "yuki" ] && [ "$BuilderKernel" != "sdclang" ] && [ "$BuilderKernel" != "aosp" ] && [ "$BuilderKernel" != "elas" ] && [ "$BuilderKernel" != "iris" ] && [ "$BuilderKernel" != "atom" ] && [ "$BuilderKernel" != "otaku" ];then
    exit;
fi

if [ "$KranulVer" = "44" ];then
KranulLink="android_kernel_asus_sdm660"
if [ "$branch" = "r5/eas" ] || [ "$branch" == "r5/eas-s2" ] || [ "$branch" = "eas-test" ];then
TypeBuildTag="EAS"
AKbranch="4.4-eas"
else
TypeBuildTag="HMP"
AKbranch="4.4-hmp"
fi
elif [ "$KranulVer" = "419" ];then
KranulLink="android_kernel_asus_sdm660-4.19"
TypeBuildTag="EAS"
AKbranch="4.19"
fi

. main.sh 'initial' 'full'

getInfo ">> Building kernel . . . . <<"

# NLV NFI / 4.19 / PureKernel Build
CompileKernel
GoForStock
CompileKernel

if [ "$KranulVer" = "44" ] && [ "$TypeBuild" == "RELEASE" ] && [ "$PureKernel" == "N" ];then

# LV NFI Build
ResetKernel
GoForLV
CompileKernel
GoForStock
COmpileKernel

# NLV OFI Build
ResetKernel
SwitchOFI
CompileKernel
GoForStock
CompileKernel

# LV OFI Build
ResetKernel
SwitchOFI
GoForLV
CompileKernel
GoForStock
CompileKernel

if [ "$CODENAME" == "X01BD" ];then
# X01BD Pie Custom ROM Build
ResetKernel
FixPieWifi
CompileKernel
GoForStock
CompileKernel
fi

fi