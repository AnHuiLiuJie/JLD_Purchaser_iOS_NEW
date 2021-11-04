//
//  GLPSearchGoodsPromptCell.m
//  DCProject
//
//  Created by Apple on 2021/3/17.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "GLPSearchGoodsPromptCell.h"

@implementation GLPSearchGoodsPromptCell

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
    return self;
}


- (void)setUpUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    self.title = [[UILabel alloc] init];
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.numberOfLines = 2;
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(50);
    }];
    [self.title setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.title setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    self.btnView = [[UIView alloc] init];
//    self.btnView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.btnView];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self.title.right).offset(0);
        make.height.equalTo(50);
    }];
}

- (void)setModel:(GLPSearchKeyModel *)model{
    _model = model;
    [self reloadUI];
}

- (void)reloadUI{
    self.title.attributedText = [self dc_attributeString:_model.key];
    for (UIView *view in self.btnView.subviews) {
        [view removeFromSuperview];
    }
    UIView *old;
    for (int i = 0; i<_model.tag.count; i++) {
        
        
        UIView *view = [[UIView alloc] init];
        view.tag = 100+i;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewMethod:)];
        [view addGestureRecognizer:tap];
        [self.btnView addSubview:view];
        if (old) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(40);
                make.centerY.equalTo(self.btnView);
                make.left.equalTo(old.right);
            }];
        }else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(40);
                make.centerY.equalTo(self.btnView);
                make.left.equalTo(self.btnView);
            }];
        }
        old = view;
        if (i == _model.tag.count - 1) {
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.btnView);
            }];
        }
        
        UIView *ctrl1 = [[UIView alloc] init];
        ctrl1.tag = 100+i;
        ctrl1.backgroundColor = [UIColor dc_colorWithHexString:@"#F4F4F4"];
        ctrl1.layer.masksToBounds = YES;
        ctrl1.layer.cornerRadius = 13;
        ctrl1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewMethod:)];
        [ctrl1 addGestureRecognizer:tap1];
        [view addSubview:ctrl1];
        [ctrl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(26);
            make.centerY.equalTo(self.btnView);
            make.left.equalTo(view).offset(5);
            make.right.equalTo(view).offset(-5);
        }];
        
        GLPSearchKeyTagModel *model = _model.tag[i];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.tag = 100+i;
        lab.text = model.tsh;
        lab.textColor = [UIColor dc_colorWithHexString:@"#131217"];
        lab.font = [UIFont systemFontOfSize:12];
        lab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewMethod:)];
        [lab addGestureRecognizer:tap2];
        [ctrl1 addSubview:lab];
        [lab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ctrl1).offset(11);
            make.right.equalTo(ctrl1).offset(-11);
            make.centerY.equalTo(ctrl1);
        }];

        [lab setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [lab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    
}

- (void)viewMethod:(UITapGestureRecognizer *)tap{
    UIView *ctrl = (UIView *)tap.view;
    if (self.block) {
        GLPSearchKeyTagModel *model = _model.tag[ctrl.tag-100];
        self.block(model.tse);
    }
}

#pragma mark - 返回富文本
- (NSAttributedString *)dc_attributeString:(NSString *)string
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, attStr.length)];
    if (self.titleStr.length > 0 && [string containsString:self.titleStr]) {
        NSString *str = [string componentsSeparatedByString:self.titleStr][0];
        if (str.length + self.titleStr.length <= string.length) {
            [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#AAAAAA"]} range:NSMakeRange(str.length, self.titleStr.length)];
        }
    }
    return attStr;
}

@end
