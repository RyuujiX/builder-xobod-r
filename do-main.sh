#! /bin/bash
KranulVer="44"
branch="r5/eas"
LVibration="1"
FreqOC="0"
WithSpec="Y"
CODENAME="X01BD"
FolderUp=""
PrivBuild="N"
PureKernel="N"
CUSKERNAME=""
CUSKERLINK=""
CUSBUILDDATE=""
CUSSPEC=""
TypeBuild="TEST"
BuilderKernel="zyc"

if [ "$KranulVer" = "419" ];then
CAFTAG="02700"
fi

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "gcc12" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "yuki" ] && [ "$BuilderKernel" != "sdclang" ] && [ "$BuilderKernel" != "aosp" ] && [ "$BuilderKernel" != "elas" ] && [ "$BuilderKernel" != "iris" ] && [ "$BuilderKernel" != "atom" ] && [ "$BuilderKernel" != "zyc" ];then
    exit;
fi

if [ "$KranulVer" = "44" ];then
KranulLink="android_kernel_asus_sdm660"
MESSAGEWORD="Ambition is the path to success. Persistence is the vehicle you arrive in."
if [ "$branch" = "r5/eas" ] || [ "$branch" == "r5/eas-s2" ] || [ "$branch" = "eas-test" ];then
TypeBuildTag="EAS"
AKbranch="4.4-eas"
	if [ "WithSpec" == "N" ];then
	spectrumFile=""
	elif [ ! -z "$CUSSPEC" ];then
	spectrumFile="$CUSSPEC"
	elif [ "$CODENAME" == "X00TD" ];then
	if [ "$branch" == "r5/eas-s2" ];then
	spectrumFile="eas-x00t-sixtwo.rc"
	elif [ "$FreqOC" == "1" ];then
	spectrumFile="eas-x00t-oc.rc"
	else
	spectrumFile="eas-x00t.rc"
	fi
	elif [ "$CODENAME" == "X01BD" ];then
	if [ "$branch" == "r5/eas-s2" ];then
	spectrumFile="eas-x01bd-sixtwo.rc"
	elif [ "$FreqOC" == "1" ];then
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
	elif [ ! -z "$CUSSPEC" ];then
	spectrumFile="$CUSSPEC"
	elif [ "$CODENAME" == "X00TD" ];then
	if [ "$branch" == "r5/hmp-s2" ];then
	spectrumFile="ryuu-x00t-sixtwo.rc"
	elif [ "$FreqOC" == "1" ];then
	spectrumFile="ryuu-x00t-oc.rc"
	else
	spectrumFile="ryuu-x00t.rc"
	fi
	elif [ "$CODENAME" == "X01BD" ];then
	if [ "$branch" == "r5/hmp-s2" ];then
	spectrumFile="ryuu-x01bd-sixtwo.rc"
	elif [ "$FreqOC" == "1" ];then
	spectrumFile="ryuu-x01bd-oc.rc"
	else
	spectrumFile="ryuu-x01bd.rc"
	fi
	fi
fi
elif [ "$KranulVer" = "419" ];then
KranulLink="android_kernel_asus_sdm660-4.19"
MESSAGEWORD="Become addicted to constant and never-ending self-improvement."
TypeBuildTag="EAS"
AKbranch="4.19"
	if [ "WithSpec" == "N" ];then
	spectrumFile=""
	elif [ ! -z "$CUSSPEC" ];then
	spectrumFile="$CUSSPEC"
	elif [ "$CODENAME" == "X00TD" ];then
	if [ "$branch" == "r1/s-s2" ];then
	spectrumFile="419-x00t-sixtwo.rc"
	elif [ "$FreqOC" == "1" ];then
	spectrumFile="419-x00t-oc.rc"
	else
	spectrumFile="419-x00t.rc"
	fi
	elif [ "$CODENAME" == "X01BD" ];then
	if [ "$branch" == "r1/s-s2" ];then
	spectrumFile="419-x01bd-sixtwo.rc"
	elif [ "$FreqOC" == "1" ];then
	spectrumFile="419-x01bd-oc.rc"
	else
	spectrumFile="419-x01bd.rc"
	fi
	fi
fi

. main.sh 'initial' 'full'

getInfo ">> Building kernel . . . . <<"

# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

if [ "$KranulVer" = "44" ] && [ "$PureKernel" == "N" ];then

SwitchOFI

CompileKernel
# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

fi