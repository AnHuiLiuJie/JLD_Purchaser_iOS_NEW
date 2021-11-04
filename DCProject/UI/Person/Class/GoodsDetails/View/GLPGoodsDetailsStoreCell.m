//
//  GLPDetailsStoreCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/29.
//

#import "GLPGoodsDetailsStoreCell.h"

@interface GLPGoodsDetailsStoreCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *careCountLabel;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation GLPGoodsDetailsStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    [self.contentView  addSubview:_bgView];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:20];
    [_bgView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _nameLabel.text = @"";
    _nameLabel.font = [UIFont fontWithName:PFRMedium size:16];
    [_bgView addSubview:_nameLabel];
    
    _careCountLabel = [[UILabel alloc] init];
    _careCountLabel.textColor = [UIColor dc_colorWithHexString:@"#AFAFAF"];
    _careCountLabel.text = @"";
    _careCountLabel.font = [UIFont fontWithName:PFRSemibold size:12];
    _careCountLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_careCountLabel];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];//
    [_moreBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xihui"] forState:UIControlStateNormal];//dc_cell_more
    [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_moreBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)moreAction:(UIButton *)button{
    !_GLPGoodsDetailsStoreCell_block ? : _GLPGoodsDetailsStoreCell_block(501);
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        //make.height.mas_greaterThanOrEqualTo(140).priorityHigh();
        make.height.equalTo(80).priorityHigh();
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top).offset(10);
        make.left.equalTo(self.bgView.left).offset(15);
        make.size.equalTo(CGSizeMake(60, 60));
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY).offset(-15);
        make.left.equalTo(self.iconImage.right).offset(10);
    }];

    [_careCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY).offset(15);
        make.left.equalTo(self.nameLabel.left).offset(0);
    }];
    
    [_moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 30));
        make.right.equalTo(self.bgView).offset(-5);
        make.centerY.equalTo(self.bgView);
    }];

}


#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    if (_detailModel && _detailModel.shopInfo) {
        
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:_detailModel.shopInfo.logoImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
        _nameLabel.text = _detailModel.shopInfo.shopName;
        _careCountLabel.text = [NSString stringWithFormat:@"%ld人关注",_detailModel.shopInfo.collectionCount];

    }
}


@end
