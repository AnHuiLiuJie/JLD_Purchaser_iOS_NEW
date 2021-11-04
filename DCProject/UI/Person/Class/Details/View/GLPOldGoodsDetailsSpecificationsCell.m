//
//  GLPOldGoodsDetailsSpecificationsCell.m
//  DCProject
//
//  Created by Apple on 2021/3/19.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "GLPOldGoodsDetailsSpecificationsCell.h"

@implementation GLPOldGoodsDetailsSpecificationsCell

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
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo(54);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.text = @"规格";
    self.titleLB.font = [UIFont systemFontOfSize:16];
    self.titleLB.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    [bgView addSubview:self.titleLB];
    [self.titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(15);
        make.top.bottom.equalTo(bgView);
        make.width.equalTo(70);
    }];
    
    self.detailLB = [[UILabel alloc] init];
    self.detailLB.text = @"请选择商品规格分类";
    self.detailLB.font = [UIFont systemFontOfSize:12];
    self.detailLB.textColor = [UIColor dc_colorWithHexString:@"#8E8E8E"];
    [bgView addSubview:self.detailLB];
    [self.detailLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.right).offset(5);
        make.top.bottom.equalTo(bgView);
        make.right.equalTo(bgView).offset(-40);
    }];
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dc_arrow_right_xihui"]];
    [bgView addSubview:img];
    [img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(8, 14));
        make.right.equalTo(bgView).offset(-15);
        make.centerY.equalTo(bgView);
    }];
}

- (void)setSpecificationsStr:(NSString *)specificationsStr{
    _specificationsStr = specificationsStr;
    if (specificationsStr && specificationsStr.length > 0) {
        self.titleLB.text = @"已选规格";
        self.detailLB.text = specificationsStr;
        self.detailLB.font = [UIFont systemFontOfSize:15];
        self.detailLB.textColor = [UIColor dc_colorWithHexString:@"#4D4D4D"];
    }else{
        self.titleLB.text = @"请选规格";
        self.detailLB.text = @"请选择商品规格分类";
        self.detailLB.font = [UIFont systemFontOfSize:12];
        self.detailLB.textColor = [UIColor dc_colorWithHexString:@"#8E8E8E"];
    }
}

@end
