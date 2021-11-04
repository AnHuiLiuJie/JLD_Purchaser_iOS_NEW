//
//  GLPGoodsDetailsInfoCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsInfoCell.h"



@interface GLPGoodsDetailsInfoCell ()

@property (nonatomic, strong) UIButton *descBtn;
@property (nonatomic, strong) UIButton *afterSellBtn;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UILabel *tsLab;
@property (nonatomic, strong) UILabel *baseInfoLab;
@property (nonatomic, strong) UILabel *nameTLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *brandTLab;
@property (nonatomic, strong) UILabel *brandLab;
@property (nonatomic, strong) UILabel *nubTLab;
@property (nonatomic, strong) UILabel *nubLab;
@property (nonatomic, strong) UILabel *sapecTLab;
@property (nonatomic, strong) UILabel *sapecLab;
@property (nonatomic, strong) UILabel *goodDetailLab;
@property (nonatomic, strong) UILabel *jiTLab;
@property (nonatomic, strong) UILabel *jiLab;
@property (nonatomic, strong) UILabel *scTLab;
@property (nonatomic, strong) UILabel *scLab;
@property (nonatomic, strong) UILabel *dzTLab;
@property (nonatomic, strong) UILabel *dzLab;
@property (nonatomic, strong) UILabel *usTLab;
@property (nonatomic, strong) UILabel *usLab;
@property (nonatomic, strong) UILabel *rqTLab;
@property (nonatomic, strong) UILabel *rqLab;
@property (nonatomic, assign) CGFloat viewHeight; // 富文本高度

@property (nonatomic, strong) UIView *rightView;
@property(nonatomic,strong)UIImageView*rightImageV1;
@property (nonatomic, strong) UILabel *rightTLab1;
@property (nonatomic, strong) UILabel *rightLab1;
@property(nonatomic,strong)UIImageView*rightImageV2;
@property (nonatomic, strong) UILabel *rightTLab2;
@property (nonatomic, strong) UILabel *rightLab2;
@property(nonatomic,strong)UIImageView*rightImageV3;
@property (nonatomic, strong) UILabel *rightTLab3;
@property (nonatomic, strong) UILabel *rightLab3;
@property(nonatomic,strong)UIImageView*rightImageV4;
@property (nonatomic, strong) UILabel *rightTLab4;
@property (nonatomic, strong) UILabel *rightLab4;
@property(nonatomic,strong)UIImageView*rightImageV5;
@property (nonatomic, strong) UILabel *rightTLab5;
@property (nonatomic, strong) UILabel *rightLab5;

@end

@implementation GLPGoodsDetailsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _descBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_descBtn setTitle:@"商品介绍" forState:0];
    [_descBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_descBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00BDB2"] forState:UIControlStateSelected];
    _descBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _descBtn.tag = 600;
    [_descBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _descBtn.selected = YES;
    [self.contentView addSubview:_descBtn];
    
    
    _afterSellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_afterSellBtn setTitle:@"售后保障/资质" forState:0];
    [_afterSellBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_afterSellBtn setTitleColor:[UIColor dc_colorWithHexString:@"#00BDB2"] forState:UIControlStateSelected];
    _afterSellBtn.titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _afterSellBtn.tag = 601;
    [_afterSellBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_afterSellBtn];
      //左边view
    _leftView = [[UIView alloc] init];
    _leftView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_leftView];
   
    _redView = [[UIView alloc] init];
    _redView.backgroundColor = RGB_COLOR(255, 245, 240);
    [_leftView addSubview:_redView];
    
    _tsLab = [[UILabel alloc] init];
    _tsLab.font = [UIFont systemFontOfSize:11];
    _tsLab.textColor = RGB_COLOR(253, 79, 0);
    _tsLab.text = @"温馨提示：部分商品包装因厂家更换频繁，如有不符请以实物为准。";
    [_redView addSubview:_tsLab];
    
    _baseInfoLab = [[UILabel alloc] init];
    _baseInfoLab.text = @"基本信息";
    _baseInfoLab.textColor = RGB_COLOR(51, 51,51);
    _baseInfoLab.font = [UIFont systemFontOfSize:14];
    [_leftView addSubview:_baseInfoLab];
    
    _nameTLab = [[UILabel alloc] init];
    _nameTLab.text = @"通 用 名：";
    _nameTLab.textColor = RGB_COLOR(147, 146,146);
    _nameTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_nameTLab];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = @"健胃消食片";
    _nameLab.textColor = RGB_COLOR(51, 51,51);
    _nameLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_nameLab];
    
    _brandTLab = [[UILabel alloc] init];
    _brandTLab.text = @"商品品牌：";
    _brandTLab.textColor = RGB_COLOR(147, 146,146);
    _brandTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_brandTLab];
    
    _brandLab = [[UILabel alloc] init];
    _brandLab.text = @"健民";
    _brandLab.textColor = RGB_COLOR(51, 51,51);
    _brandLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_brandLab];
    
    _nubTLab = [[UILabel alloc] init];
    _nubTLab.text = @"批准文号:";
    _nubTLab.textColor = RGB_COLOR(147, 146,146);
    _nubTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_nubTLab];
    
    _nubLab = [[UILabel alloc] init];
    _nubLab.text = @"213331232";
    _nubLab.textColor = RGB_COLOR(51, 51,51);
    _nubLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_nubLab];
    
    _sapecTLab = [[UILabel alloc] init];
    _sapecTLab.text = @"包装规格：";
    _sapecTLab.textColor = RGB_COLOR(147, 146,146);
    _sapecTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_sapecTLab];
    
    _sapecLab = [[UILabel alloc] init];
    _sapecLab.text = @"0.8g*8";
    _sapecLab.textColor = RGB_COLOR(51, 51,51);
    _sapecLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_sapecLab];
    _jiTLab = [[UILabel alloc] init];
    _jiTLab.text = @"剂型：";
    _jiTLab.textColor = RGB_COLOR(147, 146,146);
    _jiTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_jiTLab];
    
    _jiLab = [[UILabel alloc] init];
    _jiLab.text = @"--";
    _jiLab.textColor = RGB_COLOR(51, 51,51);
    _jiLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_jiLab];
    _scTLab = [[UILabel alloc] init];
    _scTLab.text = @"生产单位：";
    _scTLab.textColor = RGB_COLOR(147, 146,146);
    _scTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_scTLab];
    
    _scLab = [[UILabel alloc] init];
    _scLab.text = @"--";
    _scLab.textColor = RGB_COLOR(51, 51,51);
    _scLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_scLab];
    _dzTLab = [[UILabel alloc] init];
    _dzTLab.text = @"生产地址：";
    _dzTLab.textColor = RGB_COLOR(147, 146,146);
    _dzTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_dzTLab];
    
    _dzLab = [[UILabel alloc] init];
    _dzLab.text = @"--";
    _dzLab.textColor = RGB_COLOR(51, 51,51);
    _dzLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_dzLab];
    
    _usTLab = [[UILabel alloc] init];
    _usTLab.text = @"使用方法：";
    _usTLab.textColor = RGB_COLOR(147, 146,146);
    _usTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_usTLab];
    
    _usLab = [[UILabel alloc] init];
    _usLab.text = @"--";
    _usLab.textColor = RGB_COLOR(51, 51,51);
    _usLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_usLab];
    
    _rqTLab = [[UILabel alloc] init];
    _rqTLab.text = @"适用人群：";
    _rqTLab.textColor = RGB_COLOR(147, 146,146);
    _rqTLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_rqTLab];
    
    _rqLab = [[UILabel alloc] init];
    _rqLab.text = @"--";
    _rqLab.textColor = RGB_COLOR(51, 51,51);
    _rqLab.font = [UIFont systemFontOfSize:12];
    [_leftView addSubview:_rqLab];
    _goodDetailLab = [[UILabel alloc] init];
    _goodDetailLab.text = @"商品描述";
    _goodDetailLab.textColor = RGB_COLOR(51, 51,51);
    _goodDetailLab.font = [UIFont systemFontOfSize:14];
    [_leftView addSubview:_goodDetailLab];
    
    
    _viewHeight = 0;
    
    _rightView = [[UIView alloc] init];
    _rightView.hidden = YES;
    _rightView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_rightView];
    
    _rightImageV1 = [[UIImageView alloc] init];
    _rightImageV1.image = [UIImage imageNamed:@"home_zuans"];
    [_rightView addSubview:_rightImageV1];
    
    _rightTLab1 = [[UILabel alloc] init];
    _rightTLab1.text = @"品质保障";
    _rightTLab1.textColor = RGB_COLOR(51, 51,51);
    _rightTLab1.font = [UIFont systemFontOfSize:14];
    [_rightView addSubview:_rightTLab1];
    
    _rightLab1 = [[UILabel alloc] init];
    _rightLab1.numberOfLines=0; _rightLab1.text = @"金利达药品交易网健康商城在售商品均由正规实体签约商家供货，商家提供品质保证。在购物过程中发现任何商家、商品存在经营或者质量问题，请直接向平台投诉举报。";
    _rightLab1.textColor = RGB_COLOR(51, 51,51);
    _rightLab1.font = [UIFont systemFontOfSize:12];
    [_rightView addSubview:_rightLab1];
    
    _rightImageV2 = [[UIImageView alloc] init];
    _rightImageV2.image = [UIImage imageNamed:@"home_zuans"];
    [_rightView addSubview:_rightImageV2];
    
    _rightTLab2 = [[UILabel alloc] init];
    _rightTLab2.text = @"提供发票";
    _rightTLab2.textColor = RGB_COLOR(51, 51,51);
    _rightTLab2.font = [UIFont systemFontOfSize:14];
    [_rightView addSubview:_rightTLab2];
    
    _rightLab2 = [[UILabel alloc] init];
    _rightLab2.numberOfLines=0; _rightLab2.text = @"金利达药品交易网健康商城所有在售商家均可提供商品发票。发票由订单对应的商家向您开具，与您所订购货物一起寄送给您。如您在下订单时没有要求开具发票，则需要您承担因此所产生的运费。如您在收到发票后发现票据抬头、内容或金额错误，请您将原发票寄回，并致电400-880-1268，由客服人员协助您向商家办理更换发票事宜。如是因您填写错误所造成的发票更换问题，则需要您承担因此所产生的相关费用。";
    _rightLab2.textColor = RGB_COLOR(51, 51,51);
    _rightLab2.font = [UIFont systemFontOfSize:12];
    [_rightView addSubview:_rightLab2];
    
    _rightImageV3 = [[UIImageView alloc] init];
    _rightImageV3.image = [UIImage imageNamed:@"home_zuans"];
    [_rightView addSubview:_rightImageV3];
    
    _rightTLab3 = [[UILabel alloc] init];
    _rightTLab3.text = @"退换货政策";
    _rightTLab3.textColor = RGB_COLOR(51, 51,51);
    _rightTLab3.font = [UIFont systemFontOfSize:14];
    [_rightView addSubview:_rightTLab3];
    
    _rightLab3 = [[UILabel alloc] init];
    _rightLab3.numberOfLines=0; _rightLab3.text = @"您在金利达药品交易网健康商城购买的商品（含保健食品、健康产品，个别商家另有说明的除外），如符合以下条件，商家将提供无条件退换货服务：\n1、自您签收商品之日起7日内提出申请。\n2、商品及商品本身的外包装没有破损，没有拆封使用，保持商家出售时的原质原样，不影响二次销售。\n3、确保商品及配件、附带品或者赠品、保修卡、三包凭证、发票、发货清单齐全。\n4、如果成套商品中有部分商品存在质量问题，在办理退货时，必须提供成套商品。\n5、食品、贴身用品、化妆品、玩具、特价商品等若无质量问题恕不退换，确有质量问题依照国家对该种商品的法定退换原则执行。";
    _rightLab3.textColor = RGB_COLOR(51, 51,51);
    _rightLab3.font = [UIFont systemFontOfSize:12];
    [_rightView addSubview:_rightLab3];
    
    _rightImageV4 = [[UIImageView alloc] init];
    _rightImageV4.image = [UIImage imageNamed:@"home_zuans"];
    [_rightView addSubview:_rightImageV4];
    
    _rightTLab4 = [[UILabel alloc] init];
    _rightTLab4.text = @"退换货流程";
    _rightTLab4.textColor = RGB_COLOR(51, 51,51);
    _rightTLab4.font = [UIFont systemFontOfSize:14];
    [_rightView addSubview:_rightTLab4];
    
    _rightLab4 = [[UILabel alloc] init];
    _rightLab4.numberOfLines=0; _rightLab4.text = @"1、联系商家客服或自行确认所购商品是否符合退换货政策。\n2、在线提交退换货申请及相关证明。\n3、退换货申请通过后寄回商品。\n4、确认商家为您重寄的商品或者退款。";
    _rightLab4.textColor = RGB_COLOR(51, 51,51);
    _rightLab4.font = [UIFont systemFontOfSize:12];
    [_rightView addSubview:_rightLab4];
    
    _rightImageV5 = [[UIImageView alloc] init];
    _rightImageV5.image = [UIImage imageNamed:@"home_zuans"];
    [_rightView addSubview:_rightImageV5];
    
    _rightTLab5 = [[UILabel alloc] init];
    _rightTLab5.text = @"特殊说明";
    _rightTLab5.textColor = RGB_COLOR(51, 51,51);
    _rightTLab5.font = [UIFont systemFontOfSize:14];
    [_rightView addSubview:_rightTLab5];
    
    _rightLab5 = [[UILabel alloc] init];
    _rightLab5.numberOfLines=0; _rightLab5.text = @"因药品是特殊商品，依据中华人民共和国《药品经营质量管理规范》及其实施细则（GSP）、《互联网药品交易服务审批暂行规定》等法律、法规的相关规定：药品一经售出，无质量问题，不退不换。";
    _rightLab5.textColor = RGB_COLOR(51, 51,51);
    _rightLab5.font = [UIFont systemFontOfSize:12];
    [_rightView addSubview:_rightLab5];

    
    [self updateMasonry];
}



#pragma mark - action
- (void)infoBtnClick:(UIButton *)button
{
    if (self.infoblock) {
        self.infoblock(button.tag);
    }
}

- (void)updateMasonry {
    
    [_descBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.contentView.top);
        make.size.equalTo(CGSizeMake(kScreenW/2, 60));
    }];
    
    
    [_afterSellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descBtn.right);
        make.centerY.equalTo(self.descBtn.centerY);
        make.size.equalTo(CGSizeMake(kScreenW/2, 60));
    }];
    
    if (_leftView.hidden == NO) {
        [_rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 
                          }];
        //左边view
            [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.afterSellBtn.mas_bottom).offset(10);
                make.left.right.bottom.offset(0);
        //        make.height.mas_greaterThanOrEqualTo(31);
            }];

            [_redView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.offset(0);
                make.height.offset(31);
            }];
            [_tsLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(8);
                make.left.offset(15);
                make.right.offset(0);
                make.height.offset(16);
            }];
            [_baseInfoLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.redView.mas_bottom).offset(10);
                make.left.offset(15);
                make.right.offset(-15);
                make.height.offset(20);
            }];
            [_nameTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.baseInfoLab.mas_bottom).offset(10);
                make.left.offset(15);
                make.width.offset(70);
                make.height.offset(17);
            }];
            [_nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.baseInfoLab.mas_bottom).offset(10);
                   make.left.equalTo(self.nameTLab.mas_right).offset(10);
                   make.right.offset(-15);
                   make.height.offset(17);
            }];
            [_brandTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameTLab.mas_bottom).offset(10);
                make.left.offset(15);
                make.width.offset(70);
                make.height.offset(17);
            }];
            [_brandLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.nameTLab.mas_bottom).offset(10);
                   make.left.equalTo(self.brandTLab.mas_right).offset(10);
                   make.right.offset(-15);
                   make.height.offset(17);
            }];
            [_nubTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.brandTLab.mas_bottom).offset(10);
                   make.left.offset(15);
                   make.width.offset(70);
                   make.height.offset(17);
               }];
               [_nubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                      make.top.equalTo(self.brandTLab.mas_bottom).offset(10);
                      make.left.equalTo(self.nubTLab.mas_right).offset(10);
                      make.right.offset(-15);
                      make.height.offset(17);
               }];
            [_sapecTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.nubTLab.mas_bottom).offset(10);
                   make.left.offset(15);
                   make.width.offset(70);
                   make.height.offset(17);
               }];
               [_sapecLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                      make.top.equalTo(self.nubTLab.mas_bottom).offset(10);
                      make.left.equalTo(self.sapecTLab.mas_right).offset(10);
                      make.right.offset(-15);
                      make.height.offset(17);
               }];
        [_jiTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.sapecTLab.mas_bottom).offset(10);
               make.left.offset(15);
               make.width.offset(70);
               make.height.offset(17);
           }];
        [_jiLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.sapecTLab.mas_bottom).offset(10);
               make.left.equalTo(self.jiTLab.mas_right).offset(10);
               make.right.offset(-15);
               make.height.offset(17);
        }];
        [_scTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.jiTLab.mas_bottom).offset(10);
               make.left.offset(15);
               make.width.offset(70);
               make.height.offset(17);
           }];
        [_scLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.jiTLab.mas_bottom).offset(10);
               make.left.equalTo(self.scTLab.mas_right).offset(10);
               make.right.offset(-15);
               make.height.offset(17);
        }];
        [_dzTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.scLab.mas_bottom).offset(10);
               make.left.offset(15);
               make.width.offset(70);
               make.height.offset(17);
           }];
        [_dzLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.scLab.mas_bottom).offset(10);
               make.left.equalTo(self.dzTLab.mas_right).offset(10);
               make.right.offset(-15);
               make.height.offset(17);
        }];
        [_usTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.dzTLab.mas_bottom).offset(10);
               make.left.offset(15);
               make.width.offset(70);
               make.height.offset(17);
           }];
        [_usLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.dzTLab.mas_bottom).offset(10);
               make.left.equalTo(self.usTLab.mas_right).offset(10);
               make.right.offset(-15);
               make.height.offset(17);
        }];
        [_rqTLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.usTLab.mas_bottom).offset(10);
               make.left.offset(15);
               make.width.offset(70);
               make.height.offset(17);
           }];
        [_rqLab mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.usTLab.mas_bottom).offset(10);
               make.left.equalTo(self.rqTLab.mas_right).offset(10);
               make.right.offset(-15);
               make.height.offset(17);
        }];
               [_goodDetailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.rqTLab.mas_bottom).offset(20);
                   make.left.offset(15);
                   make.right.offset(-15);
                   make.height.offset(20);
                   make.bottom.equalTo(self.leftView.mas_bottom).offset(-10);
               }];
    }
    
    
    if (_rightView.hidden == NO) {
        [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
                          
                   }];
        //右边view
            [_rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.afterSellBtn.mas_bottom).offset(10);
                   make.left.right.bottom.offset(0);
        //           make.height.mas_greaterThanOrEqualTo(31);
            }];
            [_rightImageV1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(3);
                make.left.offset(15);
                make.width.height.offset(14);
              }];
            [_rightTLab1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.equalTo(self.rightImageV1.mas_right).offset(2);
                make.right.offset(-15);
                make.height.offset(20);
            }];
            [_rightLab1 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_rightTLab1.mas_bottom).offset(9);
               make.left.offset(15);
                make.right.offset(-15);
               
            }];
            [_rightImageV2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.rightLab1.mas_bottom).offset(20);
                   make.left.offset(15);
                   make.width.height.offset(14);
            }];
            [_rightTLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.rightLab1.mas_bottom).offset(17);
                   make.left.equalTo(self.rightImageV2.mas_right).offset(2);
                   make.right.offset(-15);
                   make.height.offset(20);
            }];
            [_rightLab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(_rightTLab2.mas_bottom).offset(9);
                   make.left.offset(15);
                   make.right.offset(-15);
                 
            }];
            [_rightImageV3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.rightLab2.mas_bottom).offset(20);
                   make.left.offset(15);
                   make.width.height.offset(14);
            }];
            [_rightTLab3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.top.equalTo(self.rightLab2.mas_bottom).offset(17);
                   make.left.equalTo(self.rightImageV3.mas_right).offset(2);
                   make.right.offset(-15);
                   make.height.offset(20);
            }];
            [_rightLab3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(_rightTLab3.mas_bottom).offset(9);
                   make.left.offset(15);
                   make.right.offset(-15);
                  
            }];
            [_rightImageV4 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.rightLab3.mas_bottom).offset(20);
                   make.left.offset(15);
                   make.width.height.offset(14);
            }];
            [_rightTLab4 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.rightLab3.mas_bottom).offset(17);
                   make.left.equalTo(self.rightImageV4.mas_right).offset(2);
                   make.right.offset(-15);
                   make.height.offset(20);
            }];
            [_rightLab4 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(_rightTLab4.mas_bottom).offset(9);
                   make.left.offset(15);
                   make.right.offset(-15);
                  
            }];
            [_rightImageV5 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(self.rightLab4.mas_bottom).offset(20);
                   make.left.offset(15);
                   make.width.height.offset(14);
            }];
            [_rightTLab5 mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.rightLab4.mas_bottom).offset(17);
                   make.left.equalTo(self.rightImageV5.mas_right).offset(2);
                   make.right.offset(-15);
                   make.height.offset(20);
            }];
            [_rightLab5 mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(_rightTLab5.mas_bottom).offset(9);
                   make.left.offset(15);
                   make.right.offset(-15);
                 
                   make.bottom.equalTo(self.rightView.mas_bottom).offset(-10);
            }];

    }
  
   
}


