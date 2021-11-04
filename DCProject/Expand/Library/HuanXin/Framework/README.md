

# 文档 
### https://docs.easemob.com/cs/300visitoraccess/iossdk?s[]=x86&s[]=64

上传AppStore以及打包ipa注意事项
为了方便广大开发者开发测试，Demo中提供的framework文件支持x86_64 i386 armv7 arm64平台，上传AppStore(xcode10打包ipa)时需要剔除不需要的CPU架构支持，只剩余armv7、arm64 平台即可，命令如下： 


## 包含实时音视频版本HelpDesk.framework
【首先进入HelpDesk.framework所在目录】
// 移除支持x86_64,i386的二进制文件
lipo HelpDesk.framework/HelpDesk -remove x86_64 -remove i386 -output HelpDesk
//替换framwork内部二进制文件[记得备份]
mv HelpDesk HelpDesk.framework/HelpDesk
//查看剥离后的二进制文件支持的CPU架构，如果显示armv7 arm64，就完成剥离，可上传AppStore
lipo -info HelpDesk.framework/HelpDesk
依赖库Hyphenate.framework

【首先进入Hyphenate.framework所在目录】
// 移除支持x86_64，i386的二进制文件
lipo Hyphenate.framework/Hyphenate -remove x86_64 -remove i386 -output Hyphenate
//替换framwork内部二进制文件[记得备份]
mv Hyphenate Hyphenate.framework/Hyphenate
//查看剥离后的二进制文件支持的CPU架构，如果显示armv7 arm64，就完成剥离，可上传AppStore
lipo -info Hyphenate.framework/Hyphenate




## 不包含实时音视频版本HelpDeskLite.framework

【首先进入HelpDeskLite.framework所在目录】
// 移除支持x86_64,i386的二进制文件
lipo HelpDeskLite.framework/HelpDeskLite -remove x86_64 -remove i386 -output HelpDeskLite
//替换framwork内部二进制文件[记得备份]
mv HelpDeskLite HelpDeskLite.framework/HelpDeskLite
//查看剥离后的二进制文件支持的CPU架构，如果显示armv7 arm64，就完成剥离，可上传AppStore
lipo -info HelpDeskLite.framework/HelpDeskLite
依赖库HyphenateLite.framework

【首先进入HyphenateLite.framework所在目录】
// 移除支持x86_64，i386的二进制文件
lipo HyphenateLite.framework/HyphenateLite -remove x86_64 -remove i386 -output HyphenateLite
//替换framwork内部二进制文件[记得备份]
mv HyphenateLite HyphenateLite.framework/HyphenateLite
//查看剥离后的二进制文件支持的CPU架构，如果显示armv7 arm64，就完成剥离，可上传AppStore
lipo -info HyphenateLite.framework/HyphenateLite
