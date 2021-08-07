#! /bin/bash

 # Script For Building Android Kernel
 #
 # Copyright (c) 2020 Zero-NEET-Alfa <danidaboy54@gmail.com>
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #      http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 #

# Function to show an informational message
# need to defined
# - branch
# - spectrumFile
# Then call CompileKernel and done

getInfo() {
    echo -e "\e[1;32m$*\e[0m"
}

getInfoErr() {
    echo -e "\e[1;41m$*\e[0m"
}

mainDir=$PWD

kernelDir=$mainDir/kernel

clangDir=$mainDir/clang

gcc64Dir=$mainDir/gcc64

gcc32Dir=$mainDir/gcc32

AnykernelDir=$mainDir/Anykernel3

SpectrumDir=$mainDir/Spectrum

GdriveDir=$mainDir/Gdrive-Uploader

useGdrive='N'

if [ ! -z "$CUSKERLINK" ];then
KERNLINK="$CUSKERLINK"
else
KERNLINK="https://$GIT_SECRET@github.com/$GIT_USERNAME/$KranulLink"
fi

if [ ! -z "$1" ] && [ "$1" == 'initial' ];then
	
    if [ ! -z "$2" ] && [ "$2" == 'full' ];then
        getInfo ">> cloning kernel full . . . <<"
        git clone $KERNLINK -b "$branch" $kernelDir
    else
        getInfo ">> cloning kernel . . . <<"
        git clone $KERNLINK -b "$branch" $kernelDir --depth=1 
    fi
    [ -z "$BuilderKernel" ] && BuilderKernel="storm"
    if [ "$BuilderKernel" == "proton" ];then
        getInfo ">> cloning Proton clang 13 . . . <<"
        git clone https://github.com/kdrag0n/proton-clang -b master $clangDir --depth=1
		gcc10="Y"
		Compiler="Proton Clang"
		TypeBuilder="Proton"
		TypePrint="Proton"
	fi
    if [ "$BuilderKernel" == "dtc" ];then
        getInfo ">> cloning DragonTC clang 10 . . . <<"
        git clone https://github.com/NusantaraDevs/DragonTC -b 10.0 $clangDir --depth=1
		gcc10="Y"
		Compiler="DragonTC Clang"
		TypeBuilder="DTC"
		TypePrint="DragonTC"
    fi
	if [ "$BuilderKernel" == "storm" ];then
        getInfo ">> cloning StormBreaker clang 11 . . . <<"
        git clone https://github.com/stormbreaker-project/stormbreaker-clang -b 11.x $clangDir --depth=1
		gcc10="Y"
        SimpleClang="Y"
		Compiler="StormBreaker Clang"
		TypeBuilder="Storm"
		TypePrint="StormBreaker"
	fi
	if [ "$BuilderKernel" == "strix" ];then
        getInfo ">> cloning STRIX clang . . . <<"
        git clone https://github.com/STRIX-Project/STRIX-clang -b main $clangDir --depth=1
		gcc10="Y"
		SimpleClang="Y"
		Compiler="STRIX Clang"
		TypeBuilder="STRIX"
		TypePrint="STRIX"
	fi
	if [ "$BuilderKernel" == "yuki" ];then
        getInfo ">> cloning Yuki clang . . . <<"
        git clone https://github.com/Klozz/Yuki-clang -b main $clangDir --depth=1
		gcc10="Y"
		SimpleClang="Y"
		Compiler="Yuki Clang"
		TypeBuilder="Yuki"
		TypePrint="Yuki"
	fi
	if [ "$BuilderKernel" == "sdclang" ];then
        getInfo ">> cloning Snapdragon-LLVM clang 10.0.9 . . . <<"
        git clone https://github.com/RyuujiX/snapdragon-llvm -b 10.0.9 $clangDir --depth=1
		gcc10="Y"
		SimpleClang="Y"
		Compiler="Snapdragon-LLVM Clang"
		TypeBuilder="SD"
		TypePrint="Snapdragon-LLVM"
	fi
	if [ "$BuilderKernel" == "aosp" ];then
        getInfo ">> cloning AOSP clang 12 . . . <<"
        git clone https://github.com/RyuujiX/android-kernel-tools -b tools $clangDir --depth=1
		gcc10="Y"
		SimpleClang="Y"
		Compiler="AOSP Clang"
		TypeBuilder="AOSP"
		TypePrint="AOSP"
		clangDir=$mainDir/clang/clang/host/linux-x86/clang-r416183b
		export LD=ld.lld
		export LD_LIBRARY_PATH="$clangDir/lib64:$LD_LIBRARY_PATH"
	fi
	if [ "$BuilderKernel" == "elas" ];then
        getInfo ">> cloning Elastics clang 13 . . . <<"
        git clone https://github.com/cbendot/Elastics-Toolchain -b main $clangDir --depth=1
		allFromClang="Y"
		Compiler="Elastics Clang"
		TypeBuilder="Elastics"
		TypePrint="Elastics"
    fi
    if [ "$BuilderKernel" == "iris" ];then
        getInfo ">> cloning iRISxe clang 13 . . . <<"
        git clone https://github.com/ramadhannangga/iRISxe-Clang -b 13.0 $clangDir --depth=1
		gcc10="Y"
		SimpleClang="Y"
		Compiler="iRISxe Clang"
		TypeBuilder="iRISxe"
		TypePrint="iRISxe"
    fi
	if [ "$BuilderKernel" == "atom" ];then
        getInfo ">> cloning Atom-X clang 14 . . . <<"
        git clone https://gitlab.com/ElectroPerf/atom-x-clang -b atom-14 $clangDir --depth=1
		allFromClang="Y"
		Compiler="Atom-X Clang"
		TypeBuilder="Atom-X"
		TypePrint="Atom-X"
    fi
    if [ "$BuilderKernel" == "gcc" ];then
        getInfo ">> cloning gcc64 . . . <<"
        git clone https://github.com/RyuujiX/aarch64-linux-android-4.9/ -b android-10.0.0_r47 $gcc64Dir --depth=1
        getInfo ">> cloning gcc32 . . . <<"
        git clone https://github.com/RyuujiX/arm-linux-androideabi-4.9/ -b android-10.0.0_r47 $gcc32Dir --depth=1
        for64=aarch64-linux-android
        for32=arm-linux-androideabi
		Compiler="GCC"
		TypeBuilder="GCC"
		TypePrint="GCC"
    elif [ "$BuilderKernel" == "gcc12" ] || [ "$gcc12" == "Y" ];then
        [[ "$(pwd)" != "${mainDir}" ]] && cd "${mainDir}"
		if [ -e "${gcc64Dir}/aarch64-linux-gnu" ] || [ -e "${gcc32Dir}/arm-linux-gnueabi" ];then
		rm -rf ${GCCaPath}/aarch64-linux-gnu ${GCCbPath}/arm-linux-gnueabi
		fi
		mkdir "${gcc64Dir}"
        mkdir "${gcc32Dir}"
		if [ ! -e "${mainDir}/aarch64-zyc-linux-gnu-12.x-gnu-20210725.tar.gz" ];then
		getInfo ">> Downloading aarch64-zyc-linux-gnu-12.x-gnu-20210725 (gcc64) . . . <<"
        wget -q https://toolchain.lynxcloud.workers.dev/0:/ZyC%20GCC/GCC%2012/aarch64-zyc-linux-gnu-12.x-gnu-20210725.tar.gz
        fi
		if [ ! -e "${mainDir}/arm-zyc-linux-gnueabi-12.x-gnu-20210725.tar.gz" ];then
        getInfo ">> Downloading arm-zyc-linux-gnueabi-12.x-gnu-20210725 (gcc32) . . . <<"
        wget -q https://toolchain.lynxcloud.workers.dev/0:/ZyC%20GCC/GCC%2012/arm-zyc-linux-gnueabi-12.x-gnu-20210725.tar.gz
        fi
		getInfo ">> Extracting aarch64-zyc-linux-gnu-12.x-gnu-20210725 (gcc64) . . . <<"
		tar -xf aarch64-zyc-linux-gnu-12.x-gnu-20210725.tar.gz -C $gcc64Dir
		getInfo ">> Extracting arm-zyc-linux-gnueabi-12.x-gnu-20210725 (gcc32) . . . <<"
		tar -xf arm-zyc-linux-gnueabi-12.x-gnu-20210725.tar.gz -C $gcc32Dir
		gcc64Dir="${gcc64Dir}/aarch64-zyc-linux-gnu"
		gcc32Dir="${gcc32Dir}/arm-zyc-linux-gnueabi"
		if [ "$BuilderKernel" == "gcc12" ];then
        for64=aarch64-zyc-linux-gnu
        for32=arm-zyc-linux-gnueabi
		Compiler="ZyC GCC"
		TypeBuilder="ZyC GCC"
		TypePrint="ZyC GCC"
		fi
    elif [ "$gcc10" == "Y" ];then
	getInfo ">> cloning gcc64 10.2.0 . . . <<"
        git clone https://github.com/RyuujiX/aarch64-linux-gnu -b stable-gcc $gcc64Dir --depth=1
        getInfo ">> cloning gcc32 10.2.0 . . . <<"
        git clone https://github.com/RyuujiX/arm-linux-gnueabi -b stable-gcc $gcc32Dir --depth=1
		if [ "$BuilderKernel" == "aosp" ];then
		for64=aarch64-linux-android
        for32=arm-linux-androideabi
		else
        for64=aarch64-linux-gnu
        for32=arm-linux-gnueabi
		fi
	else
        gcc64Dir=$clangDir
        gcc32Dir=$clangDir
        for64=aarch64-linux-gnu
        for32=arm-linux-gnueabi
    fi

    getInfo ">> cloning Anykernel . . . <<"
    git clone https://github.com/RyuujiX/AnyKernel3 -b $AKbranch $AnykernelDir --depth=1
    getInfo ">> cloning Spectrum . . . <<"
    git clone https://github.com/RyuujiX/spectrum -b master $SpectrumDir --depth=1
    if [ "$useGdrive" == "Y" ];then
        getInfo ">> cloning Gdrive Uploader . . . <<"
        git clone https://$GIT_SECRET@github.com/$GIT_USERNAME/gd-up -b master $GdriveDir --depth=1 
    fi
    
    SaveChatID="-275630226"
    ARCH="arm64"
    GetBD=$(date +"%m%d")
    GetCBD=$(date +"%Y-%m-%d")
    TotalCores=$(nproc --all)
    KernelFor='R'
    RefreshRate="60"
	CpuFreq=""
	if [ "$CODENAME" == "X00TD" ];then
	DEVICE="Asus Max Pro M1"
	DEFFCONFIG="X00TD_defconfig"
	elif [ "$CODENAME" == "X01BD" ];then
	DEVICE="Asus Max Pro M2"
	DEFFCONFIG="X01BD_defconfig"
	fi
	if [ "$KranulVer" = "44" ];then
    SetTag="LA.UM.9.2.r1"
    SetLastTag="SDMxx0.0"
	Driver="NFI"
	elif [ "$KranulVer" = "419" ];then
	SetTag="LA.UM.9.2.1.r1"
    SetLastTag="sdm660.0"
	DEFCONFIGPATH="asus/$DEFFCONFIG"
	fi

    export KBUILD_BUILD_USER="RyuujiX"
    export KBUILD_BUILD_HOST="DirumahAja"
    if [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ];then
	# cd $kernelDir
	# git revert 63f0ca0bd1751cbebb7e61b5a2a752395e864d9e --no-commit
	# git commit -s -m "Swtich to OPTIMIZE_FOR_SIZE"
	# cd $mainDir
        ClangType="$($gcc64Dir/bin/$for64-gcc --version | head -n 1)"
    else
        ClangType=$("$clangDir"/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
    fi
    KBUILD_COMPILER_STRING="$ClangType"
    if [ -e $gcc64Dir/bin/$for64-gcc ];then
        gcc64Type="$($gcc64Dir/bin/$for64-gcc --version | head -n 1)"
    else
        cd $gcc64Dir
        gcc64Type=$(git log --pretty=format:'%h: %s' -n1)
        cd $mainDir
    fi
    if [ -e $gcc32Dir/bin/$for32-gcc ];then
        gcc32Type="$($gcc32Dir/bin/$for32-gcc --version | head -n 1)"
    else
        cd $gcc32Dir
        gcc32Type=$(git log --pretty=format:'%h: %s' -n1)
        cd $mainDir
    fi
    cd $kernelDir
	HeadCommitMsg=$(git log --pretty=format:'%s' -n1)
	if [ "$KranulVer" = "44" ];then
	CUSDEFPATH="arch/$ARCH/configs/$DEFFCONFIG"
	if [ "$FreqOC" == "0" ];then
	if [ "$branch" == "r3/eas" ] || [ "$branch" == "eas-test" ];then
	git revert af528a60ea56d212848539c47e8d56fb7e1f6d62 --no-commit
	fi
	git revert 73e65b3e3574d2cf68caefbf0dc63a93ac6d336a --no-commit
	git commit -s -m "Back to stock freq"
	CpuFreq="-Stock"
	else
	CpuFreq="-OC"
	fi
	if [ "$LVibration" == "1" ];then
	git revert 82b39bb682ee8dbca38b7ca37e4f7c25303fd5ac --no-commit
	git commit -s -m "Enable LED Vibration"
	Vibrate="LV"
	else
	Vibrate="NLV"
	fi
	elif [ "$KranulVer" = "419" ];then
	CUSDEFPATH="arch/$ARCH/configs/$DEFCONFIGPATH"
	if [ "$FreqOC" == "0" ];then
	# git revert xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx --no-commit
	# git commit -s -m "Back to stock freq"
	CpuFreq="Stock"
	else
	CpuFreq="OC"
	fi
	fi
	KVer=$(make kernelversion)
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
	if [ ! -z "$CUSKERNAME" ];then
	sed -i "s/CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=-$CUSKERNAME/g" $CUSDEFPATH
	git commit -a -s -m "Change Kernel Name"
	fi
	if [ "$KranulVer" = "44" ];then
	KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    elif [ "$KranulVer" = "419" ];then
	KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFCONFIGPATH" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
	fi
    cd $mainDir
fi

tg_send_info(){
    if [ ! -z "$2" ];then
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$2" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    else
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="-1001407005109" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    fi
}

tg_send_sticker() {
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendSticker" \
        -d sticker="$1" \
        -d chat_id="-1001407005109"
}

tg_send_files(){
    KernelFiles="$(pwd)/$RealZipName"
	MD5CHECK=$(md5sum "$KernelFiles" | cut -d' ' -f1)
	SID="CAACAgUAAxkBAAIb0mBy2DMFsj1kyc5H-sxMRU4uGq4XAAJxAwACckHJVoQTT9R9yDxQHgQ"
    MSG="✅ <b>Kernel Compiled Succesfully</b> 
- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s) </code> 

<b>MD5 Checksum</b>
- <code>$MD5CHECK</code>

<b>Zip Name</b> 
- <code>$ZipName</code>"
	
        curl --progress-bar -F document=@"$KernelFiles" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
        -F chat_id="$SaveChatID"  \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="$MSG"
		
			tg_send_info "$MSG"
			tg_send_sticker "$SID"
		
	if [ "$useGdrive" == "Y" ];then
        currentFolder="$(pwd)"
        cd $GdriveDir
        chmod +x run.sh
        . run.sh "$KernelFiles" "x01bd" "$(date +"%m-%d-%Y")" "$FolderUp"
        cd $currentFolder
		if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG"
        fi
    fi
		
    # remove files after build done
    rm -rf $KernelFiles
}

