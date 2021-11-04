//
//  AdditionalInformationCell.m
//  DCProject
//
//  Created by LiuMac on 2021/6/15.
//

#import "AdditionalInformationCell.h"
/*图片压缩*/
#import "CSXImageCompressTool.h"
#import "YNImageUploadViewCollCell.h"

@interface AdditionalInformationCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;


@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subtitleLab;
@property (nonatomic, strong) UILabel *promptLab;

@property (nonatomic, strong) UIView *addBgView;
/*缩略图标识*/
@property (nonatomic, strong) YNImageUploadViewConfig *config;
@property (nonatomic, assign) BOOL isFrist;
/*UIView*/
@property (strong, nonatomic)YNImageUploadView *addPictures;

@end


static CGFloat spacing = 10.0f;

@implementation AdditionalInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

#pragma mark - LazyLoad
- (NSMutableArray *)urlArr{
    if (!_urlArr) {
        _urlArr = [[NSMutableArray alloc] init];
    }
    return _urlArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showType = PrescriptionTypeOnline;
        [self sertUpBase];
    }
    return self;
}

#pragma mark - set
- (void)setShowType:(PrescriptionType)showType{
    _showType = showType;
    
    if (self.showType == PrescriptionTypeOnline) {
        _subtitleLab.text = @"（选填）";
        _titleLab.text = @"补充已就诊信息";

    }else{
        _subtitleLab.text = @"（必填）";
        _titleLab.text = @"上传处方单图片";
    }

}

- (void)setImgsList:(NSArray *)imgsList{
    _imgsList = imgsList;
    
    self.urlArr = [imgsList mutableCopy];
    
    if (self.urlArr.count != 0) {
        NSMutableArray *newArr = @[].mutableCopy;
        for (NSString *str in self.urlArr) {
            [newArr addObject:str];
        }
        [_addPictures.config setUploadViewShowImageWithType:YNImageUploadImageTypeImageUrl contents:newArr];
        _addPictures.config.style = 3;
    }
}

#pragma mark - base// H5=1+10+X+5+x+(kScreenW - 30- 5*2)/3+30+10
- (void)sertUpBase {
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    //CGFloat H5=1+10+20+5+15+(kScreenW - 30- 5*2)/3+30+10;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
        //make.height.equalTo(H5).priorityHigh();
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(15);
        make.width.equalTo(kScreenW-20-30);
        make.top.equalTo(self.bgView.top);
        make.height.equalTo(1);
    }];

    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLab.font = [UIFont fontWithName:PFRMedium size:15];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    if (self.showType == PrescriptionTypeOnline) {
        _titleLab.text = @"补充已就诊信息";
    }else
        _titleLab.text = @"上传处方单图片";
    _titleLab.numberOfLines = 0;
    [_bgView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(10);
        make.top.equalTo(_lineView.top).offset(10);
    }];
    
    _subtitleLab = [[UILabel alloc] init];
    _subtitleLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
    _subtitleLab.font = [UIFont fontWithName:PFR size:14];
    _subtitleLab.textAlignment = NSTextAlignmentLeft;
    _subtitleLab.numberOfLines = 0;
    if (self.showType == PrescriptionTypeOnline) {
        _subtitleLab.text = @"（选填）";
    }else{
        _subtitleLab.text = @"（必填）";
    }

    [_bgView addSubview:_subtitleLab];
    [_subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.right).offset(0);
        make.bottom.equalTo(_titleLab.bottom).offset(0);
    }];
    
    _promptLab = [[UILabel alloc] init];
    _promptLab.textColor = [UIColor dc_colorWithHexString:@"#A7A7A7"];
    _promptLab.font = [UIFont fontWithName:PFR size:14];
    _promptLab.textAlignment = NSTextAlignmentLeft;
    _promptLab.numberOfLines = 0;
    _promptLab.text = @"上传病历/出院记录等";
    [_bgView addSubview:_promptLab];
    [_promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.left).offset(0);
        make.top.equalTo(_titleLab.bottom).offset(5);
    }];
    CGFloat itemW = (kScreenW - 30- 5*2)/3;
    CGFloat itemH = itemW+30;

    _addBgView = [[UIView alloc] init];
    _addBgView.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [_bgView addSubview:_addBgView];
    [_addBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(5);
        //make.right.equalTo(self.bgView.right).offset(5);
        make.top.equalTo(self.promptLab.bottom).offset(0);
        make.height.equalTo(itemH);
        make.width.equalTo(kScreenW-20-10);
        make.bottom.equalTo(self.bgView.bottom).offset(-10);
    }];
    
    __weak typeof(self)weakSelf = self;
    _addPictures = [[YNImageUploadView alloc] initWithConfig:^(YNImageUploadViewConfig * _Nonnull config) {
        config.scale = itemH/itemW;
        config.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        config.autoHeight = NO;
        config.isNeedUpload = YES;
        config.uploadUrl = [NSString stringWithFormat:@"%@%@",Person_RequestUrl,@"/common/upload"];
        config.parameter = @{@"parameter" : @"这里是你的参数"};
        config.rowCount = 3;
        config.lineSpace = 5;
        if (weakSelf.urlArr.count != 0) {
            NSMutableArray *newArr = @[].mutableCopy;
            for (NSString *str in weakSelf.urlArr) {
                [newArr addObject:str];
            }
            [config setUploadViewShowImageWithType:YNImageUploadImageTypeImageUrl contents:newArr];
            config.style = 3;
        }
    }];
    _addPictures.addPicturesViewClickBlock = ^(int viewHeight) {
        NSLog(@"%d",viewHeight);
    };
    
    _addPictures.YNImageUploadViewl_FinishBlock = ^(NSArray * _Nonnull models) {
        NSMutableArray *listArr = [[NSMutableArray alloc] init];
        for (YNImageModel *model in weakSelf.addPictures.dataList) {
            if (model.imageUrl.length != 0) {
                [listArr addObject:model.imageUrl];
            }
        }
        !weakSelf.AdditionalInformationCell_block ? : weakSelf.AdditionalInformationCell_block(listArr);
    };
    [_addBgView addSubview:_addPictures];
    
    [_addPictures mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addBgView.top).offset(0);
        make.left.right.equalTo(_addBgView);
        make.height.equalTo(@(itemH));
    }];
    
    [DCSpeedy dc_setUpBezierPathCircularLayerWithControl:_bgView byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight size:CGSizeMake(10, _bgView.dc_height/2)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
