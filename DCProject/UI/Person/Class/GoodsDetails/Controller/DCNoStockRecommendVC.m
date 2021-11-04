//
//  DCNoStockRecommendVC.m
//  DCProject
//
//  Created by LiuMac on 2021/9/27.
//

#import "DCNoStockRecommendVC.h"
#import "GLPGoodsDetailsController.h"
static int itemH = 160;

@interface DCNoStockRecommendVC (){
    CGFloat _itemW;
    CGFloat _scrollBgViewH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIScrollView *scrollBgView;

@end



@implementation DCNoStockRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
}

#pragma mark - setUpUI
- (void)setUpUI
{
    _spacing = 10;
    _itemW = floor((kScreenW-14*2-3*_spacing - 5*2)/3.5);
    _scrollBgViewH = itemH+5+5;
    
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
//    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 250-LJ_TabbarSafeBottomMargin, kScreenW, 250+LJ_TabbarSafeBottomMargin)];
    
    CGFloat viewY = -56-LJ_TabbarSafeBottomMargin;
    self.view.frame = CGRectMake(0, viewY, kScreenW, kScreenH+viewY);
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenH - 240-LJ_TabbarSafeBottomMargin), kScreenW, 240+LJ_TabbarSafeBottomMargin)];
    
//    CGFloat viewH = kScreenH-50;
//    self.view.frame = CGRectMake(0, -viewH, kScreenW, viewH);
//    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenH - 250-LJ_TabbarSafeBottomMargin), kScreenW, 250+LJ_TabbarSafeBottomMargin)];
    
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:18 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight ];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _titleLabel.text = @"暂时无货，先看其他商品";
    _titleLabel.numberOfLines = 0;
    [_bgView addSubview:_titleLabel];


    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_arrow_down_hei"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_cancelBtn];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor dc_colorWithHexString:DC_BGColor];
    [_bgView addSubview:_lineView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipLabelClick:)];
    [self.bgView addGestureRecognizer:tap];
    
    
    _scrollBgView = [[UIScrollView alloc] init];
    [_bgView addSubview:_scrollBgView];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.bgView.centerX);
        make.left.equalTo(self.bgView.left).offset(15);
        make.right.equalTo(self.bgView.right).offset(-15);
        make.top.equalTo(self.bgView.top).offset(0);
        make.height.equalTo(50);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right).offset(-10);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.right);
        make.left.equalTo(self.bgView.left);
        make.top.equalTo(self.titleLabel.bottom);
        make.height.equalTo(2);
    }];
    
    
    [_scrollBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(self.lineView.bottom).offset(10);
        make.right.equalTo(self.bgView.right).offset(10);
        make.height.equalTo(itemH);
    }];
    
    
    if (_dataArray.count > 0) {
        for (int i=0; i<_dataArray.count; i++) {
            GLPGoodsLickGoodsModel *model = _dataArray[i];
            GLPNoStockRecommendrGoodsView *view = [[GLPNoStockRecommendrGoodsView alloc] init];
            [self.scrollBgView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollBgView).offset(5+(_itemW+_spacing)*i);
                make.centerY.equalTo(self.scrollBgView.centerY);
                make.height.equalTo(itemH);
                make.width.equalTo(_itemW);
            }];
            view.model = model;
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            view.tag = i;
            [view addGestureRecognizer:tap3];
        }
    }
    self.scrollBgView.contentSize = CGSizeMake((_itemW+_spacing)*_dataArray.count, itemH);

}

#pragma mark - setter
//- (void)setDataArray:(NSArray *)dataArray{
//    _dataArray = dataArray;
//
//
//}

- (void)skipLabelClick:(id)sender{
    [self cancelBtnClick:nil];
}

#pragma mark - action
- (void)cancelBtnClick:(UIButton *)button
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    UIView * view = recognizer.view;
    GLPGoodsLickGoodsModel *model = _dataArray[view.tag];

    GLPGoodsDetailsController *vc = [GLPGoodsDetailsController new];
    vc.goodsId = model.iD;
    vc.firmId = model.sellerFirmId;
    vc.batchId = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    NSLog(@"dealloc %@ RetainCount = %ld\n",[self class],CFGetRetainCount((__bridge CFTypeRef)(self)));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



#pragma mark - 商品
@interface GLPNoStockRecommendrGoodsView ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation GLPNoStockRecommendrGoodsView

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
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.image = [UIImage imageNamed:@"dc_placeholder_bg"];
    [self addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 2;
    _titleLabel.text = @"";
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF2800"];
    _priceLabel.font = PFRFont(14);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = @"¥0.00";
    [self addSubview:_priceLabel];
    
    [self layoutIfNeeded];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.top);
        make.height.equalTo(self.width).multipliedBy(1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.goodsImage.bottom).offset(3);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.top.equalTo(self.titleLabel.bottom).offset(3);
    }];
}


#pragma mark - setter
- (void)setModel:(GLPGoodsLickGoodsModel *)model{
    _model = model;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    _titleLabel.text = _model.goodsTitle;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.sellPrice];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:[UIFont fontWithName:PFR size:10] maxFont:[UIFont fontWithName:PFRMedium size:15] forReplace:@"¥"];
}


@end

