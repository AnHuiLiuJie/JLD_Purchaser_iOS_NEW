//
//  MedicalInfomationModel.h
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "DCBaseModel.h"
#import "GLPNewShoppingCarModel.h"
NS_ASSUME_NONNULL_BEGIN

@class MedicalPersListModel;
@class MedicalSymptomListModel;

@interface MedicalInfomationModel : DCBaseModel

@property (nonatomic, copy) NSArray *persList;
@property (nonatomic, copy) NSArray *symptomList;

@end

#pragma makr -********************** 处方详情PrescriptionDetailsModel     *************************
@interface PrescriptionDetailsModel : DCBaseModel

@property (nonatomic, copy) NSString *auditReason;//拒方原因
@property (nonatomic, copy) NSString *auditTime;//审核时间，线下处方单审核时使用
@property (nonatomic, copy) NSString *auditUser;//审核人，线下处方单审核时使用
@property (nonatomic, copy) NSString *createDate;//处方创建时间
@property (nonatomic, copy) NSString *departName;//医师对应的科室
@property (nonatomic, copy) NSString *diagnose;//诊断
@property (nonatomic, copy) NSString *doctorName;//对应医生的名称
@property (nonatomic, strong) MedicalPersListModel *drugUser;//用药人信息
@property (nonatomic, copy) NSString *mallAuditState;//店铺审核状态：0-待审核，1-审核通过，2-审核不通过
@property (nonatomic, copy) NSString *rpMsg;//处方信息
@property (nonatomic, copy) NSString *rpState;//线上处方状态：0-接口未调用，1-待开方，2-开方中，3-已开方，4-已拒绝，5-接口调用失败，线下处方单状态：0-待审核，1-审核通过，2-审核不通过 .
@property (nonatomic, copy) NSString *rpType;//1-线上处方单，2-线下处方单
@property (nonatomic, copy) NSString *rpUrl;//处方图片url
@property (nonatomic, copy) NSString *state;//综合状态：0-开方中，1-开方成功，2-互联网医院拒绝，3-平台拒绝，4-店铺拒绝
@property (nonatomic, copy) NSString *billDesc;
@property (nonatomic, copy) NSString *supUrl;

@end
#pragma ********************************************************用药人列表
@interface MedicalPersListModel : DCBaseModel

@property (nonatomic, copy) NSString *birthTime;//患者出生时间
@property (nonatomic, copy) NSString *chiefComplaint;//病情描述（主诉
@property (nonatomic, copy) NSString *drugId;//患者ID;
@property (nonatomic, copy) NSString *historyAllergic;//过敏史;
@property (nonatomic, copy) NSString *historyIllness;//既往史（家族病史）
@property (nonatomic, copy) NSString *icdName;//对应icd名称;
@property (nonatomic, copy) NSString *icdName2;//对应icd2名称;
@property (nonatomic, copy) NSString *idCard;//患者身份证号;
@property (nonatomic, copy) NSString *weight;//患者体重
@property (nonatomic, copy) NSString *isDefault;//是否默认用药人：1.是，2.否;
@property (nonatomic, copy) NSString *isHistoryAllergic;//是否有过敏史：1.是，2.否;
@property (nonatomic, copy) NSString *isHistoryIllness;//是否有既往史（家族病史）：1.是，2.否;
@property (nonatomic, copy) NSString *isNowIllness;//是否有现病史（过往病史)：1.是，2.否;
@property (nonatomic, copy) NSString *lactationFlag;//是否是备孕/怀孕/哺乳期：1.是，2.否;
@property (nonatomic, copy) NSString *liverUnusual;//肝功能是否异常：1.是，2.否;
@property (nonatomic, copy) NSString *nowIllness;//现病史（过往病史）;
@property (nonatomic, copy) NSString *patientAge;//患者年龄;
@property (nonatomic, copy) NSString *patientGender;//患者性别：1-男， 2-女;
@property (nonatomic, copy) NSString *patientName;//患者姓名;
@property (nonatomic, copy) NSString *patientTel;//患者手机;
@property (nonatomic, copy) NSString *relation;//1.本人，2.家属，3.亲戚，4.朋友;
@property (nonatomic, copy) NSString *renalUnusual;//肾功能是否异常：1.是，2.否;

@property (nonatomic, assign) BOOL isSelected;//自定义参数选中 非选中

- (id)copyWithZone:(nullable NSZone *)zone;

@end

#pragma ******************************************************** 药品对应的症状列表
@interface MedicalSymptomListModel : DCBaseModel

@property (nonatomic, copy) NSString *goodsId;//产品Id
@property (nonatomic, copy) NSString *goodsName;//产品名称
@property (nonatomic, copy) NSArray *symptom;//药品对应疾病症状

#pragma mark - 自定义属性
@property (nonatomic, copy) NSString *goodsTitle;//产品标题

@end


#pragma ********************************************************
@interface PatientDisplayInformationModel : DCBaseModel

@property (nonatomic, copy) NSString *drugId;//用药人
@property (nonatomic, copy) NSString *onlineStatus;//状态值默认0复方 1 处方
@property (nonatomic, copy) NSString *drugImg;//复方处方单图片 复方和处方单要二选一（可能是复方或者处方，onlineStatus来判断 0上传supUrl。1上传prescriptionImg）
@property (nonatomic, copy) NSString *billDesc;//复方 和 处方 描述
@property (nonatomic, strong) NSMutableArray *drugImgList;//自己加的的数组
@property (nonatomic, strong) NSMutableDictionary *drugInfo;//处方药药品症状//symptom goodsId

@property (nonatomic, copy) NSString *isConfirm;//是否确认
@property (nonatomic, strong) NSMutableArray<GLPNewShopCarGoodsModel *> *goodsOtcArray;//传值的作用

@end




NS_ASSUME_NONNULL_END
