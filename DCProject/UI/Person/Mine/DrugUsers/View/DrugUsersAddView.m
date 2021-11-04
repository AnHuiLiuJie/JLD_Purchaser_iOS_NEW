//
//  DrugUsersAddView.m
//  DCProject
//
//  Created by Apple on 2021/3/18.
//  Copyright © 2021 bigbing. All rights reserved.
//

#import "DrugUsersAddView.h"

@implementation DrugUsersAddView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
//
//    UIView *footView = [[UIView alloc] init];
//    footView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:footView];
//    [footView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(self.view);
//        make.height.equalTo(70);
//    }];
//
//    UIButton *addBtn = [[UIButton alloc] init];
//    [addBtn addTarget:self action:@selector(addBtnMethod) forControlEvents:UIControlEventTouchUpInside];
//    [addBtn setTitle:@"添加用药人" forState:0];
//    [addBtn setTitleColor:[UIColor whiteColor] forState:0];
//    addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    addBtn.layer.masksToBounds = YES;
//    addBtn.layer.cornerRadius = 25;
//    addBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
//    [footView addSubview:addBtn];
//    [addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(footView).offset(UIEdgeInsetsMake(10, 30, 10, 30));
//    }];
//
//
//    UIView *headView = [[UIView alloc] init];
//    headView.backgroundColor = [UIColor dc_colorWithHexString:@"#FFFADC"];
//    [self.view addSubview:headView];
//    [headView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(0);
//        make.left.right.equalTo(self);
//        make.height.equalTo(54);
//    }];
//
//    UILabel *headLab = [[UILabel alloc] init];
//    headLab.text = @"根据国家药监局规定,购买处方药需要实名认证  根据国家药监局规定,购买处方药需要实名认证";
//    headLab.textColor = [UIColor dc_colorWithHexString:@"#131217"];
//    headLab.numberOfLines = 0;
//    headLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//    [headView addSubview:headLab];
//    [headLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(headView).offset(UIEdgeInsetsMake(6, 15, 6, 15));
//    }];
//
//    UIButton *btn = [[UIButton alloc] init];
//    [btn addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:@"取消" forState:0];
//    [btn setTitleColor:[UIColor dc_colorWithHexString:@"#828188"] forState:0];
//    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [headView addSubview:btn];
//    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(headView).offset(15);
//        make.top.equalTo(headView).offset(5);
//        make.size.equalTo(CGSizeMake(52, 44));
//    }];
//
//    self.gwbs = [[DrugUsersAddViewItem alloc] init];
//    [self addSubview:self.gwbs];
//    [self.gwbs mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headView.bottom);
//        make.left.right.equalTo(self);
//        make.height.equalTo(50);
//    }];
//
//    self.scrollView = [[UIScrollView alloc] init];
//    [self addSubview:self.scrollView];
//    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.gwbs.bottom);
//        make.left.right.equalTo(self);
//        make.height.equalTo(50);
//    }];
//
//    self.gms = [[DrugUsersAddViewItem alloc] init];
//    [self addSubview:self.gms];
//    [self.gms mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollView.bottom);
//        make.left.right.equalTo(self);
//        make.height.equalTo(50);
//    }];
//
//    self.jzbs = [[DrugUsersAddViewItem alloc] init];
//    [self addSubview:self.jzbs];
//    [self.jzbs mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.gms.bottom);
//        make.left.right.equalTo(self);
//        make.height.equalTo(50);
//    }];
//
//    self.ggn = [[DrugUsersAddViewItem alloc] init];
//    [self addSubview:self.ggn];
//    [self.ggn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.jzbs.bottom);
//        make.left.right.equalTo(self);
//        make.height.equalTo(50);
//    }];
//
//    self.sgn = [[DrugUsersAddViewItem alloc] init];
//    [self addSubview:self.sgn];
//    [self.sgn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.ggn.bottom);
//        make.left.right.equalTo(self);
//        make.height.equalTo(50);
//    }];
//
//    self.rcbr = [[DrugUsersAddViewItem alloc] init];
//    [self addSubview:self.rcbr];
//    [self.rcbr mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.sgn.bottom);
//        make.left.right.equalTo(self);
//        make.height.equalTo(50);
//        make.bottom.equalTo(footView.top);
//    }];
    
}

- (void)reloadScrollView{
    
}

- (void)addBtnMethod{
    
}

- (void)cancelMethod{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0];
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    } completion:^(BOOL finished) {
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation DrugUsersAddViewItem

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.frame = CGRectMake(0, 0, kScreenW, 50);
    
    //性别
    UILabel *genderLB = [[UILabel alloc] init];
    genderLB.text = @"性别";
    genderLB.font = [UIFont systemFontOfSize:16];
    genderLB.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    genderLB.backgroundColor = [UIColor redColor];
    [self addSubview:genderLB];
    [genderLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(50);
        make.width.equalTo(120);
    }];
    
    self.btn1 = [[UIButton alloc] init];
    [self.btn1 setImage:[UIImage imageNamed:@"yyrweixuan"] forState:0];
    [self.btn1 setImage:[UIImage imageNamed:@"yyrxuanz"] forState:UIControlStateSelected];
    [self.btn1 setTitle:@"  女" forState:0];
    [self.btn1 setTitleColor:[UIColor dc_colorWithHexString:@"#131217"] forState:0];
    [self.btn1 addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn1];
    [self.btn1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(50);
        make.right.equalTo(self.right).offset(-15);
    }];
    
    self.btn2 = [[UIButton alloc] init];
    [self.btn2 setImage:[UIImage imageNamed:@"yyrweixuan"] forState:0];
    [self.btn2 setImage:[UIImage imageNamed:@"yyrxuanz"] forState:UIControlStateSelected];
    [self.btn2 setTitle:@"  男" forState:0];
    [self.btn2 setTitleColor:[UIColor dc_colorWithHexString:@"#131217"] forState:0];
    [self.btn2 addTarget:self action:@selector(btnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn2];
    [self.btn2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(50);
        make.right.equalTo(self).offset(-10);
    }];
    
    UIView *genderview = [[UIView alloc] init];
    genderview.backgroundColor = [UIColor dc_colorWithHexString:@"#EEEEEE"];
    [self addSubview:genderview];
    [genderview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.size.equalTo(CGSizeMake(kScreenW-15, 1));
    }];
}

- (void)btnMethod:(UIButton *)button{
    
}

@end
