//
//  GLPHomeRecommendCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeRecommendCell.h"
#import "WSLWaterFlowLayout.h"
#import "GLPHomeGoodsItemCell.h"

#define kItemW (kScreenW - 14*2 - 10)/2

static NSString *const listCellID = @"GLPHomeGoodsItemCell";

@interface GLPHomeRecommendCell ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) WSLWaterFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<GLPHomeDataListModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray *heightArray;

@end

@implementation GLPHomeRecommendCell

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
    
    _headImage = [[UIImageView alloc] init];
    _headImage.image = [UIImage imageNamed:@"rediantuij"];
    [self.contentView addSubview:_headImage];
    
    _flowLayout = [[WSLWaterFlowLayout alloc] init];
    _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    _flowLayout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:NSClassFromString(listCellID) forCellWithReuseIdentifier:listCellID];
    [self.contentView addSubview:_collectionView];
    
    [self layoutSubviews];
}



#pragma mark - <WSLWaterFlowLayoutDelegate>
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self layoutSubviews];
    
    return CGSizeMake(kItemW, [self.heightArray[indexPath.item] floatValue]);
}


/** 列间距*/
- (CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return 10;
}
/** 行间距*/
- (CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return 10;
}

/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(0, 14, 0, 14);
}


#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLPHomeGoodsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    cell.listModel = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GLPHomeDataListModel *listmodel = self.dataArray[indexPath.item];
    if (self.recomblock) {
        self.recomblock(listmodel);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    //[super layoutSubviews];
    
    //0.5+0.14 = 0.54
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.contentView.top).offset(10);
        make.height.equalTo(0.4*kScreenW);
    }];
    
    CGFloat height = self.flowLayout.collectionView.contentSize.height;
    
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.headImage.bottom).offset(-0.14*kScreenW);
        make.bottom.equalTo(self.contentView.bottom).offset(-12);//lj_change_约束
        make.height.equalTo(height);
    }];
}


#pragma mark - lazy load
- (NSMutableArray<GLPHomeDataListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)heightArray{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}


#pragma mark - setter
- (void)setRecommendModel:(GLPHomeDataModel *)recommendModel
{
    _recommendModel = recommendModel;

    if (_recommendModel == nil) {
        return;
    }
    
    [self.dataArray removeAllObjects];
    if (_recommendModel.dataList && _recommendModel.dataList.count > 0) {
        [self.dataArray addObjectsFromArray:_recommendModel.dataList];
    }
    
    [self.heightArray removeAllObjects];
    for (int i=0; i<self.dataArray.count; i++) {
        
        CGFloat height = kItemW + 10 + 5 + 5 + 5  + 25 + 10;
        
        GLPHomeDataListModel *listModel = self.dataArray[i];
        GLPHomeDataGoodsModel *goodsModel = listModel.goodsVo;
        
        if (!goodsModel || (![goodsModel.isImport isEqualToString:@"1"] && ![goodsModel.isPromotion isEqualToString:@"1"] && ![goodsModel.isGroup isEqualToString:@"1"])) {
            
        } else {
            height += 20;
        }
        
        if (goodsModel && goodsModel.packingSpec.length > 0) {
            height += 17;
        }
        
        NSString *title = @"";
        if (listModel && listModel.subTitle && listModel.subTitle.length > 0) {
            title = listModel.subTitle;
        }
        if (title.length == 0) {
            title = listModel.infoTitle;
        }
        
        CGFloat titleHeight = [title boundingRectWithSize:CGSizeMake(kItemW - 16, 42) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:15]} context:nil].size.height;
        height += titleHeight;
        
        [self.heightArray addObject:@(height)];
    }
    [self layoutSubviews];
    [self.collectionView reloadData];

}


@end
