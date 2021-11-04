//
//  GLBAddShoppingCarController.m
//  DCProject
//
//  Created by bigbing on 2019/7/31.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddShoppingCarController.h"
#import "GLBEditCountView.h"
#import "GLBBatchModel.h"
#import "GLBCountTFView.h"

static NSString *const listCellID = @"UICollectionViewCell";

@interface GLBAddShoppingCarController ()<UICollectionViewDelegate,UICollectionViewDataSource,GLBEditCountViewDelegate>
{
    CGFloat _spacing;
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *fullLabel;
@property (nonatomic, strong) UILabel *fullPriceLabel;
@property (nonatomic, strong) UILabel *fullOldPriceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *retailLabel;
@property (nonatomic, strong) UILabel *retailPriceLabel;
@property (nonatomic, strong) UILabel *retailOldPriceLabel;
@property (nonatomic, strong) UILabel *batchLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *inventoryLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *buyCountLabel;
@property (nonatomic, strong) GLBEditCountView *countView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *priceTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *commintBtn;
@property (nonatomic, strong) GLBCountTFView *countTFView;

@property (nonatomic, strong) NSMutableArray<GLBBatchListModel *> *dataArray;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) GLBBatchModel *batchModel;


@property (nonatomic, assign) NSInteger minCount; // 当前模式下的最小起订量
@property (nonatomic, assign) NSInteger changeCount; // 每次加减最小值，必须是整数倍
@property (nonatomic, assign) NSInteger defaultCount; // 输入框默认数量

@property (nonatomic, assign) NSInteger wholeMineCount; // 整件盒数 两种销售方式并存时使用，大于该数量时使用整件价，否则使用单件价
@property (nonatomic, assign) CGFloat zeroPrice; // 当前的零售
@property (nonatomic, assign) CGFloat wholePrice; // 当前的整件价

@end

@implementation GLBAddShoppingCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self setUpUI];
    
    if (_detailModel) {
        [self requestBatchList:_detailModel.batchId isExchange:YES];
    }
    
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    
    if (![cell.contentView.subviews.lastObject isKindOfClass:[UILabel class]]) {
        
        UILabel *label = [[UILabel alloc] init];
        [label dc_cornerRadius:4];
        label.font = PFRFont(12);
//        label.text = @"2019776";
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
    }
    
    UILabel *label = cell.contentView.subviews.lastObject;
    label.text = [self.dataArray[indexPath.item] batchNum];
    
    if (_selectIndexPath && _selectIndexPath == indexPath) {
        label.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
        label.textColor = [UIColor dc_colorWithHexString:@"#FFFFFF"];
    } else {
        label.backgroundColor = [UIColor dc_colorWithHexString:@"#F0F2F2"];
        label.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndexPath && _selectIndexPath == indexPath) {
        return;
    }
    
    [self requestBatchList:[self.dataArray[indexPath.row] batchId] isExchange:NO];
    
    _selectIndexPath = indexPath;
    [collectionView reloadData];
}


#pragma mark - <GLBEditCountViewDelegate>
- (void)dc_countAddWithCountView:(GLBEditCountView *)countView {
    NSInteger count = [countView.countTF.text integerValue];
    count += _changeCount;
    countView.countTF.text = [NSString stringWithFormat:@"%ld",count];
    
    [self dc_calculatePrice];
}

- (void)dc_countSubWithCountView:(GLBEditCountView *)countView {
    NSInteger count = [countView.countTF.text integerValue];
    count -= _changeCount;
    if (count < _minCount) {
        [SVProgressHUD showInfoWithStatus:@"不能少于最小起订量"];
        return;
    }
    countView.countTF.text = [NSString stringWithFormat:@"%ld",count];
    
    [self dc_calculatePrice];
}

- (void)dc_countChangeWithCountView:(GLBEditCountView *)countView {
    if (![DC_KeyWindow.subviews containsObject:self.countTFView]) {
        [DC_KeyWindow addSubview:self.countTFView];
        self.countTFView.textField.text = countView.countTF.text;
        [self.countTFView.textField becomeFirstResponder];
        [self.countTFView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
    }
}


#pragma mark - 数量改变
- (void)dc_countChange
{
    NSInteger count = [_countTFView.textField.text integerValue];
    if (count < _minCount) {
        [SVProgressHUD showInfoWithStatus:@"不能少于最小起订量"];
        return;
    }
    
    NSInteger index = count % _changeCount;
    if (index != 0) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"数量必须是%ld的整数倍",_changeCount]];
        return;
    }
    
    _countView.countTF.text = [NSString stringWithFormat:@"%ld",count];
    
    [self dc_calculatePrice];
}



#pragma mark - action
- (void)commintBtnClick:(UIButton *)button
{
    if (!_selectIndexPath || _selectIndexPath.item < 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择商品批次"];
        return;
    }
    
    if ([_countView.countTF.text integerValue] < 1) {
        [SVProgressHUD showInfoWithStatus:@"请输入商品数量"];
        return;
    }
    
    [self requestAddShoppingCar];
}

- (void)cancelBtnClick:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.view removeFromSuperview];
}


#pragma mark - 请求 获取批次列表
- (void)requestBatchList:(NSString *)batchId isExchange:(BOOL)isChange
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestBatchListWithGoodsId:_detailModel.goodsId batchId:batchId success:^(id response) {
        if (response && [response isKindOfClass:[GLBBatchModel class]]) {
            weakSelf.batchModel = (GLBBatchModel *)response;
            
            if (isChange) {
                [weakSelf.dataArray removeAllObjects];
                GLBBatchListModel *listModel = [GLBBatchListModel new];
                listModel.batchId = weakSelf.batchModel.batchId;
                listModel.batchNum = weakSelf.batchModel.batchNum;
                [weakSelf.dataArray addObject:listModel];
                [weakSelf.dataArray addObjectsFromArray:weakSelf.batchModel.batchList];
            }
            [weakSelf dc_reloadData];
            
        } else {
//            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.view removeFromSuperview];
        }
        
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark - 请求 加入购物车
- (void)requestAddShoppingCar
{
    NSString *batchId = [self.dataArray[_selectIndexPath.item] batchId];
    NSString *goodsId= _detailModel.goodsId;
    NSInteger count = [_countView.countTF.text integerValue];
    
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestAddShoppingCarWithBatchId:batchId goodsId:goodsId quantity:count success:^(id response) {
        if (response) {
            [SVProgressHUD showSuccessWithStatus:@"加入成功"];
            if (weakSelf.successBlock) {
                weakSelf.successBlock();
            }
            [weakSelf cancelBtnClick:nil];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}


#pragma mark -
- (void)dc_reloadData
{
    if (self.batchModel) {
        
        _inventoryLabel.text = [NSString stringWithFormat:@"库存：%@",self.batchModel.stock];
        _endTimeLabel.text = [NSString stringWithFormat:@"有效期至：%@",self.batchModel.effectTime];
        
        if (self.batchModel.isSale && [self.batchModel.isSale isEqualToString:@"1"]) { // 是促销
            _retailOldPriceLabel.hidden = NO;
            _fullOldPriceLabel.hidden = NO;
            
            _fullPriceLabel.text = [NSString stringWithFormat:@"￥%.3f",_batchModel.saleWholePrice];
            _fullPriceLabel = [UILabel setupAttributeLabel:_fullPriceLabel textColor:_fullPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

            _retailPriceLabel.text = [NSString stringWithFormat:@"￥%.3f",_batchModel.saleZeroPrice];
            _retailPriceLabel = [UILabel setupAttributeLabel:_retailPriceLabel textColor:_retailPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];

            _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" ¥%.3f ",_batchModel.wholePrice]];
            _fullOldPriceLabel = [UILabel setupAttributeLabel:_fullOldPriceLabel textColor:_fullOldPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
            _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:[NSString stringWithFormat:@" ¥%.3f ",_batchModel.zeroPrice]];
            _retailOldPriceLabel = [UILabel setupAttributeLabel:_retailOldPriceLabel textColor:_retailOldPriceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
            
            _zeroPrice = _batchModel.saleZeroPrice; // 整件价
            _wholePrice = _batchModel.saleWholePrice; // 单件价
            
            if (self.detailModel.sellType == 2) { // 整售
                _retailLabel.hidden = YES;
                _retailPriceLabel.hidden = YES;
                _retailOldPriceLabel.hidden = YES;
                _fullLabel.hidden = NO;
                _fullPriceLabel.hidden = NO;
                _fullOldPriceLabel.hidden = NO;
                
                if (_batchModel.wholePrice == 0) {
                    _fullLabel.hidden = YES;
                    _fullPriceLabel.hidden = YES;
                    _fullOldPriceLabel.hidden = YES;
                }
                
            } else if (self.detailModel.sellType == 4) { // 零售
                _retailLabel.hidden = NO;
                _retailPriceLabel.hidden = NO;
                _retailOldPriceLabel.hidden = NO;
                _fullLabel.hidden = YES;
                _fullPriceLabel.hidden = YES;
                _fullOldPriceLabel.hidden = YES;
                
                if (_batchModel.zeroPrice == 0) {
                    _retailLabel.hidden = YES;
                    _retailPriceLabel.hidden = YES;
                    _retailOldPriceLabel.hidden = YES;
                }
                
            } else if (self.detailModel.sellType == 3) { // 零售+整售
                _retailLabel.hidden = NO;
                _retailPriceLabel.hidden = NO;
                _retailOldPriceLabel.hidden = NO;
                _fullLabel.hidden = NO;
                _fullPriceLabel.hidden = NO;
                _fullOldPriceLabel.hidden = NO;
                
                if (_batchModel.wholePrice == 0) {
                    _fullLabel.hidden = YES;
                    _fullPriceLabel.hidden = YES;
                    _fullOldPriceLabel.hidden = YES;
                }
                
                if (_batchModel.zeroPrice == 0) {
                    _retailLabel.hidden = YES;
                    _retailPriceLabel.hidden = YES;
                    _retailOldPriceLabel.hidden = YES;
                }
            }
            
        } else { // 非促销
            
            _retailOldPriceLabel.hidden = YES;
            _fullOldPriceLabel.hidden = YES;
            
            _fullPriceLabel.text = [NSString stringWithFormat:@"￥%.3f",_batchModel.wholePrice];
            _retailPriceLabel.text = [NSString stringWithFormat:@"￥%.3f",_batchModel.zeroPrice];
            
            _zeroPrice = _batchModel.zeroPrice; // 整件价
            _wholePrice = _batchModel.wholePrice; // 单件价
            
            
            if (self.detailModel.sellType == 2) { // 整售
                _retailLabel.hidden = YES;
                _retailPriceLabel.hidden = YES;
                _fullLabel.hidden = NO;
                _fullPriceLabel.hidden = NO;
                
                if (_batchModel.wholePrice == 0) {
                    _fullLabel.hidden = YES;
                    _fullPriceLabel.hidden = YES;
                }
                
            } else if (self.detailModel.sellType == 4) { // 零售
                _retailLabel.hidden = NO;
                _retailPriceLabel.hidden = NO;
                _fullLabel.hidden = YES;
                _fullPriceLabel.hidden = YES;
                
                if (_batchModel.zeroPrice == 0) {
                    _retailLabel.hidden = YES;
                    _retailPriceLabel.hidden = YES;
                }
                
            } else if (self.detailModel.sellType == 3) { // 零售+整售
                _retailLabel.hidden = NO;
                _retailPriceLabel.hidden = NO;
                _fullLabel.hidden = NO;
                _fullPriceLabel.hidden = NO;
                
                if (_batchModel.wholePrice == 0) {
                    _fullLabel.hidden = YES;
                    _fullPriceLabel.hidden = YES;
                }
                
                if (_batchModel.zeroPrice == 0) {
                    _retailLabel.hidden = YES;
                    _retailPriceLabel.hidden = YES;
                }
            }
        }
        
        
        if (self.detailModel.sellType == 2) { // 整售
            
            NSInteger pkgPack = [_detailModel.pkgPackingNum integerValue]; // 件装量
            NSInteger wholeMin = [_detailModel.wholeMinBuyNum integerValue]; // 整件最小起订量
            _minCount = wholeMin;
            _defaultCount = pkgPack*wholeMin;
            _changeCount = pkgPack;
            
        } else if (self.detailModel.sellType == 4) { // 零售
            
            if ([self.detailModel.zeroSellType isEqualToString:@"1"]) { // 拆零中包
                
                if ([self.detailModel.zeroMinType isEqualToString:@"1"]) { // 最小起订量按数量计算
                    
                    NSInteger pkgPack = [_detailModel.zeroPackNum integerValue]; // 中包件装量
                    NSInteger zeroMin = [_detailModel.zeroMinBuy integerValue]; // 整件最小起订量
                    _minCount = zeroMin;
                    _changeCount = pkgPack;
                    _defaultCount = pkgPack*zeroMin;
                    
                } else if ([self.detailModel.zeroMinType isEqualToString:@"2"]) { // 最小起订量按金额计算

                    NSInteger pkgPack = [_detailModel.zeroPackNum integerValue]; // 中包件装量
                    CGFloat minMoney = [_detailModel.zeroMinBuy floatValue]; // 最小起订金额
                    CGFloat price = _zeroPrice; // 零售单价
                    CGFloat count = minMoney / price;
                    NSInteger minCount = count;
                    NSString *string = [[NSString stringWithFormat:@"%.f",count] componentsSeparatedByString:@"."][1];
                    if ([string floatValue] > 0) {
                        minCount += 1;
                    } // 最小起订量
   
                    _minCount = minCount;
                    _defaultCount = pkgPack;
                    _changeCount = pkgPack;

                }
                
            } else if ([self.detailModel.zeroSellType isEqualToString:@"2"]) { // 拆零小包
            
                if ([self.detailModel.zeroMinType isEqualToString:@"1"]) { // 最小起订量按数量计算
                    
                    NSInteger zeroMin = [_detailModel.zeroMinBuy integerValue]; // 单买最小起订量
                    _defaultCount = 1;
                    _changeCount = 1;
                    _minCount = zeroMin;
                    
                } else if ([self.detailModel.zeroMinType isEqualToString:@"2"]) { // 最小起订量按金额计算
                    
                    CGFloat minMoney = [_detailModel.zeroMinBuy floatValue]; // 最小起订金额
                    CGFloat price = _zeroPrice; // 单价
                    CGFloat count = minMoney / price;
                    NSInteger minCount = count; // 最小起订量
                    
                    NSString *string = [NSString stringWithFormat:@"%.f",count];
                    if ([string containsString:@"."]) {
                        string = [[NSString stringWithFormat:@"%.f",count] componentsSeparatedByString:@"."][1];
                    }
                    
                    if ([string floatValue] > 0) {
                        minCount += 1;
                    }
                    
                    _defaultCount = 1;
                    _changeCount = 1;
                    _minCount = minCount;
                }
            }
            
        } else if (self.detailModel.sellType == 3) { // 整售+零售并存
            
            NSInteger pkgPack = [_detailModel.pkgPackingNum integerValue]; // 件装量
            NSInteger wholeMin = [_detailModel.wholeMinBuyNum integerValue]; // 整件最小起订量
            _wholeMineCount = pkgPack*wholeMin;
            
            if ([self.detailModel.zeroSellType isEqualToString:@"1"]) { // 拆零中包
                
                if ([self.detailModel.zeroMinType isEqualToString:@"1"]) { // 最小起订量按数量计算
                    
                    NSInteger pkgPack = [_detailModel.zeroPackNum integerValue]; // 中包件装量
                    NSInteger zeroMin = [_detailModel.zeroMinBuy integerValue]; // 整件最小起订量
                    _minCount = zeroMin;
                    _changeCount = pkgPack;
                    _defaultCount = pkgPack*zeroMin;
                    
                } else if ([self.detailModel.zeroMinType isEqualToString:@"2"]) { // 最小起订量按金额计算
                    
                    NSInteger pkgPack = [_detailModel.zeroPackNum integerValue]; // 中包件装量
                    CGFloat minMoney = [_detailModel.zeroMinBuy floatValue]; // 最小起订金额
                    CGFloat price = _zeroPrice; // 零售单价
                    CGFloat count = minMoney / price;
                    NSInteger mineCount = (NSInteger)count; // 最小起订量
                    
                    NSString *string = [NSString stringWithFormat:@"%.f",count];
                    if ([string containsString:@"."]) {
                        string = [[NSString stringWithFormat:@"%.f",count] componentsSeparatedByString:@"."][1];
                    }
                    if ([string floatValue] > 0) {
                        mineCount = count + 1;
                    }
 
                    _minCount = mineCount;
                    _defaultCount = pkgPack;
                    _changeCount = pkgPack;
                    
                }
                
            } else if ([self.detailModel.zeroSellType isEqualToString:@"2"]) { // 拆零小包
                
                if ([self.detailModel.zeroMinType isEqualToString:@"1"]) { // 最小起订量按数量计算
                    
                    NSInteger zeroMin = [_detailModel.zeroMinBuy integerValue]; // 单买最小起订量
                    _defaultCount = 1;
                    _changeCount = 1;
                    _minCount = zeroMin;
                    
                } else if ([self.detailModel.zeroMinType isEqualToString:@"2"]) { // 最小起订量按金额计算
                    
                    CGFloat minMoney = [_detailModel.zeroMinBuy floatValue]; // 最小起订金额
                    CGFloat price = _zeroPrice; // 单价
                    CGFloat count = minMoney / price;
                    NSInteger mineCount = (NSInteger)count; // 最小起订量
                    
                    NSString *string = [NSString stringWithFormat:@"%.f",count];
                    if ([string containsString:@"."]) {
                        string = [[NSString stringWithFormat:@"%.f",count] componentsSeparatedByString:@"."][1];
                    }
                    if ([string floatValue] > 0) {
                        mineCount = count + 1;
                    }
                    
                    _defaultCount = 1;
                    _changeCount = 1;
                    _minCount = mineCount;
                }
            }
        }
        
        _countView.countTF.text = [NSString stringWithFormat:@"%ld",_defaultCount]; //初始值
        [self dc_calculatePrice];
    }
    
    [self.collectionView reloadData];
    [self updateMasonry];
}


#pragma mark - 计算价格
- (void)dc_calculatePrice
{
    CGFloat allPrice = 0.0f;
    UIImage *image = nil;
    if (self.detailModel.sellType == 3) { // 整 + 零
        if ([_countView.countTF.text integerValue] >= _wholeMineCount) { // 超过整售数量了

            allPrice = _wholePrice *[_countView.countTF.text integerValue];
            image = [UIImage imageNamed:@"zheng"];
            
        } else {
            
            allPrice = _zeroPrice *[_countView.countTF.text integerValue];
            image = [UIImage imageNamed:@"ling"];
        }
        
    } else if (self.detailModel.sellType == 2) { // 整售
        
        allPrice = _wholePrice *[_countView.countTF.text integerValue];
        image = [UIImage imageNamed:@"zheng"];
        
    } else if (self.detailModel.sellType == 4) { // 零售
        
        allPrice = _zeroPrice *[_countView.countTF.text integerValue];
        image = [UIImage imageNamed:@"ling"];
    }
    
    _iconImage.image = image;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",allPrice];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:_priceLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
}


#pragma mark - setUpUI
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.5];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:16];
    _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setImage:[UIImage imageNamed:@"dc_scy_hui"] forState:0];
    _cancelBtn.adjustsImageWhenHighlighted = NO;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _fullLabel = [[UILabel alloc] init];
    _fullLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _fullLabel.font = [UIFont fontWithName:PFR size:13];
    _fullLabel.text = @"整件单价：";
    [_scrollView addSubview:_fullLabel];
    
    _fullPriceLabel = [[UILabel alloc] init];
    _fullPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _fullPriceLabel.font = [UIFont fontWithName:PFR size:18];
//    _fullPriceLabel.text = @"￥1055.880";
    [_scrollView addSubview:_fullPriceLabel];
    
    _fullOldPriceLabel = [[UILabel alloc] init];
    _fullOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _fullOldPriceLabel.font = [UIFont fontWithName:PFR size:11];
    _fullOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥0.00  "];
    [_scrollView addSubview:_fullOldPriceLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _countLabel.font = [UIFont fontWithName:PFR size:13];
    [_scrollView addSubview:_countLabel];
    
    _retailLabel = [[UILabel alloc] init];
    _retailLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _retailLabel.font = [UIFont fontWithName:PFR size:13];
    _retailLabel.text = @"拆零单价：";
    [_scrollView addSubview:_retailLabel];
    
    _retailPriceLabel = [[UILabel alloc] init];
    _retailPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _retailPriceLabel.font = [UIFont fontWithName:PFR size:18];
    _retailPriceLabel.text = @"￥0.00";
    [_scrollView addSubview:_retailPriceLabel];
    
    _retailOldPriceLabel = [[UILabel alloc] init];
    _retailOldPriceLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _retailOldPriceLabel.font = [UIFont fontWithName:PFR size:11];
    _retailOldPriceLabel.attributedText = [NSString dc_strikethroughWithString:@"  ￥0.00  "];
    [_scrollView addSubview:_retailOldPriceLabel];
    
    _batchLabel = [[UILabel alloc] init];
    _batchLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _batchLabel.font = [UIFont fontWithName:PFR size:13];
    _batchLabel.text = @"商品批次";
    [_scrollView addSubview:_batchLabel];
    
    _spacing = 10;
    _itemW = (kScreenW - 15*2 - _spacing*3)/4;
    _itemH = 27;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = _spacing;
    flowLayout.minimumInteritemSpacing = _spacing;
    flowLayout.itemSize = CGSizeMake(_itemW, _itemH);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString(listCellID) forCellWithReuseIdentifier:listCellID];
    [_scrollView addSubview:_collectionView];
    
    _inventoryLabel = [[UILabel alloc] init];
    _inventoryLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _inventoryLabel.font = [UIFont fontWithName:PFR size:13];
    _inventoryLabel.text = @"库存：0";
    [_scrollView addSubview:_inventoryLabel];
    
    _endTimeLabel = [[UILabel alloc] init];
    _endTimeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _endTimeLabel.font = [UIFont fontWithName:PFR size:13];
    _endTimeLabel.text = @"有效期至 -";
    _endTimeLabel.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_endTimeLabel];
    
    _buyCountLabel = [[UILabel alloc] init];
    _buyCountLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _buyCountLabel.font = [UIFont fontWithName:PFR size:13];
    _buyCountLabel.text = @"购买数量";
    [_scrollView addSubview:_buyCountLabel];
    
    _countView = [[GLBEditCountView alloc] init];
    _countView.delegate = self;
    [_scrollView addSubview:_countView];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.image = [UIImage imageNamed:@"ling"];
    [_scrollView addSubview:_iconImage];
    
    _priceTitleLabel = [[UILabel alloc] init];
    _priceTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _priceTitleLabel.font = [UIFont fontWithName:PFR size:13];
    _priceTitleLabel.text = @"单品合计：";
    [_scrollView addSubview:_priceTitleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:@"#FF4D0A"];
    _priceLabel.font = [UIFont fontWithName:PFRMedium size:18];
    _priceLabel.text = @"￥0";
    [_scrollView addSubview:_priceLabel];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _tipLabel.font = [UIFont fontWithName:PFR size:12];
    _tipLabel.text = @"0起配，还差0元";
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.hidden = YES;
    [_scrollView addSubview:_tipLabel];
    
    _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commintBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#00B7AB"];
    [_commintBtn setTitle:@"确定" forState:0];
    [_commintBtn setTitleColor:[UIColor whiteColor] forState:0];
    _commintBtn.titleLabel.font = PFRFont(16);
    [_commintBtn addTarget:self action:@selector(commintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commintBtn];
    
    _retailOldPriceLabel.hidden = YES;
    _fullOldPriceLabel.hidden = YES;
    if (self.detailModel) {
        _titleLabel.text = _detailModel.goodsName;
        _fullPriceLabel.text = [NSString stringWithFormat:@"￥%@",_detailModel.wholePrice];
        _retailPriceLabel.text = [NSString stringWithFormat:@"￥%@",_detailModel.zeroPrice];
        
        _countLabel.text = [NSString stringWithFormat:@"%@盒/件",_detailModel.pkgPackingNum];
        _inventoryLabel.text = [NSString stringWithFormat:@"库存:%@",@"0"];
        _endTimeLabel.text = [NSString stringWithFormat:@"有效期至:%@",[[DCHelpTool shareClient] dc_setValue:_detailModel.expireDate]];
        _countView.countTF.text = @"1";
    }
    
    [self updateMasonry];
}


#pragma mark - updateMasonry
- (void)updateMasonry
{
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(45);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.commintBtn.top);
        make.height.equalTo(340);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.right.equalTo(self.bgView.right).offset(-15);
        make.top.equalTo(self.bgView.top).offset(15);
//        make.width.equalTo(kScreenW - 15*2);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.top);
        make.right.equalTo(self.bgView.right);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.commintBtn.top);
        make.top.equalTo(self.titleLabel.bottom).offset(15);
    }];

    
    [_fullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.top.equalTo(self.scrollView.top).offset(10);
    }];
    
    [_fullPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullLabel.right).offset(13);
        make.centerY.equalTo(self.fullLabel.centerY);
    }];
    
    [_fullOldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullPriceLabel.right).offset(13);
        make.centerY.equalTo(self.fullPriceLabel.centerY);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.fullOldPriceLabel.right).offset(5);
        make.centerY.equalTo(self.fullPriceLabel.centerY);
        make.right.equalTo(self.scrollView.right).offset(-15);
        make.width.lessThanOrEqualTo(100);
    }];
    
    [_retailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.top.equalTo(self.fullLabel.bottom).offset(12);
    }];
    
    [_retailPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailLabel.right).offset(13);
        make.centerY.equalTo(self.retailLabel.centerY);
    }];
    
    [_retailOldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.retailPriceLabel.right).offset(13);
        make.centerY.equalTo(self.retailLabel.centerY);
    }];
    
    [_batchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.top.equalTo(self.retailLabel.bottom).offset(15);
    }];
    
    NSInteger line = 0;
    if (self.dataArray.count > 0) {
        line = (self.dataArray.count - 1)/4 + 1;
    }
    CGFloat height = 0;
    if (line > 0) {
        height = line*_itemH + (line-1)*_spacing;
    }
    
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.right.equalTo(self.scrollView.right).offset(-15);
        make.top.equalTo(self.batchLabel.bottom).offset(10);
        make.height.equalTo(height);
        make.width.equalTo(kScreenW - 30);
    }];
    
    [_inventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.top.equalTo(self.collectionView.bottom).offset(20);
    }];
    
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inventoryLabel.centerY);
//       make.top.equalTo(self.collectionView.bottom).offset(20);
        make.right.equalTo(self.scrollView.right).offset(-15);
        make.width.equalTo(150);
    }];

    [_buyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.top.equalTo(self.inventoryLabel.bottom).offset(20);
    }];
    
    [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.right).offset(-15);
        make.centerY.equalTo(self.buyCountLabel.centerY);
        make.size.equalTo(CGSizeMake(100, 40));
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.right).offset(-15);
        make.top.equalTo(self.buyCountLabel.bottom).offset(30);
    }];
    
    [_priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.centerY);
        make.right.equalTo(self.priceLabel.left);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceTitleLabel.left).offset(-5);
        make.centerY.equalTo(self.priceTitleLabel.centerY);
        make.size.equalTo(CGSizeMake(16, 16));
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.right.equalTo(self.scrollView.right).offset(-15);
        make.top.equalTo(self.priceLabel.bottom).offset(5);
        make.bottom.equalTo(self.scrollView.bottom).offset(-15);
    }];
}



#pragma mark - lazy load
- (GLBCountTFView *)countTFView{
    if (!_countTFView) {
        _countTFView = [[GLBCountTFView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        WEAKSELF;
        _countTFView.successBlock = ^{
            [weakSelf dc_countChange];
        };
    }
    return _countTFView;
}

- (NSMutableArray<GLBBatchListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
