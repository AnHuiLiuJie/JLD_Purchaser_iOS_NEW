//
//  GLBAddInfoUploadCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/25.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBAddInfoUploadCell.h"
#import <YBImageBrowser/YBImageBrowser.h>

static NSString *const listCellID = @"UICollectionViewCell";

@interface GLBAddInfoUploadCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _leftSapcing;
    CGFloat _spacing;
    CGFloat _itemW;
    CGFloat _itemH;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLBAddInfoUploadCell

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
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = PFRFont(12);
    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _leftSapcing = 15;
    _spacing = 20;
    _itemW = (int)(kScreenW - _leftSapcing*2 - _spacing*2)/3;
    _itemH = _itemW;
    
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
    return self.dataArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    
    if (![cell.contentView.subviews.lastObject isKindOfClass:[UIButton class]]) {
        UIImageView *image = [[UIImageView alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [cell.contentView addSubview:image];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"dc_scq_bai"] forState:0];
        button.adjustsImageWhenHighlighted = NO;
        button.tag = indexPath.item;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cell.contentView addSubview:button];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.top);
            make.right.equalTo(cell.contentView.right);
            make.size.equalTo(CGSizeMake(35, 35));
        }];
    }
    
    UIImageView *image = cell.contentView.subviews.firstObject;
    UIButton *deleteBtn = cell.contentView.subviews.lastObject;
    
    if (indexPath.item == self.dataArray.count) {
        
        deleteBtn.hidden = YES;
        image.image = [UIImage imageNamed:@"tjzp"];
        
    } else {
        
        deleteBtn.hidden = NO;
        [image sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item]] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.dataArray.count) { // 点击上传图片
        if (_uploadBlock) {
            _uploadBlock();
        }
        
    } else { // 查看大图
        [self dc_showBigImage:indexPath];
    }
}


#pragma mark - 删除按钮
- (void)buttonClick:(UIButton *)button
{
    // 删除图片
    [self.dataArray removeObjectAtIndex:button.tag];
    if (_deleteBlock) {
        _deleteBlock(self.dataArray);
    }
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
    
    NSInteger line = (self.dataArray.count)/3 + 1;
    CGFloat height = _itemH*line + _spacing*(line - 1);
    
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
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
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
    [self.dataArray addObjectsFromArray:_listModel.imgUrlArray];
    [self.collectionView reloadData];
    
    [self layoutSubviews];
}



@end
