//
//  GLBZizhiListCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/29.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBZizhiListCell.h"
#import <YBImageBrowser/YBImageBrowser.h>

static NSString *const listCellID = @"UICollectionViewCell";

@interface GLBZizhiListCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _leftSapcing;
    CGFloat _spacing;
    NSInteger _itemW;
    NSInteger _itemH;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLBZizhiListCell

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
    
    [self.dataArray removeAllObjects];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#000000"];
    _titleLabel.font = PFRFont(13);
    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _leftSapcing = 15;
    _spacing = 10;
    _itemW = (kScreenW - _leftSapcing*2 - _spacing*2)/3;
    _itemH = 0.72*_itemW;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(_itemW, _itemH);
    flowLayout.minimumLineSpacing = _spacing;
    flowLayout.minimumInteritemSpacing = _spacing;
    
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
    
    if (![cell.contentView.subviews.lastObject isKindOfClass:[UIButton class]]) {
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [cell.contentView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    
    UIImageView *image = cell.contentView.subviews.firstObject;
    [image sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item]] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 查看大图
    [self dc_showBigImage:indexPath];
}


#pragma mark - 查看大图
- (void)dc_showBigImage:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        // 网络图片
        YBIBImageData *data0 = [YBIBImageData new];
        data0.imageURL = self.dataArray[i];
        [array addObject:data0];
    }
    // 设置数据源数组并展示
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = [array copy];
    browser.currentPage = indexPath.item;
    [browser show];
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger line = 0;
    if (self.dataArray.count > 0) {
        line = (self.dataArray.count - 1)/3 + 1;
    }
    CGFloat height = 0;
    if (line > 0) {
        height = _itemH*line + _spacing*(line - 1);
    }
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top).offset(10);
        make.height.equalTo(30);
    }];
    
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.titleLabel.bottom);
        make.height.equalTo(height);
        make.bottom.equalTo(self.contentView.bottom).offset(-15);
    }];
}


#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - setter
- (void)setListModel:(GLBQualificateListModel *)listModel
{
    _listModel = listModel;
    
    _titleLabel.text = _listModel.qcName;
    
    [self.dataArray removeAllObjects];
    
    NSString *imageUrl = _listModel.qcPic;
    if ([imageUrl containsString:@","]) {
        NSArray *imageArray = [imageUrl componentsSeparatedByString:@","];
        [self.dataArray addObjectsFromArray:imageArray];
    } else {
        [self.dataArray addObject:imageUrl];
    }
    
    [self.collectionView reloadData];
    [self layoutSubviews];
}

@end
