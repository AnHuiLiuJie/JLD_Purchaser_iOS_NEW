//
//  PatientRelationshipCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/8.
//

#import "PatientRelationshipCell.h"

@interface PatientRelationshipCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@property (weak, nonatomic) IBOutlet UISwitch *isDefaultSwitch;


@end

@implementation PatientRelationshipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewUI];
}

- (void)setViewUI
{
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:5 SetBorderWidth:0 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    
    self.specIdx = 0;
    
    NSArray *titleArr = @[@"本人",@"家属",@"亲戚",@"朋友"];
    CGFloat btn_w = 49;
    CGFloat btn_h = 24;
    CGFloat spacing = (kScreenW-2*10-110-4*btn_w)/4;

    NSInteger tag = 100;
    for (int i=0 ; i<titleArr.count; i++) {
        NSString *title = titleArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.tag = tag+i;
        btn.titleLabel.font = [UIFont fontWithName:PFR size:12];
        [btn setTitleColor:[UIColor dc_colorWithHexString:@"#A7A7A7"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectBtn_Action:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(100+i*(spacing+btn_w), (self.btnBgView.dc_height-btn_h)/2, btn_w, btn_h);
        if (self.specIdx == i) {
            btn.selected = YES;
            [DCSpeedy dc_changeControlCircularWith:btn AndSetCornerRadius:btn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
        }else{
            btn.selected = NO;
            [DCSpeedy dc_changeControlCircularWith:btn AndSetCornerRadius:btn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#A7A7A7"] canMasksToBounds:YES];
        }

        [self.btnBgView addSubview:btn];
    }
    
    [_isDefaultSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];


}

- (void)switchClick:(UISwitch *)isDefaultSwitch
{
    if (isDefaultSwitch.on==YES)
    {
        self.model.isDefault = @"1";
    }
    else{
        self.model.isDefault = @"2";
    }
    !_PatientRelationshipCell_block ? : _PatientRelationshipCell_block(self.model);
}

#pragma set
- (void)setModel:(MedicalPersListModel *)model{
    _model = model;
    
    if ([model.isDefault isEqualToString:@"1"])
    {
        [_isDefaultSwitch setOn:YES];
    }
    else{
         [_isDefaultSwitch setOn:NO];
    }
    
    if ([model.relation isEqualToString:@"1"]) {
        self.specIdx = 0;
    }else if([model.relation isEqualToString:@"2"]) {
        self.specIdx = 1;
    }else if([model.relation isEqualToString:@"3"]) {
        self.specIdx = 2;
    }else if([model.relation isEqualToString:@"4"]) {
        self.specIdx = 3;
    }else{
        self.specIdx = 0;
    }
    
    
    for (UIView *btn in self.btnBgView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (self.specIdx+100 == btn.tag) {
                ((UIButton *)btn).selected = YES;
                [DCSpeedy dc_changeControlCircularWith:btn AndSetCornerRadius:btn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:DC_BtnColor] canMasksToBounds:YES];
            }else{
                ((UIButton *)btn).selected = NO;
                [DCSpeedy dc_changeControlCircularWith:btn AndSetCornerRadius:btn.dc_height/2 SetBorderWidth:1 SetBorderColor:[UIColor dc_colorWithHexString:@"#A7A7A7"] canMasksToBounds:YES];
            }
        }
    }
    
}

#pragma mark
- (void)selectBtn_Action:(UIButton *)selectBtn{
    
    selectBtn.selected = !selectBtn.selected;
    for (UIView *btn in self.btnBgView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.layer.borderColor = btn.tag == selectBtn.tag ? [UIColor dc_colorWithHexString:DC_BtnColor].CGColor : [UIColor dc_colorWithHexString:@"#AFB1B1"].CGColor;
            ((UIButton *)btn).selected = btn.tag == selectBtn.tag;
        }
    }
    self.specIdx = selectBtn.tag - 100;
    self.model.relation = [NSString stringWithFormat:@"%ld",self.specIdx+1];
    !_PatientRelationshipCell_block ? : _PatientRelationshipCell_block(self.model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
