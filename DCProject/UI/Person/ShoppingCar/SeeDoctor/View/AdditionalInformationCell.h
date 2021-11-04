//
//  AdditionalInformationCell.h
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import <UIKit/UIKit.h>
#import "YNImageUploadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdditionalInformationCell : UITableViewCell

@property (nonatomic, assign) PrescriptionType showType;
@property (strong, nonatomic) NSMutableArray *urlArr;

@property (copy, nonatomic) NSArray *imgsList;


@property (copy, nonatomic) void(^AdditionalInformationCell_block)(NSArray *urlArr);

@end

NS_ASSUME_NONNULL_END