CompileKernel(){
    cd $kernelDir
    export KBUILD_COMPILER_STRING
    if [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ];then
        MAKE+=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32-
        )
    else
        if [ "$allFromClang" == "Y" ];then
            MAKE+=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$clangDir/bin:${PATH} \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                AR=llvm-ar \
                NM=llvm-nm \
                OBJCOPY=llvm-objcopy \
                OBJDUMP=llvm-objdump \
                STRIP=llvm-strip \
                CLANG_TRIPLE=aarch64-linux-gnu-
            )
        else
            if [ "$SimpleClang" == "Y" ];then
                MAKE+=(
                    ARCH=$ARCH \
                    SUBARCH=$ARCH \
                    PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                    CC=clang \
                    CROSS_COMPILE=$for64- \
                    CROSS_COMPILE_ARM32=$for32- \
                    AR=llvm-ar \
                    NM=llvm-nm \
                    OBJCOPY=llvm-objcopy \
                    OBJDUMP=llvm-objdump \
                    STRIP=llvm-strip \
                    CLANG_TRIPLE=aarch64-linux-gnu-
                )
			else
				MAKE+=(
						ARCH=$ARCH \
						SUBARCH=$ARCH \
						PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
						CC=clang \
						CROSS_COMPILE=$for64- \
						CROSS_COMPILE_ARM32=$for32- \
						AR=llvm-ar \
						AS=llvm-as \
						NM=llvm-nm \
						STRIP=llvm-strip \
						OBJCOPY=llvm-objcopy \
						OBJDUMP=llvm-objdump \
						OBJSIZE=llvm-size \
						READELF=llvm-readelf \
						HOSTCC=clang \
						HOSTCXX=clang++ \
						HOSTAR=llvm-ar \
						CLANG_TRIPLE=aarch64-linux-gnu-
					)
			fi
		fi
    fi
    # rm -rf out # always remove out directory :V
    BUILD_START=$(date +"%s")
		if [ ! -z "${CIRCLE_BRANCH}" ];then
            BuildNumber="${CIRCLE_BUILD_NUM}"
            ProgLink="${CIRCLE_BUILD_URL}"
        elif [ ! -z "${DRONE_BRANCH}" ];then
            BuildNumber="${DRONE_BUILD_NUMBER}"
            ProgLink="https://cloud.drone.io/${DRONE_REPO}/${DRONE_BUILD_NUMBER}/1/2"
        fi
		if [ "$KranulVer" = "44" ];then
		VibDrivTag="#$Vibrate #$Driver"
		fi
        if [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ];then
            MSG="<b>🔨 Compiling Kernel....</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Compile Date: $GetCBD </b>%0A<b>Branch: $branch</b>%0A<b>Kernel Name: $KName</b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Compile Link Progress:</b><a href='$ProgLink'> Check Here </a>%0A<b>Compiler Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild  $VibDrivTag"
        else
            MSG="<b>🔨 Compiling Kernel....</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Compile Date: $GetCBD </b>%0A<b>Branch: $branch</b>%0A<b>Kernel Name: $KName</b>%0A<b>Kernel Version: $KVer</b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Compile Link Progress:</b><a href='$ProgLink'> Check Here </a>%0A<b>Compiler Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $ClangType </code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A #$TypeBuildTag  #$TypeBuild  $VibDrivTag"
        fi
        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG" 
        fi
    git reset --hard $HeadCommitId
    if [ ! -z "$1" ] && [ $1 != "60" ];then
        update_file "qcom,mdss-dsi-panel-framerate = " "qcom,mdss-dsi-panel-framerate = <$1>;" "./arch/arm/boot/dts/qcom/X01BD/dsi-panel-hx83112a-1080p-video-tm.dtsi" && \
        update_file "qcom,mdss-dsi-panel-framerate = " "qcom,mdss-dsi-panel-framerate = <$1>;" "./arch/arm/boot/dts/qcom/X01BD/dsi-panel-nt36672ah-1080p-video-kd.dtsi" && \
		update_file "qcom,mdss-dsi-panel-framerate = " "qcom,mdss-dsi-panel-framerate = <$1>;" "./arch/arm/boot/dts/qcom/X00TD/dsi-panel-nt36672-1080p-video-txd.dtsi" && \
		update_file "qcom,mdss-dsi-panel-framerate = " "qcom,mdss-dsi-panel-framerate = <$1>;" "./arch/arm/boot/dts/qcom/X00TD/dsi-panel-nt36672-1080p-video.dtsi" && \
		update_file "qcom,mdss-dsi-panel-framerate = " "qcom,mdss-dsi-panel-framerate = <$1>;" "./arch/arm/boot/dts/qcom/X00TD/dsi-panel-td4310-1080p-video-txd.dtsi"
        RefreshRate="$1"
    fi
    LastHeadCommitId=$(git log --pretty=format:'%h' -n1)
	if [ ! -z "$CAFTAG" ];then
	TAGKENEL="$SetTag-$CAFTAG-$SetLastTag"
	else
    TAGKENEL="$(git log | grep "${SetTag}" | head -n 1 | awk -F '\\'${SetLastTag}'' '{print $1"'${SetLastTag}'"}' | awk -F '\\'${SetTag}'' '{print "'${SetTag}'"$2}')"
    fi
	if [ ! -z "$TAGKENEL" ];then
	if [ "$KranulVer" = "44" ];then
        export KBUILD_BUILD_HOST="StaySafe-$Driver-$Vibrate-$TAGKENEL"
	elif [ "$KranulVer" = "419" ];then
		export KBUILD_BUILD_HOST="StaySafe-$TAGKENEL"
    fi
	fi
	if [ "$KranulVer" = "44" ];then
    make -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
	elif [ "$KranulVer" = "419" ];then
	make -j${TotalCores}  O=out "$DEFCONFIGPATH" \
		ARCH=$ARCH \
		PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
		CROSS_COMPILE=$for64- \
        CROSS_COMPILE_ARM32=$for32- \
		CC=clang \
		LLVM=1
	fi
	
    if [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ];then
        make -j${TotalCores}  O=out \
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=$for64- \
            CROSS_COMPILE_ARM32=$for32-
	else
        if [ "$allFromClang" == "Y" ];then
            make -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$clangDir/bin:${PATH} \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                AR=llvm-ar \
                NM=llvm-nm \
                OBJCOPY=llvm-objcopy \
                OBJDUMP=llvm-objdump \
                STRIP=llvm-strip \
                CLANG_TRIPLE=aarch64-linux-gnu-
        else
            if [ "$SimpleClang" == "Y" ];then
                make -j${TotalCores}  O=out \
                    ARCH=$ARCH \
                    SUBARCH=$ARCH \
                    PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                    CC=clang \
                    CROSS_COMPILE=$for64- \
                    CROSS_COMPILE_ARM32=$for32- \
                    AR=llvm-ar \
                    NM=llvm-nm \
                    OBJCOPY=llvm-objcopy \
                    OBJDUMP=llvm-objdump \
                    STRIP=llvm-strip \
                    CLANG_TRIPLE=aarch64-linux-gnu-
			else
				make -j${TotalCores}  O=out \
					ARCH=$ARCH \
					SUBARCH=$ARCH \
					PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
					CC=clang \
					CROSS_COMPILE=$for64- \
					CROSS_COMPILE_ARM32=$for32- \
					AR=llvm-ar \
					AS=llvm-as \
					NM=llvm-nm \
					STRIP=llvm-strip \
					OBJCOPY=llvm-objcopy \
					OBJDUMP=llvm-objdump \
					OBJSIZE=llvm-size \
					READELF=llvm-readelf \
					HOSTCC=clang \
					HOSTCXX=clang++ \
					HOSTAR=llvm-ar \
					CLANG_TRIPLE=aarch64-linux-gnu-
			fi
		fi
    fi
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
	if [[ ! -e $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb ]];then
		SID="CAACAgUAAxkBAAIb12By2GpymhVy7G9g1Y5D2FcgvYr7AALZAQAC4dzJVslZcFisbk9nHgQ"
        MSG="<b>❌ Compile failed</b>%0AKernel Name : <b>${KName}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
		
        tg_send_info "$MSG" 
		tg_send_sticker "$SID"
        exit -1
	fi
        cp -af $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb $AnykernelDir
		
	if [ "$KranulVer" = "44" ];then
		if [ "$CODENAME" == "X00TD" ];then
        VCFval="$Vibrate$CpuFreq"
        else
        VCFval="$Vibrate"
        fi
        if [ "$KernelFor" == "P" ];then
		FilenameVC=""
		else
		FilenameVC="[$VCFval]"
		fi
		 if [ $TypeBuild = "STABLE" ] || [ $TypeBuild = "RELEASE" ];then
            ZipName="$FilenameVC$KName-$Driver-$KVer-$CODENAME.zip"
         else
            ZipName="$FilenameVC$KName-$Driver-$TypeBuild-$KVer-$CODENAME.zip"
         fi
	elif [ "$KranulVer" = "419" ];then
		if [ "$CODENAME" == "X00TD" ];then
		FilenameVC="[$CpuFreq]"
		else
		FilenameVC=""
		fi
		 if [ $TypeBuild = "STABLE" ] || [ $TypeBuild = "RELEASE" ];then
            ZipName="$FilenameVC$KName-$KVer-$CODENAME.zip"
         else
            ZipName="$FilenameVC$KName-$TypeBuild-$KVer-$CODENAME.zip"
         fi
	fi
        # RealZipName="[$GetBD]$KVer-$HeadCommitId.zip"
        RealZipName="$ZipName"
        if [ ! -z "$2" ];then
            MakeZip "$2"
        else
            MakeZip
        fi
}


