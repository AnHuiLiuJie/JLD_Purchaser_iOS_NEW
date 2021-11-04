//
//  GLPGoodsDetailsEvaluateCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsEvaluateCell.h"

@interface GLPGoodsDetailsEvaluateCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *evaluateImage;
@property (nonatomic, strong) GLPGoodsDetailsEvaluateGradeView *gradeView;
@property (nonatomic, strong) UIImageView *line;

@end

@implementation GLPGoodsDetailsEvaluateCell

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
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:19];
    [self.contentView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor dc_colorWithHexString:@"#434343"];
    _nameLabel.font = PFRFont(12);
    _nameLabel.text = @"";
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor dc_colorWithHexString:@"#A8A8A8"];
    _timeLabel.font = PFRFont(12);
    _timeLabel.text = @"";
    [self.contentView addSubview:_timeLabel];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _descLabel.font = PFRFont(14);
    _descLabel.numberOfLines = 0;
    _descLabel.text = @"";
    [self.contentView addSubview:_descLabel];
    
    _evaluateImage = [[UIImageView alloc] init];
    _evaluateImage.contentMode = UIViewContentModeScaleAspectFill;
    [_evaluateImage dc_cornerRadius:5];
    _evaluateImage.hidden = YES;
    [self.contentView addSubview:_evaluateImage];
    
    _gradeView = [[GLPGoodsDetailsEvaluateGradeView alloc] init];
    _gradeView.grade = 0;
    [self.contentView addSubview:_gradeView];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    [self updateMasonry];
}


- (void)updateMasonry {
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top).offset(15);
        make.size.equalTo(CGSizeMake(38, 38));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.top.equalTo(self.iconImage.top);
    }];
    
    [_gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.nameLabel.centerY);
        make.size.equalTo(CGSizeMake(105, 18));
        make.left.equalTo(self.nameLabel.right);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.bottom.equalTo(self.iconImage.bottom);
    }];
    
    if (_evaluateImage.hidden) {
        
        [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.gradeView.right);
            make.top.equalTo(self.iconImage.bottom).offset(10);
            make.bottom.equalTo(self.contentView.bottom).offset(-20);
        }];
        
    } else {
        
        [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.right.equalTo(self.gradeView.right);
            make.top.equalTo(self.iconImage.bottom).offset(10);
        }];
        
        [_evaluateImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.left);
            make.top.equalTo(self.descLabel.bottom).offset(7);
            make.size.equalTo(CGSizeMake(132, 132));
            make.bottom.equalTo(self.contentView.bottom).offset(-20);
        }];
    }
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(14);
        make.right.equalTo(self.contentView.right).offset(-14);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(1);
    }];
}


#pragma mark - setter
- (void)setListModel:(GLPGoodsEvaluateListModel *)listModel
{
    _listModel = listModel;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_listModel.userImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *name = _listModel.buyerNickname;
    if (!name || name.length == 0) {
        name = @"***";
    }
    _nameLabel.text = name;
    
    NSString *time = _listModel.createTime;
    if ([time containsString:@" "]) {
        time = [time componentsSeparatedByString:@" "][0];
    }
    _timeLabel.text = time;
    
    _descLabel.text = _listModel.evalContent;
    _gradeView.grade = _listModel.star;
    
    NSString *imgUrl = _listModel.evalImgs;
    if ([imgUrl containsString:@","]) {
        imgUrl = [imgUrl componentsSeparatedByString:@","][0];
    }
    
    if (imgUrl.length > 0) {
        _evaluateImage.hidden = NO;
        [_evaluateImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    } else {
         _evaluateImage.hidden = YES;
    }
    
    [self updateMasonry];
}

@end



#pragma mark - 评价的星级
@interface GLPGoodsDetailsEvaluateGradeView ()

@property (nonatomic, strong) UIImageView *gradeImage1;
@property (nonatomic, strong) UIImageView *gradeImage2;
@property (nonatomic, strong) UIImageView *gradeImage3;
@property (nonatomic, strong) UIImageView *gradeImage4;
@property (nonatomic, strong) UIImageView *gradeImage5;

@end

@implementation GLPGoodsDetailsEvaluateGradeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _gradeImage1 = [[UIImageView alloc] init];
    _gradeImage1.image = [UIImage imageNamed:@"xing"];
    [self addSubview:_gradeImage1];
    
    _gradeImage2 = [[UIImageView alloc] init];
    _gradeImage2.image = [UIImage imageNamed:@"xing"];
    [self addSubview:_gradeImage2];
    
    _gradeImage3 = [[UIImageView alloc] init];
    _gradeImage3.image = [UIImage imageNamed:@"xing"];
    [self addSubview:_gradeImage3];
    
    _gradeImage4 = [[UIImageView alloc] init];
    _gradeImage4.image = [UIImage imageNamed:@"xing"];
    [self addSubview:_gradeImage4];
    
    _gradeImage5 = [[UIImageView alloc] init];
    _gradeImage5.image = [UIImage imageNamed:@"xing"];
    [self addSubview:_gradeImage5];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_gradeImage5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(17, 17));
    }];
    
    [_gradeImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gradeImage5.left).offset(-4);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(self.gradeImage5.width);
        make.height.equalTo(self.gradeImage5.height);
    }];
    
    [_gradeImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gradeImage4.left).offset(-4);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(self.gradeImage5.width);
        make.height.equalTo(self.gradeImage5.height);
    }];
    
    [_gradeImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gradeImage3.left).offset(-4);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(self.gradeImage5.width);
        make.height.equalTo(self.gradeImage5.height);
    }];
    
    [_gradeImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.gradeImage2.left).offset(-4);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(self.gradeImage5.width);
        make.height.equalTo(self.gradeImage5.height);
    }];
}


#pragma mark - setter
- (void)setGrade:(NSInteger)grade
{
    _grade = grade;
    
    if (_grade == 0) {
        
         _gradeImage1.image = [UIImage imageNamed:@"xing"];
         _gradeImage2.image = [UIImage imageNamed:@"xing"];
         _gradeImage3.image = [UIImage imageNamed:@"xing"];
         _gradeImage4.image = [UIImage imageNamed:@"xing"];
         _gradeImage5.image = [UIImage imageNamed:@"xing"];
        
    } else if (_grade == 1) {
        
        _gradeImage1.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage2.image = [UIImage imageNamed:@"xing"];
        _gradeImage3.image = [UIImage imageNamed:@"xing"];
        _gradeImage4.image = [UIImage imageNamed:@"xing"];
        _gradeImage5.image = [UIImage imageNamed:@"xing"];
        
    } else if (_grade == 2) {
        
        _gradeImage1.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage2.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage3.image = [UIImage imageNamed:@"xing"];
        _gradeImage4.image = [UIImage imageNamed:@"xing"];
        _gradeImage5.image = [UIImage imageNamed:@"xing"];
        
    } else if (_grade == 3) {
        
        _gradeImage1.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage2.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage3.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage4.image = [UIImage imageNamed:@"xing"];
        _gradeImage5.image = [UIImage imageNamed:@"xing"];
        
    } else if (_grade == 4) {
        
        _gradeImage1.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage2.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage3.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage4.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage5.image = [UIImage imageNamed:@"xing"];
        
    } else if (_grade == 5) {
        
        _gradeImage1.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage2.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage3.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage4.image = [UIImage imageNamed:@"xingxing"];
        _gradeImage5.image = [UIImage imageNamed:@"xingxing"];
    }
}

@end
