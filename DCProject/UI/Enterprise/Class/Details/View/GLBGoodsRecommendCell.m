//
//  GLBGoodsRecommendCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsRecommendCell.h"

static NSString *const listCellID = @"UICollectionViewCell";

@interface GLBGoodsRecommendCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _itemW;
    CGFloat _itemH;
    CGFloat _spacing;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<GLBGoodsDetailGoodsModel *> *dataArray;

@end

@implementation GLBGoodsRecommendCell

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
    
    _spacing = 10;
    _itemW = 90;
    _itemH = _itemW + 20;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLabel.text = @"购买此商品的用户还购买了";
    [self.contentView addSubview:_titleLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = _spacing;
    flowLayout.minimumInteritemSpacing = _spacing;
    flowLayout.itemSize = CGSizeMake(_itemW, _itemH);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:NSClassFromString(listCellID) forCellWithReuseIdentifier:listCellID];
    [self.contentView addSubview:_collectionView];
    
    [self layoutIfNeeded];
    
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    if (![cell.contentView.subviews.lastObject isKindOfClass:[UIImageView class]]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor dc_colorWithHexString:@"#FF9900"];
        label.font = PFRFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [cell.contentView addSubview:image];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.left);
            make.right.equalTo(cell.contentView.right);
            make.bottom.equalTo(cell.contentView.bottom);
            make.height.equalTo(20);
        }];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(label.top).offset(-10);
            make.left.equalTo(cell.contentView.left).offset(10);
            make.right.equalTo(cell.contentView.right).offset(-10);
            make.top.equalTo(cell.contentView.top).offset(10);
        }];
    }
    
    UILabel *label = cell.contentView.subviews.firstObject;
    UIImageView *image = cell.contentView.subviews.lastObject;
    
    GLBGoodsDetailGoodsModel *goodsModel = self.dataArray[indexPath.item];
    label.text = [NSString stringWithFormat:@"¥%@",goodsModel.price];
    label = [UILabel setupAttributeLabel:label textColor:label.textColor minFont:nil maxFont:nil forReplace:@"¥"];
    image.layer.minificationFilter = kCAFilterTrilinear;

    [image sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImg] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GLBGoodsDetailGoodsModel *goodsModel = self.dataArray[indexPath.item];
    if (_recommendCellBlock) {
        _recommendCellBlock(goodsModel);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.size.equalTo(CGSizeMake(200, 36));
    }];
    
    
    CGFloat height = _itemH;
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.titleLabel.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-20);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(height);
    }];
    
    
}



#pragma mark - lazy load
- (NSMutableArray<GLBGoodsDetailGoodsModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - setter
- (void)setRecommendArray:(NSMutableArray<GLBGoodsDetailGoodsModel *> *)recommendArray
{
    _recommendArray = recommendArray;
    
    _titleLabel.text = @"商品推荐";
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_recommendArray];
    [self.collectionView reloadData];
}

- (void)setSimilarArray:(NSMutableArray<GLBGoodsDetailGoodsModel *> *)similarArray
{
    _similarArray = similarArray;
    
    _titleLabel.text = @"购买此商品的用户还购买了";
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_similarArray];
    [self.collectionView reloadData];
}

@end
