#! /bin/bash
KranulVer="44"
branch="r5/hmp"
WithSpec="Y"
MainCD="X01BD"
# SecCD="X00TD"
FolderUp=""
PrivBuild="N"
PureKernel="N"
CUSKERNAME=""
CUSKERLINK=""
CUSBUILDDATE=""
CUSSPEC=""
TypeBuild="RELEASE"
CODENAME="$MainCD"
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

# Notes :
# GoForLV to LED Vibration
# GoForStock to Stock Freq
# SwitchOFI to Pie WiFi Driver
# FixPieWifi to Build for X01BD Pie Custom ROMs
# SwitchDevice to Switch Device
# ResetKernel to Reset Kernel Source same like Origin
# CompileKernel to Compile Kernel
# FFRelease for 4.4 Release Build

# NLV NFI / 4.19 / PureKernel Build
CompileKernel
GoForStock
CompileKernel

if [ ! -z "$SecCD" ];then
ResetKernel
SwitchDevice "$SecCD"
CompileKernel
GoForStock
CompileKernel
fi

if [ "$KranulVer" = "44" ] && [ "$TypeBuild" == "RELEASE" ] && [ "$PureKernel" == "N" ];then

FFRelease
SwitchDevice "$SecCD"
FFRelease

fi