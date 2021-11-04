//
//  GLBStoreTicketCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreTicketCell.h"
#import "GLBStoreTicketItemCell.h"

static NSString *const listCellID = @"GLBStoreTicketItemCell";

@interface GLBStoreTicketCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _spacing;
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<GLBStoreTicketModel *> *dataArray;

@end

@implementation GLBStoreTicketCell

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
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLabel.text = @"商家优惠券";
    [self.contentView addSubview:_titleLabel];
    
    _spacing = 15;
    _itemW = 223;
    _itemH = 70;
    
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
    GLBStoreTicketItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    cell.ticketModel = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_ticketCellBlock) {
        _ticketCellBlock(indexPath.item);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.contentView.top).offset(15);
    }];
    
    CGFloat height = _itemH;
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(0);
        make.top.equalTo(self.titleLabel.bottom).offset(15);
        
        make.height.equalTo(height); make.bottom.equalTo(self.contentView.bottom).offset(-10);
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
- (void)setTicketArray:(NSMutableArray<GLBStoreTicketModel *> *)ticketArray
{
    _ticketArray = ticketArray;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_ticketArray];
    [self.collectionView reloadData];
}

@end
