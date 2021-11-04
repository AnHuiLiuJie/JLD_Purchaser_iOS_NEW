//
//  GLPGoodsDetailsRecommendCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsRecommendCell.h"
#import "GLPGoodsDetailsRecommendFlowLayout.h"
//#import "CommonPageControl.h"

static NSString *const linstCellID = @"GLPGoodsDetailsRecommendGoodsCell";

@interface GLPGoodsDetailsRecommendCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *iconView;

//@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) GLPGoodsDetailsRecommendFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation GLPGoodsDetailsRecommendCell

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
    
    _bgView = [[UIView alloc] init];
    [self.contentView  addSubview:_bgView];
    
    _spacing = 10;
    NSInteger width = (kScreenW - 15*2 - _spacing *2)/3;
    _itemW = width;
    _itemH = _itemW + 30 + 30;
    
//    _titleImage = [[UIImageView alloc] init];
//    _titleImage.image = [UIImage imageNamed:@"dc_dprx"];
//    _titleImage.hidden = YES;
//    [self.bgView addSubview:_titleImage];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:16];
    [self.bgView  addSubview:_titleLab];

    _iconView = [[UIView alloc] init];
    _iconView.bounds = CGRectMake(0, 0, 5, 20);
    [self.bgView  addSubview:_iconView];
    
    _flowLayout = [[GLPGoodsDetailsRecommendFlowLayout alloc] init];
    _flowLayout.itemSize = CGSizeMake(_itemW, _itemH);
    _flowLayout.minimumLineSpacing = _spacing;
    _flowLayout.minimumInteritemSpacing = _spacing;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:NSClassFromString(linstCellID) forCellWithReuseIdentifier:linstCellID];
    [self.bgView addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] init];
//    _pageControl.numberOfPages = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor dc_colorWithHexString:@"#00BDB2"];
    _pageControl.pageIndicatorTintColor = [UIColor dc_colorWithHexString:@"#E2E2E2"];
    [self.contentView addSubview:_pageControl];
    
    NSArray *clolor1 = [NSArray arrayWithObjects:
        (id)[UIColor dc_colorWithHexString:@"#00BCB1" alpha:1].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#DBFFFD" alpha:1].CGColor,
        (id)[UIColor dc_colorWithHexString:@"#DBFFFD" alpha:0.8].CGColor,nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setColors:clolor1];//渐变数组
    gradientLayer.startPoint = CGPointMake(0,0);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    gradientLayer.endPoint = CGPointMake(1,1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    gradientLayer.locations = @[@(0),@(1.0)];//渐变点
    gradientLayer.frame = CGRectMake(0,0,5,20);
    [self.iconView.layer insertSublayer:gradientLayer atIndex:0];//注意添加顺序 使用这个方法则不许要考虑在addSubview前不进行属性操作
    [self.iconView dc_cornerRadius:2];

    [self layoutIfNeeded];
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLPGoodsDetailsRecommendGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:linstCellID forIndexPath:indexPath];
    cell.lickGoodsModel = self.dataArray[indexPath.section][indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GLPGoodsLickGoodsModel *goodsModel = self.dataArray[indexPath.section][indexPath.item];
    if (_recommendCellBlock) {
        _recommendCellBlock(goodsModel);
    }
}


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView==self.collectionView)
    {
        int  index = self.collectionView.contentOffset.x / (kScreenW - 15*2*(_pageControl.currentPage+1));
        _pageControl.currentPage = index;
    }
}


#pragma mark -
- (void)layoutSubviews {
    //[super layoutSubviews];
    
    CGFloat spacing = _spacing;
    CGFloat itemH = _itemH;
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.top.equalTo(self.bgView.top).offset(15);
        make.size.equalTo(CGSizeMake(5, 20));
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.right).offset(5);
        make.centerY.equalTo(self.iconView.centerY);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.right.equalTo(self.bgView.right).offset(-15);
        make.top.equalTo(self.iconView.bottom).offset(10);
        make.height.equalTo(itemH *2 + spacing);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.centerX);
        make.top.equalTo(self.collectionView.bottom).offset(5);
        make.bottom.equalTo(self.bgView.bottom).offset(-15);
//        make.size.equalTo(CGSizeMake(200, 10));
    }];
    
    CGFloat hight = CGRectGetMaxY(self.pageControl.frame);
    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(hight+5).priorityHigh();
//        make.height.equalTo(hight+8).priorityHigh();
    }];
}


#pragma mark -
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



#pragma mark - setter
- (void)setLickModel:(GLPGoodsLickModel *)lickModel
{
    _lickModel = lickModel;
    
    [self.dataArray removeAllObjects];
    if (_lickModel && _lickModel.goodsList && _lickModel.goodsList.count > 0) {
        
        NSInteger count = (_lickModel.goodsList.count - 1) / 6 + 1;
        NSMutableArray *newArray = [NSMutableArray array];
        for (int i=0; i<count; i++) {
            NSMutableArray *subArray = [NSMutableArray array];
            if (i == count - 1) {
                
                NSInteger length = _lickModel.goodsList.count - i*6;
                [subArray addObjectsFromArray:[_lickModel.goodsList subarrayWithRange:NSMakeRange(i*6, length)]];
                
            } else {
                
                [subArray addObjectsFromArray:[_lickModel.goodsList subarrayWithRange:NSMakeRange(i*6, 6)]];
                
            }
            
            [newArray addObject:subArray];
        }
        
        _pageControl.numberOfPages = count;
//        _pageControl.currentPage = 0;
        [self.dataArray addObjectsFromArray:newArray];
    }
    
    _titleLab.text = _lickModel.hotGoodsTitle;
    
    [self.collectionView reloadData];
    
}



@end




#pragma mark - 商品
@interface GLPGoodsDetailsRecommendGoodsCell ()

@property (nonatomic, strong) UIImageView *goodsImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
//@property (nonatomic, strong) UILabel *sellCountLabel;

@end

@implementation GLPGoodsDetailsRecommendGoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    _goodsImage.clipsToBounds = YES;
    [self.contentView addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:PFR size:14];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.text = @"";
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont fontWithName:PFRMedium size:7];
    _priceLabel.textColor = [UIColor dc_colorWithHexString:DC_FailureStatusColor];
    _priceLabel.text = @"¥0";
    [self.contentView addSubview:_priceLabel];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
//    _sellCountLabel = [[UILabel alloc] init];
//    _sellCountLabel.font = [UIFont fontWithName:PFR size:12];
//    _sellCountLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
//    _sellCountLabel.text = @"月销0件";
//    _sellCountLabel.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:_sellCountLabel];
    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.centerX.equalTo(self.contentView.centerX);
        make.width.height.equalTo(self.contentView.width).multipliedBy(0.8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.goodsImage.bottom).offset(2);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.bottom).offset(-5);
        //make.top.equalTo(self.titleLabel.bottom).offset(3);
        make.width.lessThanOrEqualTo(60);
        make.left.equalTo(self.titleLabel.left);
       // make.centerX.equalTo(self.contentView.centerX);
    }];
    
//    [_sellCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.priceLabel.centerY);
//        make.right.equalTo(self.contentView.right);
//        make.left.equalTo(self.priceLabel.right);
//    }];
    
}


#pragma mark - setter
- (void)setLickGoodsModel:(GLPGoodsLickGoodsModel *)lickGoodsModel
{
    _lickGoodsModel = lickGoodsModel;
    
    _titleLabel.text = lickGoodsModel.goodsTitle;
    
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:_lickGoodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_lickGoodsModel.sellPrice];
    _priceLabel = [UILabel setupAttributeLabel:_priceLabel textColor:nil minFont: [UIFont fontWithName:PFR size:10] maxFont: [UIFont fontWithName:PFRMedium size:16] forReplace:@"¥"];
    //_sellCountLabel.text = [NSString stringWithFormat:@"月销%@件",_lickGoodsModel.totalSales];
}

@end
