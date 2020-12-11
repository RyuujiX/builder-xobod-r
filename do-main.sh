#! /bin/bash
branch="20201208/main"
BuilderKernel="00000"

. main.sh 'initial' 'full'

FolderUp="BrokenNucleus"
spectrumFile="f.r"
TypeBuild="TEST-Main"
TypeBuildTag="AOSP"
getInfo ">> Building kernel . . . . <<"

CompileKernel
CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

FixPieWifi

CompileKernel
CompileKernel "65"
# CompileKernel "68"
# CompileKernel "71"
# CompileKernel "72"

tg_send_info "All $GetKernelName $BuilderKernel already uploaded to Gdrive :D"