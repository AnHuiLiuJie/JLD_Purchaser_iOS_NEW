//
//  DrugUsersCell.m
//  DCProject
//
//  Created by Apple on 2021/3/17.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "DrugUsersCell.h"

@implementation DrugUsersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI{
    UIView *cview = [[UIView alloc] init];
    cview.backgroundColor = [UIColor whiteColor];
    cview.layer.cornerRadius = 9;
    cview.layer.shadowColor = [UIColor colorWithRed:197/255.0 green:193/255.0 blue:193/255.0 alpha:0.5].CGColor;
    cview.layer.shadowOffset = CGSizeMake(0,2);
    cview.layer.shadowOpacity = 1;
    cview.layer.shadowRadius = 6;
    [self addSubview:cview];
    [cview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).offset(UIEdgeInsetsMake(10, 15, 10, 15));
        make.height.equalTo(117);
    }];
    
    self.nameLB = [[UILabel alloc] init];
    self.nameLB.text = @"李泪花";
    self.nameLB.font = [UIFont systemFontOfSize:18];
    self.nameLB.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [cview addSubview:self.nameLB];
    [self.nameLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(cview).offset(14);
        make.height.equalTo(25);
    }];

    self.sexLB = [[UILabel alloc] init];
    self.sexLB.text = @"男";
    self.sexLB.font = [UIFont systemFontOfSize:13];
    self.sexLB.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [cview addSubview:self.sexLB];
    [self.sexLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB);
        make.left.equalTo(self.nameLB.right).offset(15);
        make.height.equalTo(25);
    }];
    
    self.ageLB = [[UILabel alloc] init];
    self.ageLB.text = @"53岁";
    self.ageLB.font = [UIFont systemFontOfSize:13];
    self.ageLB.textColor = [UIColor dc_colorWithHexString:@"#131217"];
    [cview addSubview:self.ageLB];
    [self.ageLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexLB);
        make.left.equalTo(self.sexLB.right).offset(15);
        make.height.equalTo(25);
    }];
    
    self.phoneLB = [[UILabel alloc] init];
    self.phoneLB.text = @"18715083417";
    self.phoneLB.font = [UIFont systemFontOfSize:13];
    self.phoneLB.textColor = [UIColor dc_colorWithHexString:@"#848485"];
    [cview addSubview:self.phoneLB];
    [self.phoneLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.bottom).offset(16);
        make.left.equalTo(self.nameLB);
        make.height.equalTo(18);
    }];
    
    self.editBtn = [[UIButton alloc] init];
    [self.editBtn setTitle:@"编辑" forState:0];
    [self.deleteBtn addTarget:self action:@selector(editBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.editBtn setTitleColor:[UIColor dc_colorWithHexString:@"#848485"] forState:0];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cview addSubview:self.editBtn];
    [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cview);
        make.height.equalTo(cview).offset(4);
        make.size.equalTo(CGSizeMake(46, 45));
    }];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setTitle:@"删除" forState:0];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setTitleColor:[UIColor dc_colorWithHexString:@"#848485"] forState:0];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cview addSubview:self.deleteBtn];
    [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editBtn.left);
        make.height.equalTo(cview).offset(4);
        make.size.equalTo(CGSizeMake(46, 45));
    }];
}

- (void)editBtnMethod{
    if (self.block) {
        self.block(self.idx, 1);
    }
}

- (void)deleteBtnMethod{
    if (self.block) {
        self.block(self.idx, 2);
    }
}

@end
