//
//  GLPEtpCenterBannerCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import "GLPEtpCenterBannerCell.h"

@implementation GLPEtpCenterBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bgView];
    
    _bannerImg = [[UIImageView alloc] init];
    [_bannerImg setImage:[UIImage imageNamed:@"etp_center_banner"]];
    _bannerImg.backgroundColor = [UIColor clearColor];
    _bannerImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_bannerImg];
    
}

#pragma mark - frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(15);
//        make.right.offset(-15);
//        make.top.offset(5);
//        make.height.offset(70);
//    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 15, 0, 15));
    }];
    
    [_bannerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    
    [DCSpeedy dc_changeControlCircularWith:_bannerImg AndSetCornerRadius:_bannerImg.dc_height/2 SetBorderWidth:0 SetBorderColor:[UIColor whiteColor] canMasksToBounds:YES];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
