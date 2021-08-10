#! /bin/bash
KranulVer="44"
branch="r3/hmp"
LVibration="1"
FreqOC="1"
WithSpec="Y"
CODENAME="X01BD"
FolderUp=""
CUSKERNAME=""
CUSKERLINK=""
TypeBuild="RELEASE"
BuilderKernel="00000"

if [ "$KranulVer" = "419" ];then
CAFTAG="07900"
fi

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "gcc12" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "yuki" ] && [ "$BuilderKernel" != "sdclang" ] && [ "$BuilderKernel" != "aosp" ] && [ "$BuilderKernel" != "elas" ] && [ "$BuilderKernel" != "iris" ] && [ "$BuilderKernel" != "atom" ];then
    exit;
fi

if [ "$KranulVer" = "44" ];then
KranulLink="android_kernel_asus_sdm660"
if [ "$branch" = "r3/eas" ] || [ "$branch" = "eas-test" ];then
TypeBuildTag="EAS"
AKbranch="4.4-eas"
	spectrumFile=""
else
TypeBuildTag="HMP"
AKbranch="4.4-hmp"
	if [ "WithSpec" == "N" ];then
	spectrumFile=""
	elif [ "$CODENAME" == "X00TD" ];then
	if [ "$FreqOC" == "1" ];then
	spectrumFile="ryuu-x00t-oc.rc"
	else
	spectrumFile="ryuu-x00t.rc"
	fi
	else
	spectrumFile="ryuu.rc"
	fi
fi
elif [ "$KranulVer" = "419" ];then
KranulLink="android_kernel_asus_sdm660_4.19"
TypeBuildTag="EAS"
AKbranch="4.19"
spectrumFile=""
fi

. main.sh 'initial' 'full'

getInfo ">> Building kernel . . . . <<"

CompileKernel
# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

if [ "$KranulVer" = "44" ];then

SwitchOFI

CompileKernel
# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

FixPieWifi

CompileKernel
# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

fi