#!/bin/bash

#Author : zahi0 @ github
#Date : 20220113
#Description : 内核编译脚本，这个脚本可以在github action和自己的pc都可以使用

clang_path="${PWD}/proton-clang/bin"
gcc_path="${clang_path}/aarch64-linux-gnu-"
gcc_32_path="${clang_path}/arm-linux-gnueabi-"
date="`date +"%Y%m%d%H%M"`"
args="-j$(nproc --all) O=out ARCH=arm64 SUBARCH=arm64 "

print (){
case ${2} in
	"red")
	echo -e "\033[31m $1 \033[0m";;

	"blue")
	echo -e "\033[34m $1 \033[0m";;

	"yellow")
	echo -e "\033[33m $1 \033[0m";;

	"purple")
	echo -e "\033[35m $1 \033[0m";;

	"sky")
	echo -e "\033[36m $1 \033[0m";;

	"green")
	echo -e "\033[32m $1 \033[0m";;

	*)
	echo $1
	;;
	esac
}

clean(){
	rm -rf out
	mkdir out
	make mrproper
	make $args mrproper
}



build_kernel(){
	export KBUILD_BUILD_USER="zahi0"  
	export KBUILD_BUILD_HOST="zahi0-server"  
	make $args wayne_defconfig #修改配置文件
	if [ $? -ne 0 ]; then
      		exit 0
        fi
        echo
        echo
	make $args
	if [ $? -ne 0 ]; then
		echo
		echo "====================================="
		print "************编译失败!***************" red
		echo "====================================="
		
	else 
		echo
		echo "====================================="
		print "************编译成功!***************" green
		echo "====================================="
	
        fi
        echo
	echo     
}


echo
echo "====================================="
print "****开始编译内核***** version:$date" yellow
echo "====================================="


args+="CC=${clang_path}/clang \
CLANG_TRIPLE=aarch64-linux-gnu- \
LLVM_AR=${clang_path}/llvm-ar \
LLVM_NM=${clang_path}/llvm-nm \
OBJCOPY=${clang_path}/llvm-objcopy \
OBJDUMP=${clang_path}/llvm-objdump \
STRIP=${clang_path}/llvm-strip \
CROSS_COMPILE=$gcc_path \
LD=${clang_path}/ld.lld \
CROSS_COMPILE_ARM32=$gcc_32_path \
LOCALVERSION=-$date  "



cd kernel_src
clean
build_kernel
cp ./out/arch/arm64/boot/Image.gz-dtb Image.gz-dtb
cd ..
