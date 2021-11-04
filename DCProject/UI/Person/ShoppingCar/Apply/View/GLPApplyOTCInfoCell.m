//
//  GLPApplyOTCInfoCell.m
//  DCProject
//
//  Created by Apple on 2021/3/25.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "GLPApplyOTCInfoCell.h"

@interface GLPApplyOTCInfoCell ()

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLab;

//@property (nonatomic, strong) UIImageView *topLineImg;

@end

@implementation GLPApplyOTCInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}


- (void)setUpUI
{
//    self.topLineImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dc_cell1_line"]];
//    [self.contentView addSubview:self.topLineImg];
//    [self.topLineImg mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.contentView);
//        make.height.width.equalTo(5);
//    }];
    
    self.noInfo = [[UIView alloc] init];
    [self.contentView addSubview:self.noInfo];
    [self.noInfo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(66).priorityHigh();
//        make.edges.equalTo(self.contentView).offset(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.height.equalTo(66+20).priorityHigh();
    }];
    
    self.tipView = [[UIView alloc] init];
    self.tipView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    [self.contentView addSubview:self.tipView];
    [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noInfo.bottom);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(25).priorityHigh();
    }];
    self.tipLab = [[UILabel alloc] init];
    [self.tipView addSubview:self.tipLab];
    self.tipLab.text = @"根据GSP相关规定，药品一经售出，无质量问题不退不换。";
    self.tipLab.textColor = [UIColor dc_colorWithHexString:@"#898989"];
    self.tipLab.font = [UIFont fontWithName:PFR size:12];
    [self.tipLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tipView).offset(UIEdgeInsetsMake(7, 12, 0, 10));
    }];
    
    
    self.titleLb = [[UILabel alloc] init];
    [self.noInfo addSubview:self.titleLb];
    self.titleLb.text = @"请填写就诊信息";
    self.titleLb.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    self.titleLb.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noInfo).offset(15);
        make.left.equalTo(self.noInfo.left).offset(15);
        make.height.equalTo(20);
    }];
    
    self.descLb = [[UILabel alloc] init];
    [self.noInfo addSubview:self.descLb];
    self.descLb.text = @"医生将根据您的就诊信息提供问诊服务";
    self.descLb.textColor = [UIColor dc_colorWithHexString:@"#9C9C9C"];
    self.descLb.font = [UIFont systemFontOfSize:14];
    [self.descLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.bottom).offset(5);
        make.left.equalTo(self.noInfo.left).offset(15);
        make.height.equalTo(16);
    }];
    
    self.iconR = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dc_arrow_right_cuhei"]];
    [self.noInfo addSubview:self.iconR];
    [self.iconR mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.noInfo).offset(-15);
        make.centerY.equalTo(self.noInfo.centerY);
        make.size.equalTo(CGSizeMake(6, 11));
    }];
    
    self.rightLb = [[UILabel alloc] init];
    [self.noInfo addSubview:self.rightLb];
    self.rightLb.text = @"";
    self.rightLb.textColor = [UIColor dc_colorWithHexString:@"#9C9C9C"];
    self.rightLb.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    [self.rightLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLb.centerY);
        make.left.equalTo(self.titleLb.right).offset(10);
    }];
}

- (void)setModel:(MedicalPersListModel *)model{
    _model = model;
    
    if (_model.drugId.length != 0) {
        self.titleLb.text = @"已添加就诊信息";
        NSString *xinbie = @"男";
        if ([model.patientGender isEqualToString:@"2"]) {
            xinbie = @"女";
        }

        NSString *tel = model.patientTel;
        if (model.patientTel.length > 4) {
            tel = [NSString stringWithFormat:@"%@ **** %@",[model.patientTel substringToIndex:3],[model.patientTel substringFromIndex:model.patientTel.length-4]];
        }
        self.rightLb.text = [NSString stringWithFormat:@"%@:%@ %@岁 %@",model.patientName,xinbie,model.patientAge,tel];

    }else{
        self.titleLb.text = @"请填写就诊信息";
        self.rightLb.text = @"";
    }
}


@end
