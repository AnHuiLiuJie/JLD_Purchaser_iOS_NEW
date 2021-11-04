//
//  GLPHomeTypeCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeTypeCell.h"

@interface GLPHomeTypeCell ()

@property (nonatomic, strong) UIView *hotView;
@property (nonatomic, strong) UIView *classView;
@property (nonatomic, strong) UIView *ticketView;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIImageView *hotImage;
@property (nonatomic, strong) UIImageView *classImage;
@property (nonatomic, strong) UIImageView *ticketImage;
@property (nonatomic, strong) UIImageView *activityImage;
@property (nonatomic, strong) UILabel *hotLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *ticketLabel;
@property (nonatomic, strong) UILabel *activityLabel;
@property (nonatomic, strong) UIImageView *hotTipImage;
@property (nonatomic, strong) UIImageView *ticketTipImage;

@end

@implementation GLPHomeTypeCell

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

    _hotView = [[UIView alloc] init];
    _hotView.tag = 300;
    [self.contentView addSubview:_hotView];
    
    _classView = [[UIView alloc] init];
    _classView.tag = 301;
    [self.contentView addSubview:_classView];
    
    _ticketView = [[UIView alloc] init];
    _ticketView.tag = 302;
    [self.contentView addSubview:_ticketView];
    
    _activityView = [[UIView alloc] init];
    _activityView.tag = 303;
    [self.contentView addSubview:_activityView];
    
    _hotImage = [[UIImageView alloc] init];
    _hotImage.image = [UIImage imageNamed:@"home_rexiao"];
    [_hotView addSubview:_hotImage];
    
    _classImage = [[UIImageView alloc] init];
    _classImage.image = [UIImage imageNamed:@"yaifenl"];
    [_classView addSubview:_classImage];
    
    _ticketImage = [[UIImageView alloc] init];
    _ticketImage.image = [UIImage imageNamed:@"lingquan"];
    [_ticketView addSubview:_ticketImage];
    
    _activityImage = [[UIImageView alloc] init];
    _activityImage.image = [UIImage imageNamed:@"huodong"];
    [_activityView addSubview:_activityImage];
    
    _hotLabel = [[UILabel alloc] init];
    _hotLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _hotLabel.textAlignment = NSTextAlignmentCenter;
    _hotLabel.font = PFRFont(13);
    _hotLabel.text = @"热销商品";
    [_hotView addSubview:_hotLabel];
    
    _classLabel = [[UILabel alloc] init];
    _classLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _classLabel.textAlignment = NSTextAlignmentCenter;
    _classLabel.font = PFRFont(13);
    _classLabel.text = @"商品分类";
    [_classView addSubview:_classLabel];
    
    _ticketLabel = [[UILabel alloc] init];
    _ticketLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _ticketLabel.textAlignment = NSTextAlignmentCenter;
    _ticketLabel.font = PFRFont(13);
    _ticketLabel.text = @"领券中心";
    [_ticketView addSubview:_ticketLabel];
    
    _activityLabel = [[UILabel alloc] init];
    _activityLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _activityLabel.textAlignment = NSTextAlignmentCenter;
    _activityLabel.font = PFRFont(13);
    _activityLabel.text = @"活动专区";
    [_activityView addSubview:_activityLabel];
    
    _hotTipImage = [[UIImageView alloc] init];
    _hotTipImage.image = [UIImage imageNamed:@"ts_remai"];
    [_hotView addSubview:_hotTipImage];
    
    _ticketTipImage = [[UIImageView alloc] init];
    _ticketTipImage.image = [UIImage imageNamed:@"ts_lingquan"];
    [_ticketView addSubview:_ticketTipImage];
    
    _hotView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Action:)];
    [_hotView addGestureRecognizer:tap1];
    
    _classView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Action:)];
    [_classView addGestureRecognizer:tap2];
    
    _ticketView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3Action:)];
    [_ticketView addGestureRecognizer:tap3];
    
    _activityView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap4Action:)];
    [_activityView addGestureRecognizer:tap4];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)tap1Action:(UITapGestureRecognizer *)sender
{
    if (_typeCellBlock) {
        _typeCellBlock(300);
    }
}

- (void)tap2Action:(UITapGestureRecognizer *)sender
{
    if (_typeCellBlock) {
        _typeCellBlock(301);
    }
}

- (void)tap3Action:(UITapGestureRecognizer *)sender
{
    if (_typeCellBlock) {
        _typeCellBlock(302);
    }
}

- (void)tap4Action:(UITapGestureRecognizer *)sender
{
    if (_typeCellBlock) {
        _typeCellBlock(303);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = 75;
    CGFloat width = 50;
    
    CGFloat spacing = (kScreenW - 20*2 - width*4)/3;
    
    [_hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(20);
        make.top.equalTo(self.contentView.top).offset(20);
        make.size.equalTo(CGSizeMake(width, height));
//        make.bottom.equalTo(self.contentView.bottom).offset(-20);//lj_change_约束
    }];
    
    [_classView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hotView.centerY);
        make.left.equalTo(self.hotView.right).offset(spacing);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hotView.centerY);
        make.left.equalTo(self.classView.right).offset(spacing);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hotView.centerY);
        make.left.equalTo(self.ticketView.right).offset(spacing);
        make.size.equalTo(CGSizeMake(width, height));
    }];
    
    [_hotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotView.left);
        make.right.equalTo(self.hotView.right);
        make.top.equalTo(self.hotView.top);
        make.height.equalTo(width);
    }];
    
    [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hotView.centerX);
        make.bottom.equalTo(self.hotView.bottom);
    }];
    
    [_hotTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hotView.top);
        make.left.equalTo(self.hotView.centerX).offset(10);
        make.size.equalTo(CGSizeMake(33, 16));
    }];
    
    [_classImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classView.left);
        make.right.equalTo(self.classView.right);
        make.top.equalTo(self.classView.top);
        make.height.equalTo(width);
    }];
    
    [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.classView.centerX);
        make.bottom.equalTo(self.classView.bottom);
    }];
    
    [_ticketImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ticketView.left);
        make.right.equalTo(self.ticketView.right);
        make.top.equalTo(self.ticketView.top);
        make.height.equalTo(width);
    }];
    
    [_ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ticketView.centerX);
        make.bottom.equalTo(self.ticketView.bottom);
    }];
    
    [_ticketTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ticketView.top);
        make.left.equalTo(self.ticketView.centerX).offset(10);
        make.size.equalTo(CGSizeMake(33, 16));
    }];
    
    [_activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.activityView.left);
        make.right.equalTo(self.activityView.right);
        make.top.equalTo(self.activityView.top);
        make.height.equalTo(width);
    }];
    
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.activityView.centerX);
        make.bottom.equalTo(self.activityView.bottom);
    }];
}



@end
