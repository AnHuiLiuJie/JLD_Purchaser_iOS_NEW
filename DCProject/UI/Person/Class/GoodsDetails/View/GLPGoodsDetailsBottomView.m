//
//  GLPGoodsDetailsBottomView.m
//  DCProject
//
//  Created by LiuMac on 2021/7/20.
//

#import "GLPGoodsDetailsBottomView.h"

@interface GLPGoodsDetailsBottomView ()

@property (nonatomic, strong) UIButton *seiverBtn;
@property (nonatomic, strong) UIButton *teacherBtn;
@property (nonatomic, strong) UIButton *carBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIButton *noticeBtn;

@end


@implementation GLPGoodsDetailsBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}



- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];

    _seiverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seiverBtn setTitle:@"客服" forState:0];
    [_seiverBtn setTitleColor:[UIColor dc_colorWithHexString:@"#898989"] forState:0];
    _seiverBtn.titleLabel.font = PFRFont(10);
    [_seiverBtn setImage:[UIImage imageNamed:@"kefu"] forState:0];
    _seiverBtn.tag = 800;
    [_seiverBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_seiverBtn];

    _teacherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_teacherBtn setTitle:@"药师" forState:0];
    [_teacherBtn setTitleColor:[UIColor dc_colorWithHexString:@"#898989"] forState:0];
    _teacherBtn.titleLabel.font = PFRFont(10);
    [_teacherBtn setImage:[UIImage imageNamed:@"yaoshi"] forState:0];
    _teacherBtn.tag = 801;
    [_teacherBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_teacherBtn];

    _carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_carBtn setTitle:@"购物车" forState:0];
    [_carBtn setTitleColor:[UIColor dc_colorWithHexString:@"#898989"] forState:0];
    _carBtn.titleLabel.font = PFRFont(10);
    [_carBtn setImage:[UIImage imageNamed:@"gwc_1"] forState:0];
    _carBtn.tag = 802;
    [_carBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [_carBtn dc_buttonIconTopWithSpacing:10];
    [self addSubview:_carBtn];

    _numb = [[UILabel alloc] init];
    _numb.font = [UIFont systemFontOfSize:12];
    _numb.textColor = [UIColor whiteColor];
    _numb.text = @"1";
    _numb.backgroundColor = [UIColor redColor];
    _numb.textAlignment = NSTextAlignmentCenter;
    [_carBtn addSubview:_numb];
    [_numb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(2);
        make.right.offset(-5);
        make.width.height.offset(20);
    }];
    _numb.layer.cornerRadius = 10;
    _numb.layer.masksToBounds = YES;
    _numb.hidden = YES;

    CGFloat width = (kScreenW - CGRectGetMaxX(_carBtn.frame))/2;
    CGFloat itmeH = GoodsDetailsBottomView_HEIGHT-20;

    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.tag = 803;
    [_addBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    [_addBtn dc_cornerRadius:itmeH/2];

    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.tag = 804;
    [_buyBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buyBtn];
    [_buyBtn dc_cornerRadius:itmeH/2];


    _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _noticeBtn.frame = CGRectMake(kScreenW-width+15, 10, width-30, itmeH);
    _noticeBtn.tag = 805;
    [_noticeBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_noticeBtn];
    [_noticeBtn dc_cornerRadius:itmeH/2];
    _noticeBtn.hidden = YES;
}


#pragma mark - action
- (void)bottomBtnClick:(UIButton *)button
{
    !_GLPNewGoodsDetailsBottomView_block ? : _GLPNewGoodsDetailsBottomView_block(button.tag);
}

#pragma mark - set
- (void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    
    [_carBtn setTitle:@"购物车" forState:UIControlStateNormal];//802
    [self gouNum];

    CGFloat itmeH = GoodsDetailsBottomView_HEIGHT-20;
    CGFloat spacing = 5;

    _seiverBtn.frame = CGRectMake(0, 0, GoodsDetailsBottomView_HEIGHT-spacing, GoodsDetailsBottomView_HEIGHT);
    [_seiverBtn dc_buttonIconTopWithSpacing:10];

    if ([detailModel.isMedical isEqualToString:@"2"]) { //非医药

        _teacherBtn.hidden = YES;

        _carBtn.frame = CGRectMake(CGRectGetMaxX(_seiverBtn.frame), 0, GoodsDetailsBottomView_HEIGHT-spacing, GoodsDetailsBottomView_HEIGHT);
        [_carBtn dc_buttonIconTopWithSpacing:10];

        CGFloat width = (kScreenW - CGRectGetMaxX(_carBtn.frame))/2;
        _addBtn.frame = CGRectMake(CGRectGetMaxX(_carBtn.frame), 10, width-spacing, itmeH);
        _buyBtn.frame = CGRectMake(CGRectGetMaxX(_addBtn.frame)+spacing,10, width-spacing, itmeH);

    } else {

        _teacherBtn.hidden = NO;
        _teacherBtn.frame = CGRectMake(CGRectGetMaxX(_seiverBtn.frame), 0, GoodsDetailsBottomView_HEIGHT-spacing, GoodsDetailsBottomView_HEIGHT);
        [_teacherBtn dc_buttonIconTopWithSpacing:10];

        _carBtn.frame = CGRectMake(CGRectGetMaxX(_teacherBtn.frame), 0, GoodsDetailsBottomView_HEIGHT-spacing, GoodsDetailsBottomView_HEIGHT);
        [_carBtn dc_buttonIconTopWithSpacing:10];

        CGFloat width = (kScreenW - CGRectGetMaxX(_carBtn.frame))/2;
        _addBtn.frame = CGRectMake(CGRectGetMaxX(_carBtn.frame), 10, width-spacing, itmeH);
        _buyBtn.frame = CGRectMake(CGRectGetMaxX(_addBtn.frame)+spacing, 10, width-spacing, itmeH);
    }

    if (_detailModel.totalStock == 0) {
        _addBtn.hidden = YES;
        _buyBtn.hidden = YES;
        _noticeBtn.hidden = NO;
    }else{
        _noticeBtn.hidden = YES;
        _addBtn.hidden = NO;
        _buyBtn.hidden = NO;
    }

    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#84F0AA"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#00BCB1"].CGColor,nil];
    CAGradientLayer *gradientLayer1 = [_addBtn dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@.1, @0.8] colors:clolor1];
    [_addBtn setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
    _addBtn.titleLabel.font = PFRFont(16);
    _addBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    [_addBtn.layer insertSublayer:gradientLayer1 atIndex:0];//注意添加顺序


    NSArray *clolor2 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#FDAF53"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#FC3309"].CGColor,nil];
    CAGradientLayer *gradientLayer2 = [_buyBtn dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@.1, @0.8] colors:clolor2];
    [_buyBtn setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
    _buyBtn.titleLabel.font = PFRFont(16);
    _buyBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#FD4F00"];
    [_buyBtn.layer insertSublayer:gradientLayer2 atIndex:0];//注意添加顺序

    NSArray *clolor3 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#84F0AA"].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#00BCB1"].CGColor,nil];
    CAGradientLayer *gradientLayer3 = [_noticeBtn dc_changeColorWithStart:CGPointMake(0,0)  end:CGPointMake(1,0) locations:@[@.1, @0.8] colors:clolor3];
    [_noticeBtn setTitle:@"到货通知" forState:0];
    [_noticeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFEFE"] forState:0];
    _noticeBtn.titleLabel.font = PFRFont(16);
    [_noticeBtn.layer insertSublayer:gradientLayer3 atIndex:0];//注意添加顺序
    //noticeBtn.hidden = YES;
    
    if (_detailType == GLPGoodsDetailTypeCollage && _detailModel.liaoPrice.length == 0) {
        [_addBtn setTitle:@"原价购买" forState:UIControlStateNormal];//803
        _addBtn.tag = 8033;
        [_buyBtn setTitle:@"立即开团" forState:UIControlStateNormal];//804
        _buyBtn.tag = 8044;
    }else{
        [_addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];//803
        _addBtn.tag = 803;
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];//804
        _buyBtn.tag = 804;
    }
}

- (void)reshnum{
    if (_detailModel == nil) {
        return;
    }
    [self gouNum];
}

- (void)gouNum{
    //lj_change_标记请求位置
    //return;
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/tradeInfo/cart/size" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        [DC_KeyWindow dc_enable];
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSString class]]) {
                NSString *st = dict[@"data"];
                if ([st integerValue] >0) {
                    self->_numb.hidden = NO;
                    self->_numb.text = st;
                }else{
                    self->_numb.hidden = YES;
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        [DC_KeyWindow dc_enable];
    }];
}

- (void)gouxu{
    [[DCHttpClient shareClient] requestWithBaseUrl:Person_RequestUrl path:@"/trade/getNoOtcCartNum" params:nil httpMethod:DCHttpRequestPost sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [DC_KeyWindow dc_enable];
        
        NSDictionary *dict = [responseObject mj_JSONObject];
        if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) {
            
            if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSString class]]) {
                NSString *st = dict[@"data"];
                if ([st integerValue] >0) {
                    self->_numb.hidden = NO;
                    self->_numb.text = st;
                }else{
                    self->_numb.hidden = YES;
                }
            }
            
        } else {
            [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
        }
    
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [DC_KeyWindow dc_enable];
        
    }];
    
}
@end
