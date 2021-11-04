//
//  GLPEtpCenterFunctionalCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/12.
//

#import "GLPEtpCenterFunctionalCell.h"
#import "DCMoreGridCell.h"

static CGFloat const Title_Hight = 10;

@interface GLPEtpCenterFunctionalCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *topTitleView;

@property (strong, nonatomic) UIView *bgView;

/* collectioView */
@property (strong , nonatomic)UICollectionView *collectionView;

@end

static NSString *const DCMoreGridCellID = @"DCMoreGridCell";

@implementation GLPEtpCenterFunctionalCell

#pragma mark - LoadLazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *dcFlowLayout = [UICollectionViewFlowLayout new];
        dcFlowLayout.minimumLineSpacing = dcFlowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:dcFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[DCMoreGridCell class] forCellWithReuseIdentifier:DCMoreGridCellID];
        
        [_bgView addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIView *)topTitleView{
    if (!_topTitleView) {
        _topTitleView = [[UIView alloc] init];
        
        _title_label = [[UILabel alloc] init];
        _title_label.text = @"";//常用功能
        _title_label.textColor = RGB_COLOR(36, 36, 36);
        _title_label.font = [UIFont fontWithName:PFRMedium size:15];
        [_topTitleView addSubview:_title_label];
        
        [_bgView addSubview:_topTitleView];
    }
    return _topTitleView;
}


#pragma mark - Intial
- (void)awakeFromNib {
    [super awakeFromNib];
}

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
    
    self.bgView = [[UIView alloc] init];
    [DCSpeedy dc_changeControlCircularWith:_bgView AndSetCornerRadius:10 SetBorderWidth:0 SetBorderColor:nil canMasksToBounds:YES];
    [self.contentView addSubview:self.bgView];
    
    self.topTitleView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 5, 15));
    }];
    
    [_topTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_bgView) setOffset:0];
        [make.right.mas_equalTo(_bgView) setOffset:0];
        [make.top.mas_equalTo(_bgView) setOffset:0];
        make.height.mas_equalTo(Title_Hight);
    }];
    
    [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_topTitleView) setOffset:10];
        make.width.mas_equalTo(200);
        [make.top.mas_equalTo(_topTitleView) setOffset:5];
        make.height.mas_equalTo(Title_Hight);
    }];

    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_bgView) setOffset:0];
        [make.right.mas_equalTo(_bgView) setOffset:0];
        [make.top.mas_equalTo(_bgView) setOffset:Title_Hight];
        [make.bottom.mas_equalTo(_bgView)setOffset:0];
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _serviceItemArray.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DCMoreGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCMoreGridCellID forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.gridItem = _serviceItemArray[indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isPhone6below) {
        return CGSizeMake(_bgView.dc_width / 3, 72);
    }else{
        return CGSizeMake(_bgView.dc_width / 3, 80);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DCGridItem *model = _serviceItemArray[indexPath.row];
    !_stateItemItemClickBlock ? : _stateItemItemClickBlock(model.gridTitle);
}

- (void)setServiceItemArray:(NSMutableArray<DCGridItem *> *)serviceItemArray{
    _serviceItemArray = serviceItemArray;
    
    [_collectionView reloadData];
}

- (void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
}

- (void)setInforCount:(NSString *)InforCount{
     _InforCount = InforCount;
}


@end
