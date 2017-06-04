在windows平台编译OTApack工具
---------------------------
修复几个编译问题和目录名相关的小bug。 windows 10 + vc2017 测试通过。

Mac原版由Jonathan Levin开发，源码在这里: [OTApack](http://newosxbook.com/files/OTApack.tar)

使用
----
OTApack是一个用来解开苹果iOS系统增量升级包的，还原iPhone根文件系统的工具。
使用方法如下：

1. 从 [theiphonewiki OTA Updates](https://www.theiphonewiki.com/wiki/OTA_Updates)找到对应的iOS升级包
   苹果的OTA包包含自定义格式的类似diff patch的文件补丁在里面，但
   一般Prerequisite Version为 N/A的比较大的OTA包都是包含了完整的原始文件的，解开payload可以得到未加密的根目录文件
    比如最新的iOS 10.3.3 beta [5a0c3743cd0af37548976df6ee03ff13b3e0217c.zip](http://appldnld.apple.com/ios10.3.3seeds/091-15247-20170605-F4C2950C-4262-11E7-AEAA-D133D6EEE68A/com_apple_MobileAsset_SoftwareUpdate/5a0c3743cd0af37548976df6ee03ff13b3e0217c.zip)

2. unzip 解压 5a0c3743cd0af37548976df6ee03ff13b3e0217c.zip\AssetData\payloadv2\payload文件

3. 用pbzx命令把payload文件转换为xz格式文件
```text
pbzx.exe < payload > root_file.xz
```
4. 用7z或者linux 的xz命令解压root_file.xz得到root_file

5. 用ota命令导出iOS的根文件系统。
```text
  mkdir ios_10.3.3_root_filesystem
  cd ios_10.3.3_root_filesystem
  ../ota.exe -l ../root_file 
  ../ota.exe -e '*' ../root_file  
```
6. 看了一下最新的iOS10.3.3的文件，基本包含了完整的内核和各个系统应用在里面吧。
   然后就可以用IDA Pro等反汇编工具查看相应的应用了

详细参考下面文章的说明：
---------------------
1. [Taking apart iOS OTA Updates](http://newosxbook.com/articles/OTA.html)

2. [Recreating iOS filesystem from an OTA](http://newosxbook.com/articles/OTA2.html)

3. [A simple script to recreate the iOS/TvOS filesystem on your Mac](http://newosxbook.com/articles/OTA3.html)

4. [theiphonewiki OTA Updates](https://www.theiphonewiki.com/wiki/OTA_Updates)

