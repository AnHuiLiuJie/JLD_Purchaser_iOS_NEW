//
//  GLBQualificateModel.h
//  DCProject
//
//  Created by bigbing on 2019/8/28.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLBQualificateModel : NSObject

@property (nonatomic, assign) NSInteger applyState; // 1-待审核；2-审核通过；3-审核不通过。空表示无资质申请记录
@property (nonatomic, copy) NSString *firmAddress; // 企业具体地址
@property (nonatomic, copy) NSString *firmArea; // 企业所在地区编号名称
@property (nonatomic, assign) NSInteger firmAreaId; // 企业所在地区编号
@property (nonatomic, copy) NSString *firmCat1; // 企业一级分类
@property (nonatomic, copy) NSString *firmCat1Name; // 企业一级分类名称
@property (nonatomic, copy) NSString *firmCat2List; // 企业二级分类
@property (nonatomic, copy) NSString *firmCatName; // 企业二级分类名称
@property (nonatomic, copy) NSString *firmContact; // 企业联系人
@property (nonatomic, assign) NSInteger firmId; // 企业ID
@property (nonatomic, copy) NSString *firmName; // 企业名称

@property (nonatomic, strong) NSArray *qcList; // 企业资质集合


@end



#pragma mark - 企业资质立标
@interface GLBQualificateListModel : NSObject

@property (nonatomic, copy) NSString *isRequired; // 是否必须上传文件：1-必须上传；2-可不上传
@property (nonatomic, copy) NSString *qcCode; // 资质编码
@property (nonatomic, copy) NSString *qcName; // 资质名称
@property (nonatomic, copy) NSString *qcPic; // 资质图片全路径，多路径以英文逗号分隔


#pragma mark - 自定义属性
@property (nonatomic, strong) NSMutableArray *imgUrlArray; // 图片地址数组

@end


NS_ASSUME_NONNULL_END