MakeZip(){
    cd $AnykernelDir
	git reset --hard origin/$AKbranch
    if [ ! -z "$spectrumFile" ];then
        cp -af $SpectrumDir/$spectrumFile spectrum/init.spectrum.rc && sed -i "s/persist.spectrum.kernel.*/persist.spectrum.kernel $KName/g" spectrum/init.spectrum.rc
    fi
    cp -af anykernel-real.sh anykernel.sh
	if [ "$TypeBuild" = "RELEASE" ];then
	cp -af $kernelDir/changelog META-INF/com/google/android/aroma/changelog.txt
	fi
	if [ "$KranulVer" = "419" ];then
	AKNAME="KnightWalker-Akira"
	else
	AKNAME="SkyWalker-Yuuki"
	fi
	VibCpu="$VCFval-"
	sed -i "s/kernel.string=.*/kernel.string=$AKNAME/g" anykernel.sh
	if [ "$KranulVer" = "44" ];then
	sed -i "s/kernel.for=.*/kernel.for=$VibCpu$Driver/g" anykernel.sh
	fi
	sed -i "s/kernel.compiler=.*/kernel.compiler=$TypePrint/g" anykernel.sh
	sed -i "s/kernel.made=.*/kernel.made=Ryuuji @ItsRyuujiX/g" anykernel.sh
	sed -i "s/kernel.version=.*/kernel.version=$KVer/g" anykernel.sh
	sed -i "s/message.word=.*/message.word=To be a good loser is to learn how to win./g" anykernel.sh
	sed -i "s/build.date=.*/build.date=$GetCBD/g" anykernel.sh
	sed -i "s/build.type=.*/build.type=$TypeBuild/g" anykernel.sh
	sed -i "s/kernel.type=.*/kernel.type=$TypeBuildTag/g" anykernel.sh
	sed -i "s/script.type=.*/script.type=$TypeScript/g" anykernel.sh
	if [ "$KernelFor" == "P" ];then
	sed -i "s/supported.versions=.*/supported.versions=9/g" anykernel.sh
	elif [ "$Vibrate" == "LV" ] || [ "$KranulVer" = "419" ];then
	sed -i "s/supported.versions=.*/supported.versions=11-12/g" anykernel.sh
	elif [ "$Vibrate" == "NLV" ];then
	sed -i "s/supported.versions=.*/supported.versions=9-12/g" anykernel.sh
	fi
	if [ "$CODENAME" == "X00TD" ];then
	sed -i "s/device.name1=.*/device.name1=X00TD/g" anykernel.sh
	sed -i "s/device.name2=.*/device.name2=X00T/g" anykernel.sh
	sed -i "s/device.name3=.*/device.name3=Zenfone Max Pro M1 (X00TD)/g" anykernel.sh
	sed -i "s/device.name4=.*/device.name4=ASUS_X00TD/g" anykernel.sh
	sed -i "s/device.name5=.*/device.name5=ASUS_X00T/g" anykernel.sh
	sed -i "s/X00TD=.*/X00TD=1/g" anykernel.sh
	fi
	cd $AnykernelDir/META-INF/com/google/android
	sed -i "s/KNAME/$AKNAME/g" aroma-config
	sed -i "s/KVER/$KVer/g" aroma-config
	sed -i "s/KAUTHOR/Ryuuji @ItsRyuujiX/g" aroma-config
	sed -i "s/KDEVICE/$DEVICE - $CODENAME/g" aroma-config
	sed -i "s/KBDATE/$GetCBD/g" aroma-config
	if [ "$KranulVer" = "44" ];then
	sed -i "s/KVARIANT/$VibCpu$Driver/g" aroma-config
	fi
	cd $AnykernelDir

    zip -r9 "$RealZipName" * -x .git README.md anykernel-real.sh .gitignore *.zip
    if [ ! -z "$1" ];then
        tg_send_files "$1"
    else
        tg_send_files
    fi

}

