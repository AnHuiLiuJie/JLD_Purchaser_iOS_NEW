//
//  NewsInformationModel.h
//  DCProject
//
//  Created by 赤道 on 2021/4/22.
//

#import "DCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsInformationModel : DCBaseModel

@property (nonatomic, copy) NSString *tabId;
@property (nonatomic, copy) NSString *tabName;

@end

#pragma mark - 创业学院
@interface PioneerCollegeListModel : DCBaseModel

@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsImg;
@property (nonatomic, copy) NSString *isRecmed;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *accessCount;
@property (nonatomic, copy) NSString *newsContent;
@property (nonatomic, copy) NSString *isTop;
@property (nonatomic, copy) NSString *introduction;


@end


NS_ASSUME_NONNULL_END