- (void)setSelctButton:(NSString *)selctButton{
    if ([selctButton isEqualToString:@"600"]) {
           self.leftView.hidden = NO;
              self.rightView.hidden = YES;
           self.descBtn.selected = YES;
              self.afterSellBtn.selected = NO;
       }
       else{
           self.leftView.hidden = YES;
           self.rightView.hidden = NO;
           self.descBtn.selected = NO;
           self.afterSellBtn.selected = YES;
       }
    
     [self updateMasonry];
}


#pragma mark - setter
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    if (_detailModel) {
        self.nameLab.text = [NSString stringWithFormat:@"%@",_detailModel.goodsName];
        self.brandLab.text = [NSString stringWithFormat:@"%@",_detailModel.brandName];
        self.scLab.text = [NSString stringWithFormat:@"%@",_detailModel.manufactory];
        self.dzLab.text = [NSString stringWithFormat:@"%@",_detailModel.manufactoryAddr];
        self.jiLab.text = [NSString stringWithFormat:@"%@",_detailModel.dosageForm];
        self.usLab.text = [NSString stringWithFormat:@"%@",_detailModel.useMethod];
        self.rqLab.text = [NSString stringWithFormat:@"%@",_detailModel.usePerson];
        
//        if ([_detailModel.isMedical isEqualToString:@"2"]) {
//
//            self.nubTLab.text = @"生产单位:";
//            self.sapecTLab.text = @"生产地址:";
//
//            self.nubLab.text = [NSString stringWithFormat:@"%@",specModel.manufactory];
//            self.sapecLab.text = [NSString stringWithFormat:@"%@",specModel.manufactoryAddr];
//
//        } else {
//
//            _nubTLab.text = @"批准文号:";
//            _sapecTLab.text = @"包装规格：";
            
            self.nubLab.text = [NSString stringWithFormat:@"%@",_detailModel.certifiNum];
            self.sapecLab.text = [NSString stringWithFormat:@"%@",_detailModel.packingSpec];
//        }
        
        
    }
    
    [self updateMasonry];
}



@end
