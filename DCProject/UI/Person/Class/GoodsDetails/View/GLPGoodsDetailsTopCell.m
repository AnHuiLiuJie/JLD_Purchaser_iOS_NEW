//
//  GLPGoodsDetailsTopCell.m
//  DCProject
//
//  Created by LiuMac on 2021/9/17.
//

#import "GLPGoodsDetailsTopCell.h"

@interface GLPGoodsDetailsTopCell ()

/*背景View*/
@property (nonatomic, strong) UIView *bgView;
/*现价*/
@property (nonatomic, strong) UILabel *priceLab;
/*市场价格或者 商城价格优惠之前的 */
@property (nonatomic, strong) UILabel *markPriceLabel;
/*活动类型*/
@property (nonatomic, strong) UILabel *activityTypeLab;
/*创业者赚*/
@property (nonatomic, strong)  UILabel *rebateLab;
@property (nonatomic, copy) NSString  *extendType;//是否加入创业者
/*收藏按钮*/
@property (nonatomic, strong) UIButton *collectBtn;
/*分享*/
@property (nonatomic, strong) UIButton *shareBtn;

@end

static CGFloat cell_spacing_x = 0;
static CGFloat cell_spacing_y = 0;
static CGFloat cell_spacing_h = 60;

static CGFloat btn_H = 40;

@implementation GLPGoodsDetailsTopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    //[_bgView dc_cornerRadius:cell_spacing_x];

    _priceLab = [[UILabel alloc] init];
    _priceLab.textColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    _priceLab.font = [UIFont fontWithName:PFRMedium size:18];
    _priceLab.text = @"¥0.00";
    [_bgView addSubview:_priceLab];
    
    _activityTypeLab = [[UILabel alloc] init];
    _activityTypeLab.textColor = [UIColor dc_colorWithHexString:@"#FF3B30"];
    _activityTypeLab.font = [UIFont fontWithName:PFR size:12];
    _activityTypeLab.text = @"拼团价";
    _activityTypeLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_activityTypeLab];
    
    _markPriceLabel = [[UILabel alloc] init];
    _markPriceLabel.textAlignment = NSTextAlignmentCenter;
    _markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    _markPriceLabel.font = PFRFont(12);
    _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"¥0.00"];
    [_bgView addSubview:_markPriceLabel];
    
    _rebateLab = [[UILabel alloc] init];
    _rebateLab.textColor = [UIColor dc_colorWithHexString:@"#FF5330"];
    _rebateLab.font = PFRFont(11);
    _rebateLab.textAlignment = NSTextAlignmentCenter;
    _rebateLab.text = @" 赚*.** ";
    [_bgView addSubview:_rebateLab];
    _extendType = [DCUpdateTool shareClient].currentUserB2C.extendType;
    [DCSpeedy dc_changeControlCircularWith:_rebateLab AndSetCornerRadius:8 SetBorderWidth:1 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setTitle:@"收藏" forState:0];
    [_collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [_collectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    [_collectBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FE4800"] forState:UIControlStateSelected];
    _collectBtn.titleLabel.font = PFRFont(10);
    [_collectBtn setImage:[UIImage imageNamed:@"weishouc"] forState:0];
    [_collectBtn setImage:[UIImage imageNamed:@"yishouc"] forState:UIControlStateSelected];
    _collectBtn.adjustsImageWhenHighlighted = NO;
    [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _collectBtn.bounds = CGRectMake(0, 0, btn_H, btn_H);
    [_collectBtn dc_buttonIconTopWithSpacing:7];
    [_bgView addSubview:_collectBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setTitle:@"分享" forState:0];
    [_shareBtn setTitleColor:[UIColor dc_colorWithHexString:@"#333333"] forState:0];
    _shareBtn.titleLabel.font = PFRFont(10);
    [_shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:0];
    _shareBtn.adjustsImageWhenHighlighted = NO;
    [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.bounds = CGRectMake(0, 0, btn_H, btn_H);
    [_shareBtn dc_buttonIconTopWithSpacing:7];
    [_bgView addSubview:_shareBtn];
}

#pragma mark - Setter Getter Methods
-(void)setDetailType:(GLPGoodsDetailType)detailType{
    _detailType = detailType;
}

- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;

    __block NSString *actTips = @"";
    __block NSString *priceStr = [NSString stringWithFormat:@"¥%.2f",_detailModel.sellPrice];
    __block NSString *marketStr = [NSString stringWithFormat:@"¥%.2f",_detailModel.marketPrice];
    [_detailModel.activities enumerateObjectsUsingBlock:^(GLPGoodsActivitiesModel *_Nonnull actModel, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([actModel.actType isEqualToString:@"seckill"]) {
                actTips = @"秒杀价";
                priceStr = [NSString stringWithFormat:@"¥%.2f",actModel.actSellPrice];
                //marketStr = [NSString stringWithFormat:@"¥%.2f",self.detailModel.sellPrice];
            }else if([actModel.actType isEqualToString:@"collage"]) {
                actTips = @"拼团价";
                priceStr = [NSString stringWithFormat:@"¥%.2f",actModel.actSellPrice];
                //marketStr = [NSString stringWithFormat:@"¥%.2f",self.detailModel.sellPrice];
            }else if([actModel.actType isEqualToString:@"group"]) {
                actTips = @"团购价";
                priceStr = [NSString stringWithFormat:@"¥%.2f",actModel.actSellPrice];
                //marketStr = [NSString stringWithFormat:@"¥%.2f",self.detailModel.sellPrice];
            }
    }];
    
    _markPriceLabel.hidden = NO;
    if (self.detailType == GLPGoodsDetailTypeNormal ) {
        _markPriceLabel.font = PFRFont(14);
        _activityTypeLab.hidden = YES;
        if (_detailModel.marketPrice <= _detailModel.sellPrice){
            _markPriceLabel.text = @"";
            _markPriceLabel.hidden = YES;
        }
    }else{
        _activityTypeLab.hidden = NO;
        _markPriceLabel.font = PFRFont(12);
        _activityTypeLab.text = actTips;
    }
    
    NSString *spreadStr = _detailModel.spreadAmount;
    if (_detailModel.liaoPrice.length > 0) {
        priceStr = [NSString stringWithFormat:@"¥%@",_detailModel.liaoPrice];
        _activityTypeLab.hidden = YES;
        CGFloat spreadAmount = [_detailModel.liaoPrice floatValue] * _detailModel.spreadRate;
        spreadStr = [NSString stringWithFormat:@"%.2f",spreadAmount];
    
        if (_detailModel.liaoOldPrice.length > 0 ) {
            self.markPriceLabel.attributedText = [NSString dc_strikethroughWithString:@""];
            self.markPriceLabel.text = [NSString stringWithFormat:@"省¥%@",_detailModel.liaoOldPrice];
            self.markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#F84B14"];
        }
        
        //_markPriceLabel.hidden = YES;
    
    }else{
        _markPriceLabel.attributedText = [NSString dc_strikethroughWithString:marketStr];
        self.markPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#AEAEAE"];
    }
    
    
    
    _priceLab.text = priceStr;//[NSString stringWithFormat:@"¥%@",_model.sellPrice];
    _priceLab = [UILabel setupAttributeLabel:_priceLab textColor:_priceLab.textColor minFont:[UIFont fontWithName:PFR size:17] maxFont:[UIFont fontWithName:PFRSemibold size:26] forReplace:@"¥"];
    
    if ([_extendType integerValue] == 1) {
        _rebateLab.hidden = NO;
        if (![DCSpeedy isBlankString:spreadStr]) {
            _rebateLab.text = [NSString stringWithFormat:@" 赚%@  ",spreadStr];
        }
    }else{
        _rebateLab.text = @"";
        _rebateLab.hidden = YES;
    }
    
    if (_detailModel.isCollection > 0) { // 被收藏
        _collectBtn.selected = YES;
    } else {
        _collectBtn.selected = NO;
    }
    
}


#pragma mark - action
- (void)collectBtnClick:(UIButton *)button{
    !_GLPGoodsDetailsTopCell_block ? : _GLPGoodsDetailsTopCell_block(@"收藏");
}

- (void)shareBtnClick:(UIButton *)button{
    !_GLPGoodsDetailsTopCell_block ? : _GLPGoodsDetailsTopCell_block(@"分享");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(cell_spacing_y, cell_spacing_x, cell_spacing_y, cell_spacing_x));
        make.height.equalTo(cell_spacing_h).priorityHigh();
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.centerY.equalTo(self.bgView.centerY);
    }];
    
    if (self.detailType == GLPGoodsDetailTypeNormal ) {
        [_markPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLab.right).offset(10);
            make.centerY.equalTo(self.priceLab.centerY).offset(5);
        }];
    }else{
        [_markPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLab.right).offset(10);
            make.centerY.equalTo(self.priceLab.centerY).offset(8);
        }];
        
        [_activityTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.markPriceLabel.centerX);
            make.bottom.equalTo(self.markPriceLabel.top).offset(0);
        }];
    }
    
    [_rebateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markPriceLabel.right).offset(10);
        make.centerY.equalTo(self.priceLab.centerY).offset(5);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-15);
        make.centerY.equalTo(self.bgView.centerY);
        make.size.equalTo(CGSizeMake(btn_H, btn_H));
    }];
    
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.left).offset(-10);
        make.centerY.equalTo(self.shareBtn.centerY);
        make.size.equalTo(CGSizeMake(btn_H, btn_H));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
