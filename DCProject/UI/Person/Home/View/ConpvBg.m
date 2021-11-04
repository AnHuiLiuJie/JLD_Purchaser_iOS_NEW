//
//  ConpvBg.m
//  DCProject
//
//  Created by 刘德山 on 2020/9/25.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "ConpvBg.h"
#import "ConpCell.h"
#import "DCHttpClient.h"

@interface ConpvBg ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) UITableView *table;

@end


@implementation ConpvBg
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self UI];
    }
    return self;
}

- (void)UI{
   
    UIButton *bt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:bt];
    [bt setImage:[UIImage imageNamed:@"conp_x"] forState:0];
//    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.offset(0);
//        make.top.mas_equalTo(pic.mas_bottom).offset(20);
//    }];
//    [bt addTarget:self action:@selector(qu) forControlEvents:(UIControlEventTouchUpInside)];
    _table = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _table.rowHeight = 80;
    [self addSubview:_table];
    _table.bounces = NO;
    _table.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3812"];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = 0;
    _table.layer.cornerRadius = 5;
    _table.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    UIImageView *pic = [[UIImageView alloc] init];
    [self addSubview:pic];
    pic.image = [UIImage imageNamed:@"conp_bg"];
    pic.userInteractionEnabled = YES;
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(60);
        make.height.offset(260);
        make.width.offset(320);
    }];
    [pic mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.offset(0);
        make.width.offset(320);
        make.bottom.mas_equalTo(_table.mas_top).offset(5);
        make.height.offset(120);
    }];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.mas_equalTo(_table.mas_bottom).offset(20);
    }];
    [bt addTarget:self action:@selector(qu) forControlEvents:(UIControlEventTouchUpInside)];
//    [self resh];
}

- (void)qu{
    [self removeFromSuperview];
}

- (void)resh{
    
    MJWeakSelf
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/couponsExtend" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] ) {
                weakSelf.data = dict[@"data"][@"coupons"];
            }
            [weakSelf.table reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
        NSString *st = dict[@"data"][@"alert"] ;
        if ([st integerValue] == 1) {
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf];
        }
        if (weakSelf.data.count == 3) {
            [weakSelf.table mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(250);
            }];
        }
        if (weakSelf.data.count == 2) {
            [weakSelf.table mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(170);
            }];
        }
        if (weakSelf.data.count == 1) {
            [weakSelf.table mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(90);
            }];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ider = @"conp";
    ConpCell *Cell = [tableView dequeueReusableCellWithIdentifier:ider];
    if (!Cell) {
        Cell = [[ConpCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ider];
    }
    Cell.dic = _data[indexPath.row];
    return Cell;
}

@end
