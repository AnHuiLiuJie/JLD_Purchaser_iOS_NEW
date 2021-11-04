//
//  OrderMyPrescriptionCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/17.
//

#import "OrderMyPrescriptionCell.h"


@implementation OrderMyPrescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark ui
- (void)setViewUI{
    _jiantouView.layer.masksToBounds = YES;
    _jiantouView.layer.cornerRadius = 1.5;
    
    self.bgView.userInteractionEnabled = YES;
    
}

#pragma mark - set
- (void)setShowType:(NSInteger)showType{
    _showType = showType;
    if (_showType == 0) {
        self.cellTitleLab.text = @"我的处方";
    }else if(_showType == 1){
        self.cellTitleLab.text = @"疾病症状描述";
    }else if(_showType == 2){
        self.cellTitleLab.text = @"补充就诊信息";
    }
}

- (void)setModel:(PrescriptionDetailsModel *)model{
    _model = model;
    
    if (_showType == 0) {
        NSString *titleStr = @"";
        NSString *reasonStr = _model.auditReason;
        if ([_model.state isEqualToString:@"1"]) {
            //开方成功
        }else if([_model.state isEqualToString:@"2"]){
            //2-互联网医院拒绝
            titleStr = @"您的问诊已被互联网医院拒绝开方。";
        }else if([_model.state isEqualToString:@"3"]){
            //3-平台拒绝
            titleStr = @"您的处方单已被平台拒绝。";
        }else if([_model.state isEqualToString:@"4"]){
            //4-店铺拒绝
            titleStr = @"您的处方单已被店铺拒绝。";
        }else{
            //开方中
            titleStr = @"您的问诊已提交，请等待医院诊断和开方。";
        }
        
        _titleLab.text = [NSString stringWithFormat:@"%@",titleStr];
        if (reasonStr.length != 0) {
            _auditReasonLab.text = [NSString stringWithFormat:@"拒绝原因：%@",reasonStr];
        }
        
        if (_model.rpUrl.length != 0 && [_model.state isEqualToString:@"1"]) {
            self.imageBgView.hidden = NO;
            NSArray *imgArr = [_model.rpUrl componentsSeparatedByString:@","];
            [self create_typeLabelOnView:imgArr];
        }else{
            self.imageBgView.hidden = YES;
            self.imageBgView_H_LayoutConstraint.constant = 0;
        }
    }else if(_showType == 1){
        _titleLab.text = [NSString stringWithFormat:@"%@",model.billDesc];
        self.imageBgView.hidden = NO;
        self.imageBgView_H_LayoutConstraint.constant = 0;
    }else if(_showType == 2){
        if (_model.supUrl.length != 0) {
            self.imageBgView.hidden = NO;
            NSArray *imgArr = [_model.supUrl componentsSeparatedByString:@","];
            [self create_typeLabelOnView:imgArr];
        }else{
            self.imageBgView.hidden = YES;
            self.imageBgView_H_LayoutConstraint.constant = 0;
        }
    }
}

- (void)create_typeLabelOnView:(NSArray *)array
{
    UIView *view = [[UIView alloc] init];
    [[self.imageBgView viewWithTag:1001] removeFromSuperview];
    view.frame = self.imageBgView.bounds;
    self.imageBgView.userInteractionEnabled = YES;
    view.userInteractionEnabled = YES;
    view.tag = 1001;
    CGFloat spacingH = 10;
    CGFloat item_W = (kScreenW-spacingH*4)/3;
    CGFloat index = 0;
    self.imageBgView_H_LayoutConstraint.constant = item_W;
    for (NSString *str in array) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = index;
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        imageView.frame = CGRectMake(spacingH+(spacingH+item_W)*index, 0, item_W, item_W);
        [view addSubview:imageView];
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBgViewTap1:)];
        imageView.userInteractionEnabled = YES;
        tapGesture1.delegate = self;
        tapGesture1.view.tag = index;
        [imageView addGestureRecognizer:tapGesture1];
        
        index++;
    }
    
    [self.imageBgView addSubview:view];
}

#pragma mark - 点击手势
- (void)didBgViewTap1:(UIGestureRecognizer *)gestureRecognizer{
    UIView *views = (UIView*) gestureRecognizer.view;
    NSUInteger tag = views.tag;
    NSArray *imgArr1 = [_model.rpUrl componentsSeparatedByString:@","];
    NSArray *imgArr2 = [_model.supUrl componentsSeparatedByString:@","];

    NSMutableArray *arr = [NSMutableArray array];

    if (self.showType == 0) {
        for (NSString *url  in imgArr1 ){
            YBIBImageData *data0 = [YBIBImageData new];
            data0.imageURL = [NSURL URLWithString:url];
            [arr addObject:data0];
        }

    }else{
        for (NSString *url  in imgArr2 ){
            YBIBImageData *data0 = [YBIBImageData new];
            data0.imageURL = [NSURL URLWithString:url];
            [arr addObject:data0];
        }
    }

    
    
    _brow = [YBImageBrowser new];
    _brow.autoHideProjectiveView = NO;
    _brow.dataSourceArray = arr;
    _brow.currentPage = tag;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    _brow.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [_brow show];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}




@end
