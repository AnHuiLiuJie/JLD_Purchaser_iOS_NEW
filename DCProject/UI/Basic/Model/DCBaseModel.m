//
//  DCBaseModel.m
//  DCProject
//
//  Created by 赤道 on 2021/4/20.
//

#import "DCBaseModel.h"
#import <objc/runtime.h>

@implementation DCBaseModel

- (id)copyWithZone:(NSZone *)zone {
    DCBaseModel *model = [[self class] allocWithZone:zone];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([DCBaseModel class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [model setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    
    return model;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    
    DCBaseModel * objCopy = [[DCBaseModel alloc] init];
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
//————————————————
//版权声明：本文为CSDN博主「BennerZhang」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/zzx1235789/article/details/93167391

/**
 当一个对象调用setValue方法时，方法内部会做以下操作：
 1). 检查是否存在相应的key的set方法，如果存在，就调用set方法。
 2). 如果set方法不存在，就会查找与key相同名称并且带下划线的成员变量，如果有，则直接给成员变量属性赋值。
 3). 如果没有找到_key，就会查找相同名称的属性key，如果有就直接赋值。
 4). 如果还没有找到，则调用valueForUndefinedKey:和setValue:forUndefinedKey:方法。
 这些方法的默认实现都是抛出异常，我们可以根据需要重写它们。复制代码
 */
- (void)setValue:(__nullable id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@",key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

- (id)initWithCoder:(NSCoder *)coder
{
    Class cls = [self class];
    while (cls != [NSObject class]) {
        /*判断是自身类还是父类*/
        BOOL bIsSelfClass = (cls == [self class]);
        unsigned int iVarCount = 0;
        unsigned int propVarCount = 0;
        unsigned int sharedVarCount = 0;
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;

        for (int i = 0; i < sharedVarCount; i++) {
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
            NSString *key = [NSString stringWithUTF8String:varName];
            id varValue = [coder decodeObjectForKey:key];
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"];
            if (varValue && [filters containsObject:key] == NO) {
                [self setValue:varValue forKey:key];
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    Class cls = [self class];
    while (cls != [NSObject class]) {
        /*判断是自身类还是父类*/
        BOOL bIsSelfClass = (cls == [self class]);
        unsigned int iVarCount = 0;
        unsigned int propVarCount = 0;
        unsigned int sharedVarCount = 0;
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;/*变量列表，含属性以及私有变量*/
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);/*属性列表*/
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;

        for (int i = 0; i < sharedVarCount; i++) {
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
            NSString *key = [NSString stringWithUTF8String:varName];
            /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/
            id varValue = [self valueForKey:key];
            NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"];
            if (varValue && [filters containsObject:key] == NO) {
                [coder encodeObject:varValue forKey:key];
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
}
////————————————————
////版权声明：本文为CSDN博主「longlongValue」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
////原文链接：https://blog.csdn.net/longlongValue/article/details/81060583

@end


#pragma mark - 数据原
@implementation  CommonModel

@end


#pragma mark - 通用列表页
@implementation  CommonListModel
@end


#pragma mark - 个人本地存储
@implementation LocalCommonSetModel

@end
