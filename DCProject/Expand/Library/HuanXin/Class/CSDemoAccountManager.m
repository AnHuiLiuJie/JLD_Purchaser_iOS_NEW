//
//  CSDemoAccountManager.m
//  CustomerSystem-ios
//
//  Created by ease on 16/11/24.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "CSDemoAccountManager.h"
#import <objc/runtime.h>
#import "UIImageView+HDWebCache.h"

@implementation HEmojiPackage
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _packageId = [dictionary valueForKey:@"id"];
        _packageName = [dictionary valueForKey:@"packageName"];
        _emojiNum = [[dictionary valueForKey:@"fileNum"] integerValue];
        _tenantId = [[dictionary valueForKey:@"tenantId"] stringValue];
    }
    return self;
}

@end

@implementation HEmoji

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _emojiName = [dictionary valueForKey:@"fileName"];
        _originUrl = [dictionary valueForKey:@"originUrl"];
        _thumbnailUrl = [dictionary valueForKey:@"thumbnailUrl"];
        _originMediaId = [dictionary valueForKey:@"originMediaId"];
        _thumbnailMediaId = [dictionary valueForKey:@"thumbnailMediaId"];
        _tenantId = [dictionary valueForKey:@"tenantId"];
    }
    return self;
}

- (NSString *)originUrl {
    NSString *orUrl = [[HDClient sharedClient].kefuRestServer stringByAppendingString:_originUrl];
    return orUrl;
}

- (NSString *)thumbnailUrl {
    NSString *thUrl = [[HDClient sharedClient].kefuRestServer stringByAppendingString:_thumbnailUrl];
    return thUrl;
}

- (NSString *)originLocalPath {
    return [[HDSDImageCache sharedImageCache] defaultCachePathForKey:_originMediaId];
}

- (NSString *)thumbnailLocalPath {
    return [[HDSDImageCache sharedImageCache] defaultCachePathForKey:_thumbnailMediaId];
}

- (HDEmotionType)emotionType {
    return HDEmotionGif;
}

@end

@implementation CSDemoAccountManager
{
    NSString *_emojiPath;
}

static CSDemoAccountManager *_manager = nil;
+ (instancetype)shareLoginManager {
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}


#pragma mark - init

- (void)initEMClient
{
    //[[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}

- (void)dealloc
{
    //[[EMClient sharedClient] removeDelegate:self];
}

- (void)setAppkey:(NSString *)appkey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:appkey forKey:kAppKey];
    [userDefaults synchronize];
}

- (void)setCname:(NSString *)cname {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:cname forKey:kCustomerName];
    [userDefaults synchronize];
}

- (void)setTenantId:(NSString *)tenantId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:tenantId forKey:kCustomerTenantId];
    [userDefaults synchronize];
}

- (void)setNickname:(NSString *)nickname {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nickname forKey:kCustomerNickname];
    [userDefaults synchronize];
}

- (void)setProjectId:(NSString *)projectId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:projectId forKey:kCustomerProjectId];
    [userDefaults synchronize];
}

- (NSString *)appkey {
    NSString *apk = [fUserDefaults objectForKey:kAppKey];
    if ([apk length] == 0) {
        apk = kDefaultAppKey;
        [fUserDefaults setObject:apk forKey:kAppKey];
        [fUserDefaults synchronize];
    }
    return apk;
}

- (NSString *)cname {
    NSString *im = [fUserDefaults objectForKey:kCustomerName];
    if ([im length] == 0) {
        im = kDefaultCustomerName;
        [fUserDefaults setObject:im forKey:kCustomerName];
        [fUserDefaults synchronize];
    }
    return im;
}

- (NSString *)nickname {
    NSString *tnickname = kDefaultCustomerNickname;
    NSDictionary *dic = [DCUpdateTool shareClient].easeUserDict;
    NSArray *allValues = [dic allValues];
    NSDictionary *userInfo = allValues.count > 0 ? allValues[0] : nil;
    NSString *nickname = [userInfo objectForKey:@"nickname"];
    if (nickname.length != 0) {
        tnickname = nickname;
    }
    return tnickname;
}

- (NSString *)avatarStr {
    NSDictionary *dic = [DCUpdateTool shareClient].easeUserDict;
    NSArray *allValues = [dic allValues];
    NSDictionary *userInfo = allValues.count > 0 ? allValues[0] : nil;
    NSString *headImg = [userInfo objectForKey:@"headImg"];
    if (headImg.length == 0) {
        return @"https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/e998ef4e7cbcfdb345716c5562a29956_121_121.png";
    }else
        return headImg;
}

- (NSString *)tenantId {
    NSString *ttenantId = [fUserDefaults objectForKey:kCustomerTenantId];
    if ([ttenantId length] == 0) {
        ttenantId = kDefaultTenantId;
        [fUserDefaults setObject:ttenantId forKey:kCustomerTenantId];
        [fUserDefaults synchronize];
    }
    return ttenantId;
}

- (NSString *)projectId {
    NSString *tprojectId = [fUserDefaults objectForKey:kCustomerProjectId];
    if ([tprojectId length] == 0) {
        tprojectId = kDefaultProjectId;
        [fUserDefaults setObject:tprojectId forKey:kCustomerProjectId];
        [fUserDefaults synchronize];
    }
    return tprojectId;
}

- (instancetype)init {
    if (self = [super init]) {
        _password = hxPassWord;
        [self initEMClient];
    }
    return self;
}

- (void)setPushOptions {

    if ([[CSDemoAccountManager shareLoginManager] loginKefuSDK]) {
        HDPushOptions *options = [[HDClient sharedClient] hdPushOptions];
        options.displayStyle = HDPushDisplayStyleMessageSummary;
//        options.displayName = @"我是军哥";//[[HDClient sharedClient] hdPushOptions].displayName;
        
        [HDClient.sharedClient.pushManager updatePushDisplayName:@"客服回复" completion:^(NSString *_Nonnull aDisplayName, HDError *_Nonnull aError) {
        }];
        
        [HDClient.sharedClient.pushManager updatePushDisplayStyle:HDPushDisplayStyleMessageSummary completion:^(HDError *error) {
            NSLog(@" error:%@",error.errorDescription);
        }];
    }
}

//登录IM
- (BOOL)loginKefuSDK {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self cacheBigExpression];
    });
    HDClient *client = [HDClient sharedClient];
    if (client.isLoggedInBefore) {
        return YES;
    }
    if (![self login]) {
        return NO;
    }else{
        return YES;
    }
    //return  [self registerIMuser];
}

- (BOOL)login {
    NSString *userId;
    NSString *userName;
    NSString *userId_E = [DCObjectManager dc_readUserDataForKey:DC_UserID_Key];
    NSString *userId_P = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    if (![userId_E dc_isNull] && userId_E.length > 0) {
        userId = [NSString stringWithFormat:@"%@",userId_E];
        userName = [NSString stringWithFormat:@"b2b_%@",userId_E];
    }else if (![userId_P dc_isNull] && userId_P.length > 0){
        userId = [NSString stringWithFormat:@"%@",userId_P];
        userName = [NSString stringWithFormat:@"b2c_%@",userId_P];
    }
    NSString *pwd = [NSString stringWithFormat:@"%@A5F114BA5F",userId];
    HDError *error = [[HDClient sharedClient] loginWithUsername:userName password:pwd];
    if (!error) { //IM登录成功
        return YES;
    } else { //登录失败
        NSLog(@"登录失败 error code :%d,error description:%@",error.code,error.errorDescription);
        return NO;
    }
    return NO;
}

//创建一个随机的用户名
- (NSString *)getRandomUsername {
    NSString *username = nil;
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSString *deviceUID = [[NSString alloc] initWithString:[[device identifierForVendor] UUIDString]];
    if ([deviceUID length] == 0) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        if (uuid)
        {
            deviceUID = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
        }
    }
    username = [deviceUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    username = [username stringByAppendingString:[NSString stringWithFormat:@"%u",arc4random()%100000]];
    return username;
}

- (BOOL)registerIMuser {
    //举个栗子。注册建议在服务端创建环信id与自己app的账号一一对应，而不要放到APP中，可以在登录自己APP时从返回的结果中获取环信账号再登录环信服务器
    HDError *error = nil;
    NSString *userId;
    NSString *userName;
    NSString *userId_E = [DCObjectManager dc_readUserDataForKey:DC_UserID_Key];
    NSString *userId_P = [DCObjectManager dc_readUserDataForKey:P_UserID_Key];
    if (![userId_E dc_isNull] && userId_E.length > 0) {
        userId = [NSString stringWithFormat:@"%@",userId_E];
        userName = [NSString stringWithFormat:@"b2b_%@",userId_E];
    }else if (![userId_P dc_isNull] && userId_P.length > 0){
        userId = [NSString stringWithFormat:@"%@",userId_P];
        userName = [NSString stringWithFormat:@"b2c_%@",userId_P];
    }
    NSString *pwd = [NSString stringWithFormat:@"%@A5F114BA5F",userId];
    error = [[HDClient sharedClient] registerWithUsername:userName password:pwd];
    if (error) {
        /*
         "network_anomalies" = "Network anomalies, please try again!";
         "account_already_exists" = "Registered account already exists, please try again!";
         "without_permission" = "Without permission, please sign in to open mode!";
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == HDErrorUserAlreadyExist) {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"account_already_exists", @"Registered account already exists, please try again!") preferredStyle:UIAlertControllerStyleAlert];
                [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"setting_confirm", @"confirm") style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
            }else if(error.code == 208){
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"without_permission", @"Without permission, please sign in to open mode!") preferredStyle:UIAlertControllerStyleAlert];
                [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"setting_confirm", @"confirm") style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
            }else{
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"network_anomalies", @"Network anomalies, please try again!") preferredStyle:UIAlertControllerStyleAlert];
                [alter addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"setting_confirm", @"confirm") style:UIAlertActionStyleDefault handler:nil]];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
            }
        });
        return NO;
    }
    return YES;
}

- (void)refreshManagerData {
    unsigned int propertysCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertysCount);
    for (int i=0; i<propertysCount-1; i++) {
        objc_property_t property = propertys[i];
        const char *propertyName = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        //因为都是NSString所以直接赋值
        [self setValue:@"" forKey:key];
    }
}

- (void)createPlist {
    NSString *path=NSTemporaryDirectory();
    NSLog(@"path = %@",path);
    _emojiPath = [path stringByAppendingPathComponent:@"emoji.plist"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:_emojiPath]) {
         [fm createFileAtPath:_emojiPath contents:nil attributes:nil];
        [[NSMutableDictionary dictionaryWithCapacity:0] writeToFile:_emojiPath atomically:YES];
    }
}

- (void)setEmojiValue:(id)value forKey:(NSString *)key {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithContentsOfFile:_emojiPath];
    [mDic setValue:value forKey:key];
    [mDic writeToFile:_emojiPath atomically:YES];
}

- (void)cacheBigExpression {
    [self createPlist];
    HDChatManager *chat = [HDClient sharedClient].chatManager;
    [chat getEmojiPackageListCompletion:^(NSArray<NSDictionary *> *emojiPackages, HDError *error) {
        if (error == nil) {
            NSMutableArray *hPackages = @[].mutableCopy;
            [self setEmojiValue:emojiPackages forKey:@"emojiPackages"];
            for (NSDictionary *dict in emojiPackages) {
                HEmojiPackage *emojiPackage = [[HEmojiPackage alloc] initWithDictionary:dict];
                [hPackages addObject:emojiPackage];
            }
            for (HEmojiPackage *package in hPackages) {
                [chat getEmojisWithPackageId:package.packageId completion:^(NSArray<NSDictionary *> *emojis, HDError *error) {
                    if (error == nil) {
                        [self setEmojiValue:emojis forKey:[NSString stringWithFormat:@"emojis%@",package.packageId]];
                    }
                    //                for (NSDictionary *di in emojis) {
                    //                    HEmoji *emoji = [[HEmoji alloc] initWithDictionary:di];
                    //                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    //                    NSURL *originUrl = [NSURL URLWithString:emoji.originUrl];
                    //                    [manager downloadImageWithURL:originUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    //                        SDImageCache *cache = [SDImageCache sharedImageCache];
                    //                        [cache storeImage:image forKey:emoji.originMediaId];
                    //                    }];
                    //                    NSURL *thumbUrl = [NSURL URLWithString:emoji.thumbnailUrl];
                    //                    [manager downloadImageWithURL:thumbUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    //                        SDImageCache *cache = [SDImageCache sharedImageCache];
                    //                        [cache storeImage:image forKey:emoji.thumbnailMediaId];
                    //                    }];
                    //                }
                }];
            }
        }
    }];
}


 - (HDVisitorInfo *)visitorInfo {
    HDVisitorInfo *visitor = [[HDVisitorInfo alloc] init];
    visitor.name = @"";
    visitor.qq = @"";
    visitor.phone = @"";
    visitor.companyName = @"";
    visitor.nickName = self.nickname;
    visitor.email = @"";
    visitor.desc = @"";
    return visitor;
}


@end
