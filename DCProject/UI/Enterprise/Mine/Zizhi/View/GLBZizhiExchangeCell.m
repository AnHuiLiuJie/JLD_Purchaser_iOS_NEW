//
//  GLBZizhiExchangeCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBZizhiExchangeCell.h"
#import "GLBZizhiExchangeItemCell.h"
#import "TZImagePickerController.h"
#import "DCNavigationController.h"
#import <YBImageBrowser/YBImageBrowser.h>

static NSString *const listCellID = @"GLBZizhiExchangeItemCell";

@interface GLBZizhiExchangeCell ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
{
    CGFloat _leftSapcing;
    CGFloat _spacing;
    NSInteger _itemW;
    NSInteger _itemH;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DCAlterView *alterView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GLBZizhiExchangeCell

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
    _itemH = 0.72*_itemW + 35;
    
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLBZizhiExchangeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellID forIndexPath:indexPath];
    [cell setValueWithArray:self.dataArray indexPath:indexPath];
    WEAKSELF;
    cell.deleteBlock = ^{
        [weakSelf dc_deleteBtnClick:indexPath];
    };
    cell.exchangeBlock = ^{
        [weakSelf dc_openImagePickerController:indexPath];
    };
    cell.iconBlock = ^{
        [weakSelf dc_iconBtnClick:indexPath];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

}


#pragma mark - action
- (void)dc_iconBtnClick:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.dataArray.count) {
        // 上传图片
        [self dc_openImagePickerController:nil];
    } else {
        // 查看大图
        [self dc_showBigImage:indexPath];
    }
}


- (void)dc_deleteBtnClick:(NSIndexPath *)indexPath
{
    WEAKSELF;
    if (![DC_KeyWindow.subviews.lastObject isKindOfClass:[DCAlterView class]]) {
        
        DCAlterView *alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"确定要删除资质图片？"];
        [alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
        [alterView addActionWithTitle:@"确认" type:DCAlterTypeDone halderBlock:^(UIButton *button) {
            [weakSelf.dataArray removeObjectAtIndex:indexPath.item];
            [weakSelf.collectionView reloadData];
            [weakSelf dc_changeBlock];
        }];
        
        [DC_KeyWindow addSubview:
         alterView];
        [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DC_KeyWindow);
        }];
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
    browser.dataSourceArray = array;
    browser.currentPage = indexPath.item;
    [browser show];
}


#pragma mark - 打开图片选择器
- (void)dc_openImagePickerController:(NSIndexPath *)indexPath
{
    WEAKSELF;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [imagePickerVc setNaviBgColor:[UIColor dc_colorWithHexString:@"#00B7AB"]];
    [imagePickerVc setBarItemTextColor:[UIColor whiteColor]];
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"imgNav"] forBarMetrics:UIBarMetricsDefault];
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if ([photos count] > 0) {
            [weakSelf requestUploadImage:photos indexPath:indexPath];
        }
        
    };
    DCNavigationController *nav = DC_KeyWindow.rootViewController.childViewControllers[3];
    [nav presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 上传图片
- (void)requestUploadImage:(NSArray *)images indexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    WEAKSELF;
    [[DCHttpClient shareClient] requestUploadWithPath:@"/common/upload" images:images params:@{@"upType":@"waterMarkImage"} progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } sucess:^(NSURLSessionDataTask *_Nonnull task, id  _Nonnull responseObject) {
        
        [SVProgressHUD dismiss];
        if (responseObject) {
            NSDictionary *dict = [responseObject mj_JSONObject];
            if (dict[DC_ResultCode_Key] && [dict[DC_ResultCode_Key] integerValue] == DC_Result_Success) { // 请求成功
                
                if (dict[@"data"] && [dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dictionary = dict[@"data"];
                    NSString *imageUrl = dictionary[@"uri"];
                    if (!imageUrl || [imageUrl dc_isNull]) {
                        imageUrl = @"";
                    }
                    
                    if (indexPath) { // 替换
                        [weakSelf.dataArray replaceObjectAtIndex:indexPath.item withObject:imageUrl];
                    } else { // 添加
                        [weakSelf.dataArray addObject:imageUrl];
                    }
                    [weakSelf.collectionView reloadData];
                    
                    [weakSelf dc_changeBlock];
                }
                
            } else {
                
                [SVProgressHUD showErrorWithStatus:dict[DC_ResultMsg_Key]];
            }
        }
        
    } failture:^(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"响应失败 - %@",error);
        [[DCAlterTool shareTool] showCancelWithTitle:@"请求失败" message:error.localizedDescription cancelTitle:@"确定"];
    }];
}


#pragma mark - 资质变更
- (void)dc_changeBlock
{
    NSString *imageUrl = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        if (i == 0) {
            imageUrl = self.dataArray[i];
        } else {
            imageUrl = [NSString stringWithFormat:@"%@,%@",imageUrl,self.dataArray[i]];
        }
    }
    
    _listModel.qcPic = imageUrl;
    
    if (_changeBlock) {
        _changeBlock(_listModel);
    }
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger line = (self.dataArray.count)/3 + 1;
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
- (DCAlterView *)alterView{
    if (!_alterView) {
        _alterView = [[DCAlterView alloc] initWithTitle:@"提示" content:@"确定要删除资质图片？"];
        [_alterView addActionWithTitle:@"取消" type:DCAlterTypeCancel halderBlock:nil];
    }
    return _alterView;
}

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
    if (imageUrl && imageUrl.length > 0) {
        if ([imageUrl containsString:@","]) {
            NSArray *imageArray = [imageUrl componentsSeparatedByString:@","];
            [self.dataArray addObjectsFromArray:imageArray];
        } else {
            [self.dataArray addObject:imageUrl];
        }
    }
    
    [self.collectionView reloadData];
    [self layoutSubviews];
}
@end
