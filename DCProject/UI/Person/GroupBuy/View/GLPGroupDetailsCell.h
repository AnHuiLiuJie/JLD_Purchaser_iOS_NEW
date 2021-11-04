//
//  GLPGroupDetailsCell.h
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "DCActivityBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLPGroupDetailsCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titileLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *originalLab;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;

@property (nonatomic, strong) DCCollageListModel *model;

@property (nonatomic, copy) void(^GLPGroupDetailsCell_btnBlock)(NSString *btnTitle,DCCollageListModel *model);

@property (nonatomic, strong) DCMyCollageListModel *myModel;


@end

NS_ASSUME_NONNULL_END