SwitchOFI()
{
	cd $kernelDir
    git reset --hard origin/$branch
	# if [ "$branch" == "injectorx-eas" ];then
	# git revert e31cfbb028ff2d92af87e4f327bfca25da68aba4 --no-commit
	# elif [ "$branch" == "injectorx" ];then
	# git revert 226908e2c6ba8af243cd6ee4bc6d694043fc90e7 --no-commit
	# fi
	# git commit -s -m "Bringup OFI Edition"
    rm -rf drivers/staging/qcacld-3.0 drivers/staging/fw-api drivers/staging/qca-wifi-host-cmn
    git add .
    git commit -s -m "Remove R WLAN DRIVERS"
    git revert a56e6c3e5bf1cb792c84daf5c902600c826f790c --no-commit
	git commit -s -m "Switch to OFI"
	if [ "$FreqOC" == "0" ];then
	if [ "$branch" == "r3/eas" ] || [ "$branch" == "eas-test" ];then
	git revert af528a60ea56d212848539c47e8d56fb7e1f6d62 --no-commit
	fi
	git revert 73e65b3e3574d2cf68caefbf0dc63a93ac6d336a --no-commit
	git commit -s -m "Back to stock freq"
	CpuFreq="-Stock"
	else
	CpuFreq="-OC"
	fi
	if [ "$LVibration" == "1" ];then
	git revert 82b39bb682ee8dbca38b7ca37e4f7c25303fd5ac --no-commit
	git commit -s -m "Enable LED Vibration"
	Vibrate="LV"
	else
	Vibrate="NLV"
	fi
    KVer=$(make kernelversion)
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
    KernelFor='R'
    RefreshRate="60"
	Driver="OFI"
	if [ "$CODENAME" == "X00TD" ];then
	DEVICE="Asus Max Pro M1"
	DEFFCONFIG="X00TD_defconfig"
	elif [ "$CODENAME" == "X01BD" ];then
	DEVICE="Asus Max Pro M2"
	DEFFCONFIG="X01BD_defconfig"
	fi
	
	KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    rm -rf out
    cd $mainDir
}

FixPieWifi()
{
	cd $kernelDir
    git reset --hard origin/$branch
    if [ "$FreqOC" == "0" ];then
	if [ "$branch" == "r3/eas" ] || [ "$branch" == "eas-test" ];then
	git revert af528a60ea56d212848539c47e8d56fb7e1f6d62 --no-commit
	fi
	git revert 73e65b3e3574d2cf68caefbf0dc63a93ac6d336a --no-commit
	git commit -s -m "Back to stock freq"
	CpuFreq="-Stock"
	else
	CpuFreq="-OC"
	fi
	rm -rf drivers/staging/qcacld-3.0 drivers/staging/fw-api drivers/staging/qca-wifi-host-cmn
    git add .
    git commit -s -m "Remove R WLAN DRIVERS"
    git revert a56e6c3e5bf1cb792c84daf5c902600c826f790c --no-commit
	git commit -s -m "Switch to OFI"
	git revert be578e2def2d7a67d6643335d016008f7bee8da8 --no-commit
	git revert 5c27bb6d8547112a8b815742c5dbcaae520b4497 --no-commit
	git commit -s -m "Building for Android Pie"
    KVer=$(make kernelversion)
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
    KernelFor='P'
    RefreshRate="60"
	Driver="Pie"
	Vibrate=""
	if [ "$CODENAME" == "X00TD" ];then
	DEVICE="Asus Max Pro M1"
	DEFFCONFIG="X00TD_defconfig"
	elif [ "$CODENAME" == "X01BD" ];then
	DEVICE="Asus Max Pro M2"
	DEFFCONFIG="X01BD_defconfig"
	fi
	KName=$(cat "$(pwd)/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    rm -rf out
    cd $mainDir
}

update_file() {
    if [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ];then
        GetValue="$(cat $3 | grep "$1")"
        GetPath=${3/"."/""}
        ValOri="$(echo "$GetValue" | awk -F '\\=' '{print $2}')"
        UpdateTo="$(echo "$2" | awk -F '\\=' '{print $2}')"
        [ "$ValOri" != "$UpdateTo" ] && \
        sed -i "s/$1.*/$2/g" "$3"
        [ ! -z "$(git status | grep "modified" )" ] && \
        git add "$3" && \
        git commit -s -m "$GetPath: '$GetValue' update to '$2'"
    fi
}

getInfo 'include main.sh success'