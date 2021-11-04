//
//  ConpCell.m
//  DCProject
//
//  Created by 刘德山 on 2020/9/25.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "ConpCell.h"

@implementation ConpCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self UI];
    }
    
    return self;
}

- (void)UI{
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    bg.layer.cornerRadius = 5;
    bg.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.offset(5);
        make.height.offset(75);
    }];
    UILabel *dan = [[UILabel alloc] init];
    dan.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    dan.text = @"￥";
    [bg addSubview:dan];
    
    _price = [[UILabel alloc] init];
    _price.font = [UIFont systemFontOfSize:26 weight:(UIFontWeightMedium)];
    _price.text = @"80";
    [bg addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.offset(0);
          
           
           make.height.offset(40);
       }];
    _price.textAlignment = NSTextAlignmentRight;
    [dan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_price.mas_bottom).offset(-6);
        make.right.mas_equalTo(_price.mas_left);
    }];
    _title = [[UILabel alloc] init];
    _title.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    _title.text = @"满100元可用";
    [bg addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.top.mas_equalTo(_price);
    }];
   
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_title.mas_left).offset(-18);
    }];
    _type = [[UILabel alloc] init];
    _price.textColor = [UIColor dc_colorWithHexString:@"#FF3812"];
     dan.textColor = [UIColor dc_colorWithHexString:@"#FF3812"];
    _type.font = [UIFont systemFontOfSize:10 weight:(UIFontWeightLight)];
                                                     _type.text = @"商品券";
                                                     _type.textColor = [UIColor dc_colorWithHexString:@"#FF3812"];
                                                     [bg addSubview:_type];
                                                     [_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(100);
        make.bottom.mas_equalTo(_price.mas_bottom);
    }];
                                                     UIButton *bt = [UIButton buttonWithType:(UIButtonTypeCustom)];
                                                     [bt setTitle:@"领取" forState:0];
                                                     bt.backgroundColor = [UIColor dc_colorWithHexString:@"#FF3812"];
                                                     bt.layer.cornerRadius = 15;
                                                     [bt setTitleColor:[UIColor whiteColor] forState:0];
                                                     bt.titleLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
                                                     [bg addSubview:bt];
                                                     [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(-15);
        make.width.offset(60);
        make.height.offset(30);
    }];
    [bt addTarget:self action:@selector(ling:) forControlEvents:(UIControlEventTouchUpInside)];
                                                     
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
  
    _price.text = [NSString stringWithFormat:@"%ld",(long)[dic[@"discountAmount"] integerValue]];
    _title.text = [NSString stringWithFormat:@"满%ld元可用",(long)[dic[@"requireAmount"] integerValue]];
  NSString *st = dic[@"couponsClass"];
    if ([st integerValue] == 1) {
        _type.text = @"平台券";
    }
    if ([st integerValue] == 2) {
        _type.text = [NSString stringWithFormat:@"%@",dic[@"firmName"]];
       }
    if ([st integerValue] == 3) {
           _type.text = @"商品券";
       }
}

- (void)ling:(UIButton*)bt{
    
    [[DCAPIManager shareManager] person_receiveCouponswithcouponsId:[NSString stringWithFormat:@"%@",_dic[@"couponsId"]] success:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"领取成功！"];
                         bt.backgroundColor = [UIColor dc_colorWithHexString:@"cccccc"];
                         bt.userInteractionEnabled = NO;
        [bt setTitle:@"已领取" forState:0];
    } failture:^(NSError *error) {
        
    }];
//    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/activity/coupon/user/add" params:@{@"couponsId":[NSString stringWithFormat:@"%@",_dic[@"couponsId"]]} httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
//
//
//
//              NSDictionary *dict = [responseObject mj_JSONObject];
//              if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
//                  [SVProgressHUD showSuccessWithStatus:@"领取成功！"];
//                  bt.backgroundColor = [UIColor dc_colorWithHexString:@"cccccc"];
//                  bt.userInteractionEnabled = NO;
//
//              } else {
//
//                  [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
//              }
//
//
//          } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
//
//
//          }];
}
@end
