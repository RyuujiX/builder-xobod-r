#! /bin/bash
branch="r3/hmp"
LVibration="1"
FreqOC="1"
WithSpec="Y"
CODENAME="X01BD"
FolderUp=""
TypeBuild="RELEASE"
BuilderKernel="00000"

if [ "$BuilderKernel" != "proton" ] && [ "$BuilderKernel" != "dtc" ] && [ "$BuilderKernel" != "gcc" ] && [ "$BuilderKernel" != "storm" ] && [ "$BuilderKernel" != "strix" ] && [ "$BuilderKernel" != "yuki" ] && [ "$BuilderKernel" != "sdclang" ] && [ "$BuilderKernel" != "aosp" ] && [ "$BuilderKernel" != "elas" ] && [ "$BuilderKernel" != "iris" ];then
    exit;
fi

if [ "$branch" = "r3/eas" ] || [ "$branch" = "eas-test" ];then
TypeBuildTag="EAS"
TypeScript="EAS Advanced Configuration"
AKbranch="injectorx-eas"
	if [ "WithSpec" == "N" ];then
	spectrumFile=""
	elif [ "$CODENAME" == "X00TD" ];then
	if [ "$FreqOC" == "1" ];then
	spectrumFile="eas-x00t-oc.rc"
	else
	spectrumFile="eas-x00t.rc"
	fi
	else
	spectrumFile="eas.rc"
	fi
else
TypeBuildTag="HMP"
TypeScript="Spectrum"
AKbranch="injectorx"
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
. main.sh 'initial' 'full'

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

FixPieWifi

CompileKernel
# CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"