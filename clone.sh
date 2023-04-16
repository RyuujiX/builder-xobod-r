#! /bin/bash

# Kernel
getInfo ">> Cloning Kernel Source . . . <<"
git clone --recursive $KERNLINK -b "$branch" $kernelDir

# LA.UM.9.2.r1-XXXXX-SDMxx0.0 (NFI) WiFi Driver
if [ "$KranulVer" = "44" ];then
getInfo ">> Cloning NFI WiFi Driver . . . <<"
git clone https://github.com/RyuujiX/NFI_SkyWalker -b NFI $NFIDir
fi

# Clang
if [ "$BuilderKernel" == "proton" ];then
    getInfo ">> Cloning Proton clang 13 . . . <<"
    git clone https://github.com/kdrag0n/proton-clang -b master $clangDir --depth=1
	gcc10="Y"
	Compiler="Proton Clang"
	TypeBuilder="Proton"
	TypePrint="Proton"
elif [ "$BuilderKernel" == "dtc" ];then
    getInfo ">> Cloning DragonTC clang 10 . . . <<"
    git clone https://github.com/NusantaraDevs/DragonTC -b 10.0 $clangDir --depth=1
	gcc10="Y"
	Compiler="DragonTC Clang"
	TypeBuilder="DTC"
	TypePrint="DragonTC"
elif [ "$BuilderKernel" == "storm" ];then
    getInfo ">> Cloning StormBreaker clang 11 . . . <<"
    git clone https://github.com/stormbreaker-project/stormbreaker-clang -b 11.x $clangDir --depth=1
	gcc10="Y"
    SimpleClang="Y"
	Compiler="StormBreaker Clang"
	TypeBuilder="Storm"
	TypePrint="StormBreaker"
elif [ "$BuilderKernel" == "strix" ];then
    getInfo ">> Cloning STRIX clang . . . <<"
    git clone https://github.com/STRIX-Project/STRIX-clang -b main $clangDir --depth=1
	gcc10="Y"
	SimpleClang="Y"
	Compiler="STRIX Clang"
	TypeBuilder="STRIX"
	TypePrint="STRIX"
elif [ "$BuilderKernel" == "sdclang" ];then
    getInfo ">> Cloning Snapdragon Clang 14 . . . <<"
    git clone https://github.com/RyuujiX/SDClang -b 14 $clangDir --depth=1
	gcc="Y"
	if [ "$KranulVer" = "419" ];then
	LLVMON=" LLVM"
	CUSLLDVER=", LLD 14.1.5"
	fi
	Compiler="Snapdragon Clang"
	TypeBuilder="Snapdragon$LLVMON"
	TypePrint="Snapdragon$LLVMON"
	CUSCLANGVER="Snapdragon$LLVMON clang version 14.1.5"
elif [ "$BuilderKernel" == "atom" ];then
    getInfo ">> Cloning Atom-X clang 14 . . . <<"
    git clone https://gitlab.com/ElectroPerf/atom-x-clang -b atom-14 $clangDir --depth=1
	allFromClang="Y"
	Compiler="Atom-X Clang"
	TypeBuilder="Atom-X"
	TypePrint="Atom-X"
	export LD=ld.lld
    export LD_LIBRARY_PATH=$clangDir/lib
