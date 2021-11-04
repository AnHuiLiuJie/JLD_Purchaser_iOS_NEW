# 1 金利达代码熟悉记录要点(只针对个人版)
*  @param  frontClassIcon 标记icon
*  @param  frontClassName 标记名称
*  @param  marketPrice 返利价格
## 第二阶段 新代码开始编辑
#### X:研究环信客服云的API，下一步我们要把环信IM 换成客服云  http://docs.easemob.com/cs/010appconnect❌
#### 11:创客学院开发保存
#### 10:热销商品列表\搜索列表\分类列表 添加frontClassName frontClassIcon左上方 返利rebateLab,详情页添加 返利rebateLab 接口没改
#### 11:详情页 GLPDetailNormalGoodsView 里面的goodsName 改成 goodsTitle ✅
#### 9:将YBImageBrowser/IQKeyboardManager/WXSTransition等库切换成cocopads管理✅
#### 8:去除NHGraphCoderPro\JFCityViewController\FMDB\QiniuSDK第三方库 暂时没用到 后面在考虑 ✅
#### 7:优化首页接口请求首页主页面几个(中间广告位,季节数据,热销数据 4个楼层 热点推荐)集合一起并且楼层为动态可变✅
#### 6:优化推荐好友按钮，优化软件更新请求✅
#### 5:优化首页banner 和 热点推荐请求✅
#### 4:调整首页检测版本更新请求,减少请求次数✅
#### 3:调整首页请求 关闭HUD提示圈,使用mj_header block✅
#### 2:修改首页活动按钮,更改为悬浮按钮✅
#### 1:删除了Assets里面一些没有引用的图片✅

## 第一阶段 项目新建工程,将代码移植 可以很好的解决启动速度问题 
#### 1:首页下拉刷新 自定义Nav的渐变效果 以及状态的颜色调整 ✅
#### 2:对DCBasicViewController里面Nav的显示影藏进行扩充方法 dc_navBarHidden ✅
#### 3:针对侧滑返回出现白条问题 结合2对nav进行透明化处理 dc_navBarLucency ✅
#### 4:针对客服页面也需要重写方法ChatViewController  - (void)dc_navBarLucency:(BOOL)isLucency✅
#### 5:UIImage+Category.h 新增自定义扩展 自定义裁剪算法✅
#### 6:GLPMineController 页面解决滑动卡顿问题✅
#### 7:GLPMineOtherCell button1 make.bottom.equalTo约束多余✅
#### 8:凡是涉及到//lj_change_Frame 都需要查看修改 很多 ✅
#### 9:info.plist->Open As-> Source Code 深色不适配    <key>UIUserInterfaceStyle</key> <string>UIUserInterfaceStyleLight</string>✅
#### 10:TRHotCommdityVC TRClassGoodsVC 页面添加可变列表 ✅

## 上架前确定地址 ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
    Define.h文件 versionFlag 0 测试  1 线上
    DC_H5BaseUrl 地址和 Person_H5BaseUrl地址不一样可能导致web页多导航栏
## 开发者账号
    苹果  账号:fulijun@123ypw.com   密码:Jinlida@2019188302
    环信客服云账号：1103975666@qq.com 密码:yunxunda@2021 网址:https://092298.kefu.easemob.com/ 
    极光:17756070879/Jinlida@2021188



