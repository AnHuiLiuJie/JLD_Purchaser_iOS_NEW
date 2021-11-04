//
//  MedicalInfomationModel.m
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "MedicalInfomationModel.h"

@implementation MedicalInfomationModel

@end


#pragma ***********************************
@implementation MedicalPersListModel

- (id)copyWithZone:(NSZone *)zone {
    MedicalPersListModel *model = [[self class] allocWithZone:zone];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([MedicalPersListModel class], &count);
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

@end

#pragma makr -********************** 处方详情     *************************
@implementation PrescriptionDetailsModel

@end



#pragma ***********************************
@implementation MedicalSymptomListModel

@end



#pragma ***********************************
@implementation PatientDisplayInformationModel

- (id)copyWithZone:(NSZone *)zone {
    PatientDisplayInformationModel *model = [[self class] allocWithZone:zone];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([PatientDisplayInformationModel class], &count);
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
    
    PatientDisplayInformationModel *objCopy = [[self class] allocWithZone:zone];
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
        NSString *name = [propertyArray objectAtIndex:i];
        id value=[self valueForKey:name];
        if([value respondsToSelector:@selector(mutableCopyWithZone:)]){
            [objCopy setValue:[value mutableCopy] forKey:name];
        }
        else{
            
        }
    }
    return objCopy;
}

@end