elif [ "$BuilderKernel" == "zyc" ];then
	mkdir "${clangDir}"
	rm -rf $clangDir/*
	if [ ! -e "${mainDir}/ZyC-Clang-14.tar.gz" ];then
	getInfo ">> Downloading ZyC clang 14 . . . <<"
	wget -q  $(curl https://raw.githubusercontent.com/ZyCromerZ/Clang/main/Clang-14-link.txt 2>/dev/null) -O "ZyC-Clang-14.tar.gz"
	fi
	getInfo ">> Extracting ZyC clang 14 . . . <<"
	tar -xf ZyC-Clang-14.tar.gz -C $clangDir
	allFromClang="Y"
	Compiler="ZyC Clang"
	TypeBuilder="ZyC"
	TypePrint="ZyC"
	export LD=ld.lld
	export LD_LIBRARY_PATH=$clangDir/lib
elif [ "$BuilderKernel" == "neutron" ];then
    getInfo ">> Cloning Neutron clang 16 . . . <<"
    git clone https://gitlab.com/RyuujiX/neutron-clang -b Neutron-16 $clangDir --depth=1
	Compiler="Neutron Clang"
	TypeBuilder="Neutron"
	TypePrint="Neutron"
	export LD=ld.lld
    export LD_LIBRARY_PATH=$clangDir/lib
elif [ "$BuilderKernel" == "trb" ];then
    getInfo ">> Cloning TRB clang 17 . . . <<"
    git clone https://gitlab.com/varunhardgamer/trb_clang -b 17 $clangDir --depth=1
	Compiler="TRB Clang"
	TypeBuilder="TheRagingBeast"
	TypePrint="TheRagingBeast"
	export LD=ld.lld
    export LD_LIBRARY_PATH=$clangDir/lib
fi

# GCC	
if [ "$BuilderKernel" == "gcc" ] || [ "$gcc" == "Y" ];then
	getInfo ">> Cloning gcc64 . . . <<"
	git clone https://github.com/RyuujiX/aarch64-linux-android-4.9/ -b android-12.0.0_r15 $gcc64Dir --depth=1
	getInfo ">> Cloning gcc32 . . . <<"
	git clone https://github.com/RyuujiX/arm-linux-androideabi-4.9/ -b android-12.0.0_r15 $gcc32Dir --depth=1
	for64=aarch64-linux-android
	for32=arm-linux-androideabi
	if [ "$BuilderKernel" == "gcc" ];then
	Compiler="GCC"
	TypeBuilder="GCC"
	TypePrint="GCC"
	elif [ ! -z "CUSCLANGVER" ];then
	CUSCLANGVER="$CUSCLANGVER X GCC 4.9"
	fi
elif [ "$BuilderKernel" == "gcc12" ] || [ "$gcc12" == "Y" ];then
	[[ "$(pwd)" != "${mainDir}" ]] && cd "${mainDir}"
	if [ -e "${gcc64Dir}/aarch64-linux-gnu" ] || [ -e "${gcc32Dir}/arm-linux-gnueabi" ];then
		rm -rf ${gcc64Dir}/aarch64-linux-gnu ${gcc32Dir}/arm-linux-gnueabi
	fi
	mkdir "${gcc64Dir}"
	mkdir "${gcc32Dir}"
	if [ ! -e "${mainDir}/aarch64-zyc-linux-gnu-12.x-gnu-20210808.tar.gz" ];then
		getInfo ">> Downloading aarch64-zyc-linux-gnu-12.x-gnu-20210808 (gcc64) . . . <<"
		wget -q https://toolchain.lynxcloud.workers.dev/0:/ZyC%20GCC/GCC%2012/aarch64-zyc-linux-gnu-12.x-gnu-20210808.tar.gz
	fi
	if [ ! -e "${mainDir}/arm-zyc-linux-gnueabi-12.x-gnu-20210808.tar.gz" ];then
		getInfo ">> Downloading arm-zyc-linux-gnueabi-12.x-gnu-20210808 (gcc32) . . . <<"
		wget -q https://toolchain.lynxcloud.workers.dev/0:/ZyC%20GCC/GCC%2012/arm-zyc-linux-gnueabi-12.x-gnu-20210808.tar.gz
	fi
	getInfo ">> Extracting aarch64-zyc-linux-gnu-12.x-gnu-20210808 (gcc64) . . . <<"
	tar -xf aarch64-zyc-linux-gnu-12.x-gnu-20210808.tar.gz -C $gcc64Dir
	getInfo ">> Extracting arm-zyc-linux-gnueabi-12.x-gnu-20210808 (gcc32) . . . <<"
	tar -xf arm-zyc-linux-gnueabi-12.x-gnu-20210808.tar.gz -C $gcc32Dir
	gcc64Dir="${gcc64Dir}/aarch64-zyc-linux-gnu"
	gcc32Dir="${gcc32Dir}/arm-zyc-linux-gnueabi"
	if [ "$BuilderKernel" == "gcc12" ];then
		for64=aarch64-zyc-linux-gnu
		for32=arm-zyc-linux-gnueabi
		Compiler="ZyC GCC"
		TypeBuilder="ZyC GCC"
		TypePrint="ZyC GCC"
	elif [ ! -z "CUSCLANGVER" ];then
	CUSCLANGVER="$CUSCLANGVER X ZyC GCC 12"
	fi
elif [ "$gcc10" == "Y" ];then
	getInfo ">> cloning gcc64 10.2.0 . . . <<"
	git clone https://github.com/RyuujiX/aarch64-linux-gnu -b stable-gcc $gcc64Dir --depth=1
	getInfo ">> cloning gcc32 10.2.0 . . . <<"
	git clone https://github.com/RyuujiX/arm-linux-gnueabi -b stable-gcc $gcc32Dir --depth=1
	for64=aarch64-linux-gnu
	for32=arm-linux-gnueabi
	if [ ! -z "CUSCLANGVER" ];then
		CUSCLANGVER="$CUSCLANGVER X GCC 10"
	fi
else
	gcc64Dir=$clangDir
	gcc32Dir=$clangDir
	for64=aarch64-linux-gnu
	for32=arm-linux-gnueabi
fi

# Misc
getInfo ">> cloning Anykernel . . . <<"
git clone https://github.com/RyuujiX/AnyKernel3 -b $AKbranch $AnykernelDir --depth=1
getInfo ">> cloning Spectrum . . . <<"
git clone https://github.com/RyuujiX/spectrum -b master $SpectrumDir --depth=1