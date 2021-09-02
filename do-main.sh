#! /bin/bash
KranulVer="44"
branch="r4/eas"
LVibration="1"
FreqOC="0"
WithSpec="Y"
CODENAME="X01BD"
FolderUp=""
CUSKERNAME=""
CUSKERLINK=""
CUSBUILDDATE=""
TypeBuild="TEST"
BuilderKernel="gcc12"

if [ "$KranulVer" = "419" ];then
CAFTAG="07900"
fi

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "gcc12" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "yuki" ] && [ "$BuilderKernel" != "sdclang" ] && [ "$BuilderKernel" != "aosp" ] && [ "$BuilderKernel" != "elas" ] && [ "$BuilderKernel" != "iris" ] && [ "$BuilderKernel" != "atom" ];then
    exit;
fi

if [ "$KranulVer" = "44" ];then
KranulLink="android_kernel_asus_sdm660"
if [ "$branch" = "r4/eas" ] || [ "$branch" = "eas-test" ];then
TypeBuildTag="EAS"
AKbranch="4.4-eas"
	if [ "WithSpec" == "N" ];then
	spectrumFile=""
	elif [ "$CODENAME" == "X00TD" ];then
	if [ "$FreqOC" == "1" ];then
	spectrumFile="eas-x00t-oc.rc"
	else
	spectrumFile="eas-x00t.rc"
	fi
	elif [ "$CODENAME" == "X01BD" ];then
	if [ "$FreqOC" == "1" ];then
	spectrumFile="eas-x01bd-oc.rc"
	else
	spectrumFile="eas-x01bd.rc"
	fi
	fi
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
	elif [ "$CODENAME" == "X01BD" ];then
	if [ "$FreqOC" == "1" ];then
	spectrumFile="ryuu-x01bd-oc.rc"
	else
	spectrumFile="ryuu-x01bd.rc"
	fi
	fi
fi
elif [ "$KranulVer" = "419" ];then
KranulLink="android_kernel_asus_sdm660-4.19"
TypeBuildTag="EAS"
AKbranch="4.19"
spectrumFile=""
fi

. main.sh 'initial' 'full'

getInfo ">> Building kernel . . . . <<"

# CompileKernel
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

fi