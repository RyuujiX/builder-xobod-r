#! /bin/bash

getInfo() {
    echo -e "\e[1;32m$*\e[0m"
}
getInfoErr() {
    echo -e "\e[1;41m$*\e[0m"
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

## Commands
# Send Info
tg_send_info(){
    if [ ! -z "$2" ];then
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$2" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    else
        curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$InfoChatID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="$1"
    fi
}

# Send Sticker
tg_send_sticker() {
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendSticker" \
        -d sticker="$1" \
        -d chat_id="$InfoChatID"
}

# Send Kernel Files
tg_send_files(){
    KernelFiles="$(pwd)/$ZipName"
	MD5CHECK=$(md5sum "$KernelFiles" | cut -d' ' -f1)
	SID="CAACAgUAAxkBAAIb0mBy2DMFsj1kyc5H-sxMRU4uGq4XAAJxAwACckHJVoQTT9R9yDxQHgQ"
    MSG="✅ <b>Kernel Compiled Succesfully</b> 
- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s) </code>

<b>Compiled at</b>
- <code>$(date)</code>

<b>MD5 Checksum</b>
- <code>$MD5CHECK</code>

<b>Zip Name</b> 
- <code>$ZipName</code>"
	
        getInfo ">> Sending "$ZipName" . . . . <<"
		curl --progress-bar -F document=@"$KernelFiles" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
        -F chat_id="$FileChatID"  \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="$MSG"
		
			tg_send_info "$MSG"
			tg_send_sticker "$SID"
			getInfo ">> File Sent ! <<"
		
    # remove files after send done
    rm -rf $KernelFiles
}

# Switch Device
SwitchDevice(){
	getInfo ">> Switching Device . . . . <<"
	if [ "$1" == "M1" ];then
		CODENAME="X00TD"
		DEVICE="Asus Max Pro M1"
		DEFCONFIG="X00TD_defconfig"
	elif [ "$1" == "M2" ];then
		CODENAME="X01BD"
		DEVICE="Asus Max Pro M2"
		DEFCONFIG="X01BD_defconfig"
	fi
	if [ "$KranulVer" = "419" ];then
		DEFCONFIG="asus/$DEFCONFIG"
	fi
	if [ ! -z "$CKName" ] && [ "$1" != "DCKN" ];then
		ChangeKName "$CKName"
	fi
	getInfo ">> Device Switched to "$DEVICE-$CODENAME" ! <<"
}

# Get Kernel Info
GetKernelInfo(){
	KName=$(cat "$(pwd)/$DEFCONFIGPATH/$DEFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
	KVer=$(make kernelversion)
}
	
# Change Kernel Name
ChangeKName(){
	[[ "$(pwd)" != "${kernelDir}" ]] && cd "${kernelDir}"
	 sed -i "s/CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=\"-$1\"/g" $DEFCONFIGPATH/$DEFCONFIG
	 git add .
	GetKernelInfo
	CKName="$1"
	getInfo ">> Kernel Name Changed to "$KName" ! <<"
}

# Reset Kernel Source
ResetBranch(){
	getInfo ">> Resetting Kernel . . . . <<"
	[[ "$(pwd)" != "${kernelDir}" ]] && cd "${kernelDir}"
    git reset --hard origin/$branch
	if [ ! -z "$CKName" ] && [ "$1" != "DCKN" ];then
		ChangeKName "$CKName"
	fi
	if [ "$PureKernel" == "N" ];then
	if [ "$SixTwo" == "Y" ];then
		CpuFreq="SiX2"
	else
		CpuFreq="OC"
	fi
	Driver="OFI"
	fi
	cd $mainDir
	getInfo ">> Kernel Source Has Been Reset ! <<"
}

# Revert Back to Stock CPU & GPU Freq
StockFreq(){
	[[ "$(pwd)" != "${kernelDir}" ]] && cd "${kernelDir}"
	if [ "$KranulVer" = "419" ];then
		git revert 18848d6a864bbc70fcd46001a01127c3cbd70ded -n
	elif [ "$KranulVer" = "44" ];then
		git revert b4c53eccaf2789943433865c194292d63b66a401 -n
	fi
	CpuFreq="Stock"
	cd $mainDir
	getInfo ">> Reverted to Stock Freq ! <<"
}

# Switch to New Wi-Fi Driver
SwitchNFI(){
	[[ "$(pwd)" != "${kernelDir}" ]] && cd "${kernelDir}"
    rm -rf drivers/staging/qcacld-3.0 drivers/staging/fw-api drivers/staging/qca-wifi-host-cmn
    cp $NFIDir/drivers/staging/qcacld-3.0 drivers/staging/qcacld-3.0 -rf
	cp $NFIDir/drivers/staging/fw-api drivers/staging/fw-api -rf
	cp $NFIDir/drivers/staging/qca-wifi-host-cmn drivers/staging/qca-wifi-host-cmn -rf
	git add .
    Driver="NFI"
    cd $mainDir
	getInfo ">> Switched to New Wi-Fi Driver ! <<"
}

# Fix Wi-Fi for Custom ROM Pie X01BD
FixPieWifi(){
	[[ "$(pwd)" != "${kernelDir}" ]] && cd "${kernelDir}"
	git revert be578e2def2d7a67d6643335d016008f7bee8da8 -n
	git revert 5c27bb6d8547112a8b815742c5dbcaae520b4497 -n
	Driver="Pie"
    cd $mainDir
	getInfo ">> Wi-Fi for Custom ROM Pie ($CODENAME) Fixed ! <<"
}

# CompileKernel
CompileKernel(){
	getInfo ">> Compiling kernel . . . . <<"
    [[ "$(pwd)" != "${kernelDir}" ]] && cd "${kernelDir}"
	GetKernelInfo
	if [ ! -z "$CAFTAG" ];then
		TAGKENEL="$SetTag-$CAFTAG-$SetLastTag"
	else
		TAGKENEL="$(git log | grep "${SetTag}" | head -n 1 | awk -F '\\'${SetLastTag}'' '{print $1"'${SetLastTag}'"}' | awk -F '\\'${SetTag}'' '{print "'${SetTag}'"$2}')"
    fi
	if [ "$KranulVer" = "419" ];then
		ClangMoreStrings="AR=llvm-ar NM=llvm-nm AS=llvm-as STRIP=llvm-strip OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf HOSTAR=llvm-ar HOSTAS=llvm-as LD_LIBRARY_PATH=$clangDir/lib LD=ld.lld HOSTLD=ld.lld"
		export KBUILD_BUILD_HOST="KereAktif-$TAGKENEL"
		export LLVM=1
		export LLVM_IAS=1
	elif [ "$KranulVer" = "44" ];then
        export KBUILD_BUILD_HOST="KereAktif-$Driver-$TAGKENEL"
	fi
	if [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ];then
		MAKE+=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32-
        )
	elif [ "$BuilderKernel" == "sdclang" ];then
		MAKE+=(
				ARCH=$ARCH \
				SUBARCH=$ARCH \
				PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
				CC=clang \
				CROSS_COMPILE=$for64- \
				CROSS_COMPILE_ARM32=$for32- \
				CLANG_TRIPLE=aarch64-linux-gnu- \
				HOSTCC=gcc \
				HOSTCXX=g++ ${ClangMoreStrings}
			)
	elif [ "$allFromClang" == "Y" ];then
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
	elif [ "$SimpleClang" == "Y" ];then
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
    rm -rf out
    BUILD_START=$(date +"%s")
		if [ ! -z "${CIRCLE_BRANCH}" ];then
            BuildNumber="${CIRCLE_BUILD_NUM}"
            ProgLink="${CIRCLE_BUILD_URL}"
        elif [ ! -z "${DRONE_BRANCH}" ];then
            BuildNumber="${DRONE_BUILD_NUMBER}"
            ProgLink="https://cloud.drone.io/${DRONE_REPO}/${DRONE_BUILD_NUMBER}/1/2"
		elif [ ! -z "${GITHUB_REF}" ];then
            BuildNumber="${GITHUB_RUN_NUMBER}"
            ProgLink="https://github.com/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"
        fi
		
        if [ "$PureKernel" == "Y" ];then
		MessageTag="#$TypeBuild"
		else
		MessageTag="#$TypeBuildTag #$TypeBuild #$CpuFreq #$Driver"
		fi
		if [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ] || [ "$BuilderKernel" == "gcc49" ];then
            MSG="<b>🔨 Compiling Kernel....</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Compile Date: $GetCBD </b>%0A<b>Branch: $branch</b>%0A<b>Kernel Name: $KName</b>%0A<b>Kernel Version: $KVer</b>%0A<b>Total Cores: $TotalCores</b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Compile Link Progress:</b><a href='$ProgLink'> Check Here </a>%0A<b>Compiler Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A $MessageTag"
        else
            MSG="<b>🔨 Compiling Kernel....</b>%0A<b>Device: $DEVICE</b>%0A<b>Codename: $CODENAME</b>%0A<b>Compile Date: $GetCBD </b>%0A<b>Branch: $branch</b>%0A<b>Kernel Name: $KName</b>%0A<b>Kernel Version: $KVer</b>%0A<b>Total Cores: $TotalCores</b>%0A<b>Last Commit-Message: $HeadCommitMsg </b>%0A<b>Compile Link Progress:</b><a href='$ProgLink'> Check Here </a>%0A<b>Compiler Info: </b>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A<code>- $ClangType </code>%0A<code>- $gcc64Type </code>%0A<code>- $gcc32Type </code>%0A<code>xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx</code>%0A%0A $MessageTag"
        fi
        if [ ! -z "$1" ];then
            tg_send_info "$MSG" "$1"
        else
            tg_send_info "$MSG" 
        fi
		make -j${TotalCores}  O=out ARCH="$ARCH" "$DEFCONFIG"
    if [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ];then
        make -j${TotalCores}  O=out \
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=$for64- \
            CROSS_COMPILE_ARM32=$for32-
	elif [ "$BuilderKernel" == "sdclang" ];then
		make -j${TotalCores}  O=out \
			ARCH=$ARCH \
			SUBARCH=$ARCH \
			PATH=$clangDir/bin:$gcc64Dir/bin:$gcc32Dir/bin:/usr/bin:${PATH} \
			CC=clang \
			CROSS_COMPILE=$for64- \
			CROSS_COMPILE_ARM32=$for32- \
			CLANG_TRIPLE=aarch64-linux-gnu- \
			HOSTCC=gcc \
			HOSTCXX=g++ ${ClangMoreStrings}
	elif [ "$allFromClang" == "Y" ];then
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
	elif [ "$SimpleClang" == "Y" ];then
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
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
	if [[ ! -e $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb ]];then
		getInfoErr ">> Compile Failed ! Aborting . . . . <<"
		SID="CAACAgUAAxkBAAIb12By2GpymhVy7G9g1Y5D2FcgvYr7AALZAQAC4dzJVslZcFisbk9nHgQ"
        MSG="<b>❌ Compile failed</b>%0AKernel Name : <b>${KName}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
		
        tg_send_info "$MSG" 
		tg_send_sticker "$SID"
        exit -1
	else
		getInfo ">> Compiled Succesfully ! <<"
        cp -af $kernelDir/out/arch/$ARCH/boot/Image.gz-dtb $AnykernelDir
	fi
		
	if [ "$PureKernel" == "Y" ];then
			ZipName="$KName-$KVer-$CODENAME.zip"
	elif [ "$KranulVer" = "44" ];then
		 if [ $TypeBuild = "STABLE" ] || [ $TypeBuild = "RELEASE" ];then
            ZipName="[$CpuFreq]$KName-$Driver-$KVer-$CODENAME.zip"
         else
            ZipName="[$CpuFreq]$KName-$Driver-$TypeBuild-$KVer-$CODENAME.zip"
         fi
	elif [ "$KranulVer" = "419" ];then
		 if [ $TypeBuild = "STABLE" ] || [ $TypeBuild = "RELEASE" ];then
            ZipName="[$CpuFreq]$KName-$KVer-$CODENAME.zip"
         else
            ZipName="[$CpuFreq]$KName-$TypeBuild-$KVer-$CODENAME.zip"
         fi
	fi

    ModAnyKernel
	MakeZip
}

# Spectrum Configuration
SpectrumConf(){
if [ "$KranulVer" = "44" ];then
	if [ "$branch" = "r7/eas" ] || [ "$branch" == "r6/eas-s2" ] || [ "$branch" = "eas-test" ];then
		if [ "WithSpec" == "N" ];then
			spectrumFile=""
		elif [ ! -z "$CUSSPEC" ];then
			spectrumFile="$CUSSPEC"
		elif [ "$CODENAME" == "X00TD" ];then
		if [ "$branch" == "r6/eas-s2" ];then
			spectrumFile="eas-x00t-sixtwo.rc"
		elif [ "$CpuFreq" == "OC" ];then
			spectrumFile="eas-x00t-oc.rc"
		elif [ "$CpuFreq" == "Stock" ];then
			spectrumFile="eas-x00t.rc"
		fi
		elif [ "$CODENAME" == "X01BD" ];then
		if [ "$branch" == "r6/eas-s2" ];then
			spectrumFile="eas-x01bd-sixtwo.rc"
		elif [ "$CpuFreq" == "OC" ];then
			spectrumFile="eas-x01bd-oc.rc"
		elif [ "$CpuFreq" == "Stock" ];then
			spectrumFile="eas-x01bd.rc"
		fi
		fi
	else
		if [ "WithSpec" == "N" ];then
			spectrumFile=""
		elif [ ! -z "$CUSSPEC" ];then
			spectrumFile="$CUSSPEC"
		elif [ "$CODENAME" == "X00TD" ];then
		if [ "$branch" == "r6/hmp-s2" ];then
			spectrumFile="ryuu-x00t-sixtwo.rc"
		elif [ "$CpuFreq" == "OC" ];then
			spectrumFile="ryuu-x00t-oc.rc"
		elif [ "$CpuFreq" == "Stock" ];then
			spectrumFile="ryuu-x00t.rc"
		fi
		elif [ "$CODENAME" == "X01BD" ];then
		if [ "$branch" == "r6/hmp-s2" ];then
			spectrumFile="ryuu-x01bd-sixtwo.rc"
		elif [ "$CpuFreq" == "OC" ];then
			spectrumFile="ryuu-x01bd-oc.rc"
		elif [ "$CpuFreq" == "Stock" ];then
			spectrumFile="ryuu-x01bd.rc"
		fi
		fi
	fi
elif [ "$KranulVer" = "419" ];then
	if [ "WithSpec" == "N" ];then
		spectrumFile=""
	elif [ ! -z "$CUSSPEC" ];then
		spectrumFile="$CUSSPEC"
	elif [ "$CODENAME" == "X00TD" ];then
	if [ "$branch" == "r1/s-s2" ];then
		spectrumFile="419-x00t-sixtwo.rc"
	elif [ "$CpuFreq" == "OC" ];then
		spectrumFile="419-x00t-oc.rc"
	elif [ "$CpuFreq" == "Stock" ];then
		spectrumFile="419-x00t.rc"
	fi
	elif [ "$CODENAME" == "X01BD" ];then
	if [ "$branch" == "r1/s-s2" ];then
		spectrumFile="419-x01bd-sixtwo.rc"
	elif [ "$CpuFreq" == "OC" ];then
		spectrumFile="419-x01bd-oc.rc"
	elif [ "$CpuFreq" == "Stock" ];then
		spectrumFile="419-x01bd.rc"
	fi
	fi
fi
}

# Modify AnyKernel
ModAnyKernel(){
	getInfo ">> Modifying info . . . . <<"
	cd $AnykernelDir
	git reset --hard origin/$AKbranch
	SpectrumConf
    if [ ! -z "$spectrumFile" ];then
        cp -af $SpectrumDir/$spectrumFile spectrum/init.spectrum.rc && sed -i "s/persist.spectrum.kernel.*/persist.spectrum.kernel $KName/g" spectrum/init.spectrum.rc
    fi
    cp -af anykernel-real.sh anykernel.sh
	if [ "$TypeBuild" = "RELEASE" ];then
	cp -af $kernelDir/changelog META-INF/com/google/android/aroma/changelog.txt
	fi
	if [ ! -z "$CUSBUILDDATE" ];then
	BDate="$CUSBUILDDATE"
	else
	BDate="$GetCBD"
	fi
	sed -i "s/kernel.string=.*/kernel.string=$KName/g" anykernel.sh
	if [ "$PureKernel" == "N" ];then
	if [ "$KranulVer" = "44" ];then
	sed -i "s/kernel.type=.*/kernel.type=$TypeBuildTag/g" anykernel.sh
	sed -i "s/kernel.for=.*/kernel.for=$CpuFreq-$Driver/g" anykernel.sh
	elif [ "$KranulVer" = "419" ];then
	sed -i "s/kernel.type=.*/kernel.type=$TypeBuildTag-$CpuFreq/g" anykernel.sh
	fi
	fi
	sed -i "s/kernel.compiler=.*/kernel.compiler=$TypePrint/g" anykernel.sh
	sed -i "s/kernel.made=.*/kernel.made=Ryuuji @ItsRyuujiX/g" anykernel.sh
	sed -i "s/kernel.version=.*/kernel.version=$KVer/g" anykernel.sh
	sed -i "s/message.word=.*/message.word=$MESSAGEWORD/g" anykernel.sh
	sed -i "s/build.date=.*/build.date=$BDate/g" anykernel.sh
	sed -i "s/build.type=.*/build.type=$TypeBuild/g" anykernel.sh
	if [ "$PureKernel" == "N" ];then
	if [ "$Driver" == "Pie" ];then
	sed -i "s/supported.versions=.*/supported.versions=9/g" anykernel.sh
	elif [ "$KranulVer" = "419" ];then
	sed -i "s/supported.versions=.*/supported.versions=11-12/g" anykernel.sh
	else
	sed -i "s/supported.versions=.*/supported.versions=9-12/g" anykernel.sh
	fi
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
	sed -i "s/KNAME/$KName/g" aroma-config
	sed -i "s/KVER/$KVer/g" aroma-config
	sed -i "s/KAUTHOR/Ryuuji @ItsRyuujiX/g" aroma-config
	sed -i "s/KDEVICE/$DEVICE - $CODENAME/g" aroma-config
	sed -i "s/KBDATE/$BDate/g" aroma-config
	if [ "$PureKernel" == "N" ];then
	if [ "$KranulVer" = "44" ];then
	sed -i "s/KVARIANT/$CpuFreq-$Driver/g" aroma-config
	elif [ "$KranulVer" = "419" ];then
	sed -i "s/KVARIANT/$TypeBuildTag-$CpuFreq/g" aroma-config
	fi
	fi
	cd $AnykernelDir
}

