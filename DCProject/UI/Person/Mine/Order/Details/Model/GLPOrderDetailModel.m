//
//  GLPOrderDetailModel.m
//  DCProject
//
//  Created by LiuMac on 2021/6/18.
//

#import "GLPOrderDetailModel.h"

@implementation GLPOrderDetailModel

@end


#pragma mark ############################### GLPOrderGoodsListModel #################################################

@implementation GLPOrderGoodsListModel

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    
    GLPOrderGoodsListModel * objCopy = [[GLPOrderGoodsListModel alloc] init];
    unsigned int count;
    //得到这个类的属性数量以及这个类声明的属性
    objc_property_t * properties = class_copyPropertyList(object_getClass(objCopy), &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    //遍历属性名称并添加到数组中
    for (unsigned int i = 0; i < count; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    //释放 objc_property_t
    free(properties);
    
    //使用KVC赋值
    for (int i = 0; i < count ; i++)
    {
        NSString *name=[propertyArray objectAtIndex:i];
        id value=[self valueForKey:name];
        if([value respondsToSelector:@selector(mutableCopyWithZone:)]){
            [objCopy setValue:[value mutableCopy] forKey:name];
        }
        else{
            
        }
    }
    return objCopy;
}

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
// 重写setValue:forUndefinedKey:方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

#pragma mark ############################### GLPOrderReturnApplyListModel ############################################

@implementation GLPOrderReturnApplyListModel

@end


#pragma mark ############################### GLPOrderDeliveryBeanModel ############################################
@implementation GLPOrderDeliveryBeanModel

@end

#pragma mark ############################### GLPOrderDeliverModel ############################################
@implementation GLPOrderDeliverModel

@end
