//
//  GLPActivityAreaListCell.m
//  DCProject
//
//  Created by LiuMac on 2021/8/10.
//

#import "GLPActivityAreaListCell.h"

@implementation GLPActivityAreaListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewUI];
}

- (void)setViewUI{
    [_bugView dc_cornerRadius:5];
    
    [_buyBtn1 addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBtn2 addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark actiom
- (void)buyAction:(UIButton *)button{
    !_GLPActivityAreaListCell_block ? : _GLPActivityAreaListCell_block(_model.goodsId);
}

#pragma mark -set
- (void)setModel:(ActivityAreaGoodsVOModel *)model{
    _model = model;
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goodsImg1] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.titleLab.text = [NSString stringWithFormat:@"%@",model.goodsName];
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.sellPrice floatValue]];
    self.priceLab = [UILabel setupAttributeLabel:self.priceLab textColor:nil minFont:[UIFont fontWithName:PFR size:15] maxFont:[UIFont fontWithName:PFRMedium size:19] forReplace:@"¥"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