# Packing kernel
MakeZip(){
	getInfo ">> Packing Kernel . . . . <<"
    zip -r9 "$ZipName" * -x .git README.md anykernel-real.sh .gitignore *.zip
    tg_send_files
}

# Build for RELEASE
BuildAll(){
	if [ "$KranulVer" = "419" ];then
	ResetBranch
	CompileKernel
	StockFreq
	CompileKernel
	SwitchDevice "M1"
	ResetBranch
	CompileKernel
	StockFreq
	CompileKernel
	elif [ "$KranulVer" = "44" ];then
	# OC
	ResetBranch
	CompileKernel
	SwitchNFI
	CompileKernel
	FixPieWifi
	CompileKernel
	# Stock
	ResetBranch
	StockFreq
	CompileKernel
	SwitchNFI
	CompileKernel
	FixPieWifi
	CompileKernel
	# Switch to X00TD
	SwitchDevice "M1"
	# OC
	ResetBranch
	CompileKernel
	SwitchNFI
	CompileKernel
	# Stock
	ResetBranch
	StockFreq
	CompileKernel
	SwitchNFI
	CompileKernel
	fi
}

### Initial Script
getInfo '>> Initializing Script... <<'

mainDir=$PWD
kernelDir=$mainDir/kernel
NFIDir=$mainDir/NFIDriver
clangDir=$mainDir/clang
gcc64Dir=$mainDir/gcc64
gcc32Dir=$mainDir/gcc32
AnykernelDir=$mainDir/Anykernel3
SpectrumDir=$mainDir/Spectrum

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

if [ "$KranulVer" = "44" ];then
if [ "$branch" == "r7/eas" ] || [ "$branch" == "r6/eas-s2" ] || [ "$branch" == "eas-test" ];then
AKbranch="4.4-eas"
TypeBuildTag="EAS"
else
AKbranch="4.4-hmp"
TypeBuildTag="HMP"
fi
KranulLink="android_kernel_asus_sdm660"
MESSAGEWORD="The greatest day in your life and mine is when we take total responsibility for our attitudes. That is the day we truly grow up."
elif [ "$KranulVer" = "419" ];then
AKbranch="4.19"
KranulLink="android_kernel_asus_sdm660-4.19"
MESSAGEWORD="Become addicted to constant and never-ending self-improvement."
TypeBuildTag="EAS"
fi

## Initial Clone
if [ ! -z "$CUSKERLINK" ];then
getInfo '>> Using Custom Kernel Link ! <<'
KERNLINK="$CUSKERLINK"
else
getInfo '>> Using Default Kernel Link ! <<'
KERNLINK="https://$GIT_SECRET@github.com/$GIT_USERNAME/$KranulLink"
fi

source ${mainDir}/clone.sh

## Chat ID  
if [ "$TypeBuild" == "RELEASE" ];then
	FileChatID="-1001538380925"
else
    FileChatID="-1001756316778"
fi
if [ "$PrivBuild" == "Y" ];then
	InfoChatID="-1001561722193"
else
	InfoChatID="-1001407005109"
fi

## Kernel Setup	
if [ "$branch" == "r1/s-s2" ] || [ "$branch" == "r6/eas-s2" ] || [ "$branch" == "r6/hmp-s2" ];then
	SixTwo="Y"
fi
    ARCH="arm64"
    GetBD=$(date +"%m%d")
    GetCBD=$(date +"%Y-%m-%d")
	GetTime=$(date "+%T")
	GetDateTime=$(date)
    TotalCores=$(nproc --all)
	[[ "$(pwd)" != "${kernelDir}" ]] && cd "${kernelDir}"
	HeadCommitMsg=$(git log --pretty=format:'%s' -n1)
	if [ "$CODENAME" == "X00TD" ];then
	DEVICE="Asus Max Pro M1"
	DEFCONFIG="X00TD_defconfig"
	elif [ "$CODENAME" == "X01BD" ];then
	DEVICE="Asus Max Pro M2"
	DEFCONFIG="X01BD_defconfig"
	fi
	if [ "$KranulVer" = "44" ];then
	SetTag="LA.UM.9.2.r1"
    SetLastTag="SDMxx0.0"
	elif [ "$KranulVer" = "419" ];then
	SetTag="LA.UM.10.2.1.r1"
    SetLastTag="sdm660.0"
	DEFCONFIG="asus/$DEFCONFIG"
	fi
	DEFCONFIGPATH="arch/$ARCH/configs"
    HeadCommitId=$(git log --pretty=format:'%h' -n1)
	CKName=""
    cd $mainDir

## Get Toolchain Version
    if [ ! -z "CUSCLANGVER" ];then
		ClangType="$CUSCLANGVER$CUSLLDVER"
	elif [ "$BuilderKernel" == "gcc" ] || [ "$BuilderKernel" == "gcc12" ];then
        ClangType="$($gcc64Dir/bin/$for64-gcc --version | head -n 1)"
    else
        ClangType=$("$clangDir"/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
    fi
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
	export KBUILD_COMPILER_STRING="$ClangType"
	export KBUILD_BUILD_USER="RyuujiX"

getInfo '>> Script Initialized ! <<'