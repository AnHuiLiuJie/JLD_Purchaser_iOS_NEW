//
//  GLPGoodsDetailsQuestionCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsQuestionCell.h"

@interface GLPGoodsDetailsQuestionCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIImageView *questionImage1;
@property (nonatomic, strong) UIImageView *questionImage2;
@property (nonatomic, strong) UILabel *questionLabel1;
@property (nonatomic, strong) UILabel *questionLabel2;

@end

@implementation GLPGoodsDetailsQuestionCell

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
    [self.contentView addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.text = @"问答专区";
    [_bgView addSubview:_titleLabel];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setTitle:@"查看全部问答" forState:0];
    [_moreBtn setTitleColor:[UIColor dc_colorWithHexString:@"#A5A4A4"] forState:0];
    _moreBtn.titleLabel.font = PFRFont(14);
    [_moreBtn setImage:[UIImage imageNamed:@"dc_arrow_right_xh"] forState:0];
    _moreBtn.adjustsImageWhenHighlighted = NO;
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _moreBtn.bounds = CGRectMake(0, 0, 100, 30);
    [_moreBtn dc_buttonIconRightWithSpacing:10];
    [_bgView addSubview:_moreBtn];
    
    _questionImage1 = [[UIImageView alloc] init];
    _questionImage1.image = [UIImage imageNamed:@"wenda"];
    _questionImage1.hidden = YES;
    [_bgView addSubview:_questionImage1];
    
    _questionImage2 = [[UIImageView alloc] init];
    _questionImage2.image = [UIImage imageNamed:@"wenda"];
    _questionImage2.hidden = YES;
    [_bgView addSubview:_questionImage2];
    
    _questionLabel1 = [[UILabel alloc] init];
    _questionLabel1.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _questionLabel1.font = [UIFont fontWithName:PFR size:14];
    _questionLabel1.hidden = YES;
    _questionLabel1.text = @"";
    _questionLabel1.numberOfLines = 0;
    [_bgView addSubview:_questionLabel1];
    
    _questionLabel2 = [[UILabel alloc] init];
    _questionLabel2.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _questionLabel2.font = [UIFont fontWithName:PFR size:14];
    _questionLabel2.hidden = YES;
    _questionLabel2.text = @"";
    _questionLabel2.numberOfLines = 0;
    [_bgView addSubview:_questionLabel2];
    
    [self layoutSubviews];

}


#pragma mark - action
- (void)moreBtnClick:(UIButton *)button
{
    if (_questionCellBlock) {
        _questionCellBlock();
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        //make.height.mas_greaterThanOrEqualTo(90+15).priorityHigh();
//        make.height.equalTo(105).priorityHigh();
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.bgView.top).offset(10);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-15);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(100, 35));
    }];
    
    CGFloat itemH = 5;
    if (_questionArray.count != 0) {
        itemH = 18;
    }
    
    [_questionImage1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.titleLabel.bottom).offset(itemH).priorityHigh();
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_questionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionImage1.right).offset(10);
        make.right.equalTo(self.bgView.right).offset(-15);
        make.top.equalTo(self.questionImage1.top).offset(-2);
    }];
    
    [_questionImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.top.equalTo(self.questionLabel1.bottom).offset(5);
        make.size.equalTo(self.questionImage1);
//        make.bottom.equalTo(self.bgView.bottom).offset(-15);
    }];
    
    [_questionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionLabel1.left);
        make.right.equalTo(self.questionLabel1.right);
        make.top.equalTo(self.questionImage2.top).offset(-2);
        make.bottom.equalTo(self.bgView.bottom).priorityHigh().offset(-5);
    }];
    
}


#pragma mark - setter
- (void)setQuestionArray:(NSMutableArray<GLPGoodsQusetionModel *> *)questionArray
{
    _questionArray = questionArray;
    
    _questionImage1.hidden = YES;
    _questionLabel1.hidden = YES;
    _questionImage2.hidden = YES;
    _questionLabel2.hidden = YES;
    
    if (_questionArray.count > 0) {
        _titleLabel.text = @"问答专区";
        _moreBtn.hidden = NO;
        
        for (int i=0; i<_questionArray.count; i++) {
            GLPGoodsQusetionModel *questionModel = _questionArray[i];
            
            if (i == 0) {
                _questionImage1.hidden = NO;
                _questionLabel1.hidden = NO;
                
                _questionLabel1.text = questionModel.questionContent;
            }
            if (i == 1) {
                _questionImage2.hidden = NO;
                _questionLabel2.hidden = NO;
                
                _questionLabel2.text = questionModel.questionContent;
            }
        }
    }else{
        _titleLabel.text = @"暂无问答";
        _moreBtn.hidden = YES;
    }
}


@end
