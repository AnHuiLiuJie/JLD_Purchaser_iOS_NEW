//
//  OrderMessageListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/28.
//

#import "OrderMessageListCell.h"
@interface OrderMessageListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation OrderMessageListCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:7];
    [self.contentView addSubview:_bgView];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLabel.text = @"";
    _titleLabel.numberOfLines = 0;
    [_bgView addSubview:_titleLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 14, 5, 14));
        make.height.greaterThanOrEqualTo(60).priorityHigh();
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.0f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - set
-(void)setModel:(OrderMessageListModel *)model{
    _model = model;
    
    _titleLabel.text = model.msgContent;
    
}


@end
