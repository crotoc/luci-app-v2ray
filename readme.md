# 如何在openwrt 18.06.1中安装v2ray服务器和luci-v2ray

这个项目是基于coolsnowwolf/lede项目，从中间提取了相关依赖包。针对海外党做了如下的改动：

1. 在luci中添加了修改用户自定义unbluck-youku列表的设置。
2. 针对一些app中不使用域名进行解析的问题，将自定义的列表分成域名和ip两部分。
3. 其中域名部分可以只使用用户自定义的列表，也可以下载网上的列表与自己的列表合并。网上的列表提取子coolsnowwolf/lede项目中的ipset-lists包。
4. ip部分使用ipset add命令添加。
5. 添加了重启，启动，停止的按钮，方便使用

水平有限，大家随意

## 要求

1. 一个安装openwrt的路由
2. 一颗折腾的心

## Compile

### 下载sdk并且解压缩

SDK可以用于制作openwrt可以使用的ipk包，每种路由器根据不同核心需要下载不同的sdk包，我的路由器是R7800,所以去openwrt下载了对应的[sdk](https://downloads.openwrt.org/releases/18.06.2/targets/),即ipq806x的sdk：

	wget https://downloads.openwrt.org/releases/18.06.1/targets/ipq806x/generic/openwrt-sdk-18.06.1-ipq806x_gcc-7.3.0_musl_eabi.Linux-x86_64.tar.xz
	tar xf openwrt-sdk-18.06.1-ipq806x_gcc-7.3.0_musl_eabi.Linux-x86_64.tar.xz


### 下载luci到sdk目录下的package文件夹

	git clone https://github.com/crotoc/luci-app-v2ray.git
	cd openwrt-sdk-18.06.1-ipq806x_gcc-7.3.0_musl_eabi.Linux-x86_64
	cp -R ../luci-app-v2ray/* package/
	rm -rf package/luci-app-v2ray-pro/
	cp -R ~/git_project/luci-app-v2ray/luci-app-v2ray-pro/ package/

### 更新sdk需要的安装包

	./script/feeds update -a

### 安装依赖包

	./scripts/feeds install iptables-mod-tproxy kmod-ipt-tproxy ip ipset-lists pdnsd-alt coreutils coreutils-base64 coreutils-nohup dnsmasq-full v2ray ca-certificates lua-cjson luci-base
	
### 制作ipk包

	make package/luci-app-v2ray-pro/{down,compile} -j8
	
生成的ipk文件会存放在./bin/packages/arm_cortex-a15_neon-vfpv4/base/中.

### 重新制作

如果修改部分代码之后需要重新制作:

	rm -rf package/luci-app-v2ray-pro/
	cp -R ~/git_project/luci-app-v2ray/luci-app-v2ray-pro/ package/
	make package/luci-app-v2ray-pro/{clean,compile} -j8
	
## 安装

将上面的ipset-lists，pdnsd-alt，v2ray和luci-app-v2ray-pro四个ipk文件传到路由器上，除上述四个依赖包意外，其他的依赖包可以直接在服务器上安装：

	opkg install iptables-mod-tproxy kmod-ipt-tproxy ip  coreutils coreutils-base64 coreutils-nohup  v2ray ca-certificates lua-cjson luci-base

这四个包单独安装:

	opkg install ipset-lists*ipk
	opkg install pdnsd-alt*ipk
	opkg install v2ray*ipk
	opkg install luci-app-v2ray-pro*ipk
	
如果安装过程中出现依赖包缺失的情况，就使用opkg安装。


## 参考链接

https://github.com/openwrt/luci/wiki/CBI

https://github.com/seamustuohy/luci_tutorials/blob/master/04-model-cbi.md

https://github.com/coolsnowwolf/lede/tree/master/package

http://dvblog.soabit.com/building-custom-openwrt-packages-an-hopefully-complete-guide/

https://oldwiki.archive.openwrt.org/doc/howto/obtain.firmware.sdk
