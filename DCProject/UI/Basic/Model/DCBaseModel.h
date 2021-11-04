//
//  DCBaseModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/20.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
NS_ASSUME_NONNULL_BEGIN

@interface DCBaseModel : NSObject

- (void)setValue:(__nullable id)value forUndefinedKey:(NSString *)key;


- (id)copyWithZone:(nullable NSZone *)zone;
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone;
@end



#pragma mark - 数据原
@interface CommonModel : DCBaseModel

@property (nonatomic, copy)   NSString *code;//状态码
@property (nonatomic, retain) id        data;//承载数据
@property (nonatomic, copy)   NSString *msg;//返回消息
@property (nonatomic, copy)   NSString *success;//是否成功

@end


#pragma mark - 通用列表页
@interface CommonListModel : DCBaseModel

@property (nonatomic, copy) NSString *currentPage;//当前页码
@property (nonatomic, retain)  id         pageData;//数据源
@property (nonatomic, copy) NSString *pageSize;//每页的记录数
@property (nonatomic, copy) NSString *totalPage;//总页数
@property (nonatomic, copy) NSString *totalRows;//总记录数

@end

#pragma mark - 个人本地存储
@interface LocalCommonSetModel : DCBaseModel

@property (nonatomic, copy) NSString *specific;//个性化开关 1 打开 2拒绝


@end

NS_ASSUME_NONNULL_END
