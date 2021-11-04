//
//  GLPEtpCenterRebateCell.m
//  DCProject
//
//  Created by 赤道 on 2021/4/25.
//

#import "GLPEtpCenterRebateCell.h"
#import "FHXTools.h"
@implementation GLPEtpCenterRebateCell{
    
    FHXMaskLineView *maskLineView;
    NSMutableArray *arrayX;
    NSMutableArray *arrayY;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;

    [self setupdataView];
//    [maskLineView.arrayX removeAllObjects];
//    [maskLineView.arrayY removeAllObjects];
    if (dataArray.count == 0) {
        self.noDataView.hidden = NO;
        return;
    }else{
        
        self.noDataView.hidden = YES;
    }
    
    for (FHXSingleTrendModel *model in _dataArray) {
        [arrayX addObject:model.x];
        [arrayY addObject:model.y];
    }
    
//    CGFloat maxValue = [[arrayY valueForKeyPath:@"@max.floatValue"] floatValue];
//    if (maxValue == 0) {
//        self.noDataView.hidden = NO;
//        return;
//    }else{
//
//        self.noDataView.hidden = YES;
//    }
    maskLineView.arrayX = arrayX;
    maskLineView.arrayY = arrayY;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10;
    
    //[self setupdataView];
    

    
    _switchBgView.userInteractionEnabled = YES;
    _switchBgView.selectedIndex = 0;
    _switchBgView.accountArray = @[@"近七日",@"近一月"];
    WEAKSELF;
    _switchBgView.TitileButtonClickBlock = ^(NSInteger btnTag) {
        !weakSelf.GLPEtpCenterRebateCell_block ? : weakSelf.GLPEtpCenterRebateCell_block(btnTag);
    };
}


- (void)setupdataView
{
    [maskLineView removeFromSuperview];
    maskLineView = nil;
    
    arrayX = [NSMutableArray arrayWithCapacity:0];
    arrayY = [NSMutableArray arrayWithCapacity:0];
    maskLineView.unitStr = _unitStr;
    maskLineView = [[FHXMaskLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, self.bgView.dc_height)];
    maskLineView.delegate = self;
    [self.bgView addSubview:maskLineView];
}

- (void)setTitle:(NSString *)title{
    _title = title;
}

- (void)setUnitStr:(NSString *)unitStr{
    
    _unitStr = unitStr;
    maskLineView.unitStr = _unitStr;
}

- (void)setType:(NSInteger)type{
    
    _type = type;
    maskLineView.type = _type;
}

- (void)clickTopTypeAction:(NSInteger)tag{
    
    if ([self.delegate respondsToSelector:@selector(switchSelectTypeAction:)]) {
        [self.delegate switchSelectTypeAction:tag];
    }
}

- (void)setBgViewShadow{
    
    self.allBgView.layer.masksToBounds = YES;
    self.allBgView.layer.cornerRadius = 6;
    self.allBgView.layer.shadowColor = HXRGB(225, 225, 234).CGColor;//阴影颜色
    self.allBgView.layer.shadowOpacity = 1.0;//阴影透明度
    self.allBgView.layer.shadowOffset = CGSizeMake(0, 0);//阴影偏移量
    self.allBgView.layer.shadowRadius = 5;//阴影半径
    self.allBgView.layer.shouldRasterize = NO;
    CGRect  roundRect = CGRectMake(0, 0, self.allBgView.dc_width, self.allBgView.dc_height);
    self.allBgView.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:roundRect cornerRadius:5] CGPath];
}

- (void)layoutSubviews{
    
    [self setBgViewShadow];
}

-(UIView *)noDataView{

    if (!_noDataView) {
//        _noDataView = [[NSBundle mainBundle]loadNibNamed:@"FHXChartNoDataView" owner:self options:nil][0];
//        _noDataView.frame = CGRectMake(0, 0, 128, 128);
//        [self.bgView addSubview:_noDataView];
//        _noDataView.hidden = YES;
//        [_noDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerX.equalTo(self.bgView);
//            make.centerY.equalTo(self.bgView);
//            make.width.equalTo(@128.0f);
//            make.height.equalTo(@128.0f);
//        }];
    }
    return _noDataView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
