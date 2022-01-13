#!/bin/bash




clang_path="${PWD}/complier/proton-clang/bin"
gcc_path="${clang_path}/aarch64-linux-gnu-"
gcc_32_path="${clang_path}/arm-linux-gnueabi-"

cd kernel_src

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

echo
echo
echo "====================================="
print "****开始编译内核***** version:$date" yellow
echo "====================================="

args+="LOCALVERSION=-$date "

args+="CC=${clang_path}/clang \
CLANG_TRIPLE=aarch64-linux-gnu- \
LLVM_AR=${clang_path}/llvm-ar \
LLVM_NM=${clang_path}/llvm-nm \
OBJCOPY=${clang_path}/llvm-objcopy \
OBJDUMP=${clang_path}/llvm-objdump \
STRIP=${clang_path}/llvm-strip \
CROSS_COMPILE=$gcc_path "

#LD=${clang_path}/ld.lld \

args+="CROSS_COMPILE_ARM32=$gcc_32_path "

echo
echo
echo "====================================="
print "参数： $args" blue
echo "====================================="
echo
echo


clean(){
	rm -rf out
	mkdir out
	make mrproper
	make $args mrproper
}

sendMsg(){
	curl  --data-urlencode title=内核编译通知  --data-urlencode content=$1  http://www.pushplus.plus/send?token=56c07b8902ab4e10a719140a513e0a1b&template=html
}


build_wayne_kernel(){
	export KBUILD_BUILD_USER="Zahi"
	export KBUILD_BUILD_HOST="Zahi-server"
	make $args wayne_defconfig 
	if [ $? -ne 0 ]; then
      		exit 0
        fi
        echo
        echo
	make $args
	if [ $? -ne 0 ]; then
		echo
		echo
		echo "====================================="
		print "************编译失败!***************" red
		echo "====================================="
		sendMsg "编译失败"
	else 
		echo
		echo
		echo "====================================="
		print "************编译成功!***************" green
		echo "====================================="
		sendMsg "编译成功"
        fi
        echo
	echo     
}

clean
build_wayne_kernel
cp ./out/arch/arm64/boot/Image.gz-dtb Image.gz-dtb
cd ..
