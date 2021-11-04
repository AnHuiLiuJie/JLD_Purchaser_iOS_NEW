//
//  GLBNotGoodsHeaderView.m
//  DCProject
//
//  Created by LiuMac on 2021/6/25.
//

#import "GLBNotGoodsHeaderView.h"

@interface GLBNotGoodsHeaderView ()

@property (nonatomic,strong) UIView *nodataView;


@end

@implementation GLBNotGoodsHeaderView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.nodataView.hidden = NO;
    }
    return self;
}

- (UIView *)nodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc] init];
        _nodataView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_nodataView];
        [_nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.mas_equalTo(self.mas_top).offset(0);
        }];
        UILabel *la = [[UILabel alloc] init];
        la.text = @"抱歉！没有找到相关的商品";
        la.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        la.textColor = [UIColor dc_colorWithHexString:@"#A2A2A2"];
        [_nodataView addSubview:la];
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.centerX.offset(0);
        }];
        
        UIButton *bt = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [bt setTitle:@"" forState:0];
        [bt setTitleColor:[UIColor dc_colorWithHexString:DC_BtnColor] forState:0];
        bt.titleLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
        bt.layer.cornerRadius = 15;
        bt.layer.borderWidth = 0.5;
        bt.layer.borderColor = [UIColor dc_colorWithHexString:DC_BtnColor].CGColor;
        [_nodataView addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.height.offset(0);
            make.width.offset(160);
            make.top.mas_equalTo(la.mas_bottom).offset(20);
        }];
        //[bt addTarget:self action:@selector(addMoreGoodsAction) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIImageView *titleImage = [[UIImageView alloc] init];
        titleImage.image = [UIImage imageNamed:@"dc_dprx2"];
        [self addSubview:titleImage];
        
        [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.height.offset(28);
            make.width.offset(125);
            make.top.mas_equalTo(bt.mas_bottom).offset(10);
        }];
    }
    return _nodataView;
}

- (void)addMoreGoodsAction{
    !_GLBNotGoodsHeaderView_block ? : _GLBNotGoodsHeaderView_block();
}

@end
