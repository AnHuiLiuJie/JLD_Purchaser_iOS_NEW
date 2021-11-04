//
//  EtpPioneerCollegeListCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/19.
//

#import <UIKit/UIKit.h>
#import "NewsInformationModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface EtpPioneerCollegeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auttor_X_LayoutConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtn_W_LayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UILabel *authorLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) PioneerCollegeListModel *model;

@end

NS_ASSUME_NONNULL_END
