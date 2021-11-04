//
//  GLPOldShoppingCarCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "TRRequestListCell.h"
#import "TRStorePageVC.h"
#import "TRRequestGoodsCell.h"
#import "TRRequestGoodsModel.h"
#import "TRRequestCellModel.h"
#import "DCNavigationController.h"
#import "GLPGoodsDetailsController.h"
static NSString *const listCellID = @"TRRequestGoodsCell";

#define kRowHeight 186

@interface TRRequestListCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIButton *shopNameButton;
@property (nonatomic, strong) UIButton *ticketBtn;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *actdataArray;
@end

@implementation TRRequestListCell

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
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"weixuanz"] forState:0];
    [_editBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    _editBtn.adjustsImageWhenHighlighted = NO;
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconImage dc_cornerRadius:20];
    [self.contentView addSubview:_iconImage];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _shopNameLabel.font = [UIFont fontWithName:PFRMedium size:15];
    [self.contentView addSubview:_shopNameLabel];
    _shopNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shop)];
    [_shopNameLabel addGestureRecognizer:tap];
    _ticketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ticketBtn setBackgroundImage:[UIImage imageNamed:@"dc_placeholder_bg"] forState:0];
    _ticketBtn.adjustsImageWhenHighlighted = NO;
    [_ticketBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_ticketBtn];
    
    _moreImage = [[UIImageView alloc] init];
    _moreImage.image = [UIImage imageNamed:@"dc_arrow_right_xh"];
    [self.contentView addSubview:_moreImage];
    
    _shopNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopNameButton addTarget:self action:@selector(shopNameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shopNameButton];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = kRowHeight;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    _tableView.separatorColor = [UIColor dc_colorWithHexString:DC_LineColor];
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:NSClassFromString(listCellID) forCellReuseIdentifier:listCellID];
    [self.contentView addSubview:_tableView];
    
   
   // [self layoutIfNeeded];
    
}

- (UIViewController *)jsd_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

-(UIViewController *)jsd_findVisibleViewController {
    
    UIViewController* currentViewController = [self jsd_getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

- (void)shop{
    TRStorePageVC *vc = [[TRStorePageVC alloc] init];
    vc.firmId= _requestListModel.sellerFirmId;
           
    [ [ self jsd_findVisibleViewController].navigationController  pushViewController:vc animated:YES];
   
}
#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count==0)
    {
         return self.actdataArray.count;
    }
    else{
         return self.actdataArray.count+1;
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==self.actdataArray.count)
    {
         return self.dataArray.count;
    }
    else{
        TRRequestCellModel *cellmodel = self.actdataArray[section];
        NSArray *arr = cellmodel.actCartGoodsList;
         return arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRRequestGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID forIndexPath:indexPath];
   
    cell.goodsnumblock = ^(TRRequestGoodsModel *_Nonnull model) {
        if (self.listnumblock) {
            self.listnumblock(model);
        }
    };
    cell.choseblock = ^(TRRequestGoodsModel *_Nonnull model) {
        if (self.rowblock) {
            self.rowblock(model);
        }
    };
    if (indexPath.section==self.actdataArray.count)
    {
       
        TRRequestGoodsModel *model = self.dataArray[indexPath.row];
        cell.model=model;
    }
    else{
         TRRequestCellModel *cellmodel = self.actdataArray[indexPath.section];
         NSArray *arr = cellmodel.actCartGoodsList;
        NSDictionary *dic = arr[indexPath.row];
        TRRequestGoodsModel *model = [[TRRequestGoodsModel alloc]initWithDic:dic];
        cell.model=model;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==self.actdataArray.count)
    {
        CGFloat price=0;
        for (int i=0; i<self.dataArray.count; i++)
        {
            TRRequestGoodsModel *goodmodel = self.dataArray[i];
            NSString *select = [NSString stringWithFormat:@"%@",goodmodel.select];
            if ([select isEqualToString:@"1"])
            {
                price=price+[goodmodel.sellPrice floatValue]*[goodmodel.quantity intValue];
            }
        }
        UIView *footView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 48)];
        UILabel *_totalLabel1 = [[UILabel alloc] init];
        _totalLabel1.frame = CGRectMake(15, 14, kScreenW-30, 20);
        _totalLabel1.textAlignment = NSTextAlignmentRight;
        _totalLabel1.attributedText = [self attributeWithMoney:[NSString stringWithFormat:@"%.2f",price]];
        [footView1 addSubview:_totalLabel1];
        return footView1;
    }
    else{
        TRRequestCellModel *cellmodel = self.actdataArray[section];
        NSArray *arr = cellmodel.actCartGoodsList;
        CGFloat price=0;
        for (int i=0; i<arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            NSString *select = [NSString stringWithFormat:@"%@",dic[@"select"]];
            if ([select isEqualToString:@"1"])
            {
                price=price+[dic[@"sellPrice"] floatValue]*[dic[@"quantity"] intValue];
            }
        }
        CGFloat couponPrice=0;
        if (price>= [cellmodel.requireAmount floatValue])
        {
            couponPrice=price-[cellmodel.discountAmount floatValue];
        }
        else{
            couponPrice=price;
        }
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 48)];
        UILabel *_totalLabel = [[UILabel alloc] init];
        _totalLabel.frame = CGRectMake(kScreenW-15-(kScreenW-30)/2, 14, (kScreenW-30)/2, 20);
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.attributedText = [self attributeWithMoney:[NSString stringWithFormat:@"%.2f",couponPrice]];
        [footView addSubview:_totalLabel];
        UILabel *actLabel = [[UILabel alloc] init];
        actLabel.frame = CGRectMake(15, 14, (kScreenW-30)/2, 20);
        actLabel.textAlignment = NSTextAlignmentLeft;
        actLabel.font = [UIFont systemFontOfSize:10];
        actLabel.textColor= [UIColor dc_colorWithHexString:@"#FF4A13"];
        actLabel.text = [NSString stringWithFormat:@"以上活动商品满¥%@减¥%@",cellmodel.requireAmount,cellmodel.discountAmount];
        //actLabel = [UILabel setupAttributeLabel:actLabel textColor:actLabel.textColor minFont:nil maxFont:nil forReplace:@"¥"];
        [footView addSubview:actLabel];
        return footView;
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==self.actdataArray.count)
    {
        TRRequestGoodsModel *model = self.dataArray[indexPath.row];
        GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
        vc.goodsId=model.goodsId;
        [[self jsd_findVisibleViewController].navigationController pushViewController:vc animated:YES];
    }else{
        TRRequestCellModel *cellmodel = self.actdataArray[indexPath.section];
        NSArray *arr = cellmodel.actCartGoodsList;
        NSDictionary *dic = arr[indexPath.row];
        TRRequestGoodsModel *model = [[TRRequestGoodsModel alloc]initWithDic:dic];
        GLPGoodsDetailsController *vc = [[GLPGoodsDetailsController alloc] init];
        vc.goodsId= model.goodsId;
        [[self jsd_findVisibleViewController].navigationController pushViewController:vc animated:YES];
   }
}

#pragma mark - 点击事件
- (void)editBtnClick:(UIButton *)button
{
    self.editBtn.selected = !self.editBtn.selected;
    if (self.editBtn.selected==YES)
    {
        if (self.choseblock) {
            self.choseblock(@"1");
        }
    }
    else{
        if (self.choseblock) {
            self.choseblock(@"0");
        }
    }
    
}

- (void)ticketBtnClick:(UIButton *)button
{

}

- (void)shopNameButtonClick:(UIButton *)button
{
    
}



#pragma mark - 富文本
- (NSMutableAttributedString *)attributeWithMoney:(NSString *)money
{
    NSString *text = [NSString stringWithFormat:@"商品小计：￥%@",money];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSString *floStr;
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];//后(包括.)
    }
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#333333"]} range:NSMakeRange(0, 5)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(5, 1)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFRMedium size:16],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:NSMakeRange(6, attrStr.length - 6)];
    
    NSRange range2 = [text rangeOfString:floStr];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PFR size:12],NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#FF4A13"]} range:range2];
    
    return attrStr;
}


#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(10);
        make.top.equalTo(self.contentView.top).offset(10);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editBtn.right).offset(10);
        make.centerY.equalTo(self.editBtn.centerY);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.width.lessThanOrEqualTo(200);
        make.centerY.equalTo(self.iconImage.centerY);
    }];
    
    [_moreImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImage.centerY);
        make.left.equalTo(self.shopNameLabel.right).offset(10);
        make.size.equalTo(CGSizeMake(6, 8));
    }];
    
    [_ticketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.centerY.equalTo(self.iconImage.centerY);
        make.size.equalTo(CGSizeMake(55, 30));
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.editBtn.bottom).offset(10);
        make.height.equalTo(1);
    }];
    
    CGFloat height = 0;
    CGFloat count = 0;
    for (int i=0; i<self.actdataArray.count; i++)
    {
        TRRequestCellModel *model = self.actdataArray[i];
        NSArray *arr = model.actCartGoodsList;
        count = count+arr.count;
    }
    if (self.dataArray.count==0)
    {
        if (self.actdataArray.count==0)
        {
            height = 0;
        }
        else{
            height = count *kRowHeight+48*self.actdataArray.count;
        }
    }
    else{
        if (self.actdataArray.count==0)
        {
            height = self.dataArray.count*kRowHeight+48;
        }
        else{
            height = count *kRowHeight+48+48*self.actdataArray.count+self.dataArray.count*kRowHeight;
        }
    }

    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.top.equalTo(self.line.bottom).offset(0);
        make.height.equalTo(height);
    }];
    
}



#pragma mark -
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)actdataArray{
    if (!_actdataArray) {
        _actdataArray = [NSMutableArray array];
    }
    return _actdataArray;
}

- (void)setRequestListModel:(TRRequestListModel *)requestListModel
{
    _requestListModel = requestListModel;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:requestListModel.mallLogo] placeholderImage:[UIImage imageNamed:@"logo"]];
    _shopNameLabel.text = requestListModel.mallname;
    [self.dataArray removeAllObjects];
    [self.actdataArray removeAllObjects];
    NSArray *arr = requestListModel.validActInfoList;
    NSArray *arr1 = requestListModel.validNoActGoodsList;
    BOOL allselect = YES;
    for (int i=0; i<arr1.count; i++)
    {
        NSDictionary *dic = arr1[i];
        if ([dic[@"select"] isEqualToString:@"0"])
        {
            allselect = NO;
        }
    }
    for (int i=0; i<arr.count; i++)
    {
        NSDictionary *dic = arr[i];
        NSArray *arr2 = dic[@"actCartGoodsList"];
        for (int i=0; i<arr2.count; i++)
        {
            NSDictionary *dic1 = arr2[i];
            if ([dic1[@"select"] isEqualToString:@"0"])
            {
                allselect = NO;
            }
        }
    }
    if (allselect==YES)
    {
        _editBtn.selected = YES;
    }
    else{
        _editBtn.selected = NO;
    }
  
    for (int i=0; i<arr.count; i++)
    {
        NSDictionary *dic = arr[i];
        TRRequestCellModel *model = [[TRRequestCellModel alloc]initWithDic:dic];
        NSArray *arr2 = model.actCartGoodsList;
        NSMutableArray *arr3 = [NSMutableArray arrayWithCapacity:0];
        for (int a=0; a<arr2.count; a++)
        {
            NSDictionary *dic1 = arr2[a];
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 addEntriesFromDictionary:dic1];
            [dic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"section"];
            [dic2 setObject:[NSString stringWithFormat:@"%d",a] forKey:@"row"];
            [arr3 addObject:dic2];
        }
        model.actCartGoodsList=arr3;
        [self.actdataArray addObject:model];
    }
   
    for (int i=0; i<arr1.count; i++)
    {
        NSDictionary *dic = arr1[i];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic2 addEntriesFromDictionary:dic];
        [dic2 setObject:[NSString stringWithFormat:@"%ld",arr.count] forKey:@"section"];
        [dic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"row"];
        TRRequestGoodsModel *model = [[TRRequestGoodsModel alloc]initWithDic:dic2];
        [self.dataArray addObject:model];
    }
    [self layoutSubviews];
    [self.tableView reloadData];
}

@end
