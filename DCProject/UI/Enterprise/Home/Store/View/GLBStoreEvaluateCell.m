//
//  GLBStoreEvaluateCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreEvaluateCell.h"
#import "GLBEvaluateGardeView.h"

@interface GLBStoreEvaluateCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GLBEvaluateGardeView *gradeView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GLBStoreEvaluateCell

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
    [_bgView dc_cornerRadius:5];
    [self.contentView addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#666666"];
    _titleLabel.font = PFRFont(13);
    _titleLabel.text = @"";
    [_bgView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _timeLabel.font = PFRFont(12);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = @"";
    [_bgView addSubview:_timeLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#323234"];
    _descLabel.font = PFRFont(12);
    _descLabel.numberOfLines = 0;
    _descLabel.text = @"";
    [_bgView addSubview:_descLabel];
    
    _gradeView = [[GLBEvaluateGardeView alloc] init];
    _gradeView.score = 0;
    [_bgView addSubview:_gradeView];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 0, 10));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.bgView.top).offset(13);
    }];
    
    [_gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.left.equalTo(self.titleLabel.right).offset(10);
        make.size.equalTo(CGSizeMake(200, 18));
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.right.equalTo(self.bgView.right).offset(-100);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.bottom.equalTo(self.bgView.bottom).offset(-12);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-15);
        make.centerY.equalTo(self.bgView.centerY);
    }];
}



#pragma mark - 赋值
- (void)setValueWithModel:(GLBStoreEvaluateModel *)evaluateModel type:(NSInteger)type
{
    _descLabel.text = evaluateModel.purchaser;
    _timeLabel.text = evaluateModel.evalTime;
    _gradeView.score = evaluateModel.star;
    
    if (evaluateModel.star == 5 || evaluateModel.star == 4) {
        _titleLabel.text = @"好评";
    } else if (evaluateModel.star == 3 || evaluateModel.star == 2) {
        _titleLabel.text = @"一般";
    } else {
        _titleLabel.text = @"不满意";
    }
}

@end
