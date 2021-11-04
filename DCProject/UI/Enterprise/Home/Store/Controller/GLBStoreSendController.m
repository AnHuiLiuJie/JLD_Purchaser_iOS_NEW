//
//  GLBStoreSendController.m
//  DCProject
//
//  Created by bigbing on 2019/8/1.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBStoreSendController.h"
#import "GLBAptitudeModel.h"

@interface GLBStoreSendController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *rangeTitleLabel;
@property (nonatomic, strong) UILabel *rangeLabel;
@property (nonatomic, strong) UILabel *sendTitleLabel;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UILabel *infoTitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *rengzhengTitleLabel;
@property (nonatomic, strong) UIImageView *rengzhengImage;
@property (nonatomic, strong) UILabel *certificateTitleLabel;
@property (nonatomic, strong) UIImageView *certificateImage;

// 资质模型
@property (nonatomic, strong) GLBAptitudeModel *aptitudeModel;

@end

@implementation GLBStoreSendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUI];
    
    if (_storeModel) {
//        [self requestCompanyAptitude];
        
        _rangeLabel.text = _storeModel.storeQualDeliVO.supplierScope;
        _sendLabel.text = _storeModel.storeQualDeliVO.deliveryExplain;
        _infoLabel.text = _storeModel.storeQualDeliVO.afterSaleExplain;
        
        if (_sendLabel.text.length == 0) {
            _sendLabel.hidden = YES;
            _sendTitleLabel.hidden = YES;
        } else {
            _sendLabel.hidden = NO;
            _sendTitleLabel.hidden = NO;
        }
        
        if (_infoLabel.text.length == 0) {
            _infoLabel.hidden = YES;
            _infoTitleLabel.hidden = YES;
        } else {
            _infoLabel.hidden = NO;
            _infoTitleLabel.hidden = NO;
        }
        
        if (_storeModel.storeQualDeliVO.auditState == 2) {
            _rengzhengImage.hidden = NO;
        } else {
            _rengzhengImage.hidden = YES;
        }
        
        NSString *string = @"";
        if (_storeModel.storeQualDeliVO.qual && [_storeModel.storeQualDeliVO.qual count] > 0) {
            string = _storeModel.storeQualDeliVO.qual[0];
        }
        [self.certificateImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
        
        [self updateMasonry];
    }
}


#pragma mark - 请求 获取企业资质
- (void)requestCompanyAptitude
{
    WEAKSELF;
    [[DCAPIManager shareManager] dc_requestCompanyAptitudeWithFirmId:_storeModel.storeInfoVO.firmId success:^(id response) {
        if (response && [response isKindOfClass:[GLBAptitudeModel class]]) {
            weakSelf.aptitudeModel = response;
            
            NSString *string = weakSelf.aptitudeModel.qcPic;
            if ([string containsString:@","]) {
                string = [string componentsSeparatedByString:@","][0];
            }
            [weakSelf.certificateImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
        }
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark -
- (void)setUpUI
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [_scrollView dc_cornerRadius:4];
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    _rangeTitleLabel = [[UILabel alloc] init];
    _rangeTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _rangeTitleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _rangeTitleLabel.text = @"经营范围";
    [_scrollView addSubview:_rangeTitleLabel];
    
    _rangeLabel = [[UILabel alloc] init];
    _rangeLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _rangeLabel.font = [UIFont fontWithName:PFR size:14];
    _rangeLabel.numberOfLines = 0;
    _rangeLabel.text = @"";
    [_scrollView addSubview:_rangeLabel];
    
    _sendTitleLabel = [[UILabel alloc] init];
    _sendTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _sendTitleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _sendTitleLabel.text = @"配送说明";
    [_scrollView addSubview:_sendTitleLabel];
    
    _sendLabel = [[UILabel alloc] init];
    _sendLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _sendLabel.font = [UIFont fontWithName:PFR size:14];
    _sendLabel.numberOfLines = 0;
    _sendLabel.text = @"";
    [_scrollView addSubview:_sendLabel];
    
    _infoTitleLabel = [[UILabel alloc] init];
    _infoTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _infoTitleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _infoTitleLabel.text = @"售后说明";
    [_scrollView addSubview:_infoTitleLabel];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _infoLabel.font = [UIFont fontWithName:PFR size:14];
    _infoLabel.numberOfLines = 0;
    _infoLabel.text = @"";
    [_scrollView addSubview:_infoLabel];
    
    _rengzhengTitleLabel = [[UILabel alloc] init];
    _rengzhengTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _rengzhengTitleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _rengzhengTitleLabel.text = @"商家认证";
    [_scrollView addSubview:_rengzhengTitleLabel];
    
    _rengzhengImage = [[UIImageView alloc] init];
    _rengzhengImage.image = [UIImage imageNamed:@"yrz"];
    [_scrollView addSubview:_rengzhengImage];
    
    _certificateTitleLabel = [[UILabel alloc] init];
    _certificateTitleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _certificateTitleLabel.font = [UIFont fontWithName:PFRMedium size:14];
    _certificateTitleLabel.text = @"相关证件";
    [_scrollView addSubview:_certificateTitleLabel];
    
    _certificateImage = [[UIImageView alloc] init];
    _certificateImage.contentMode = UIViewContentModeScaleAspectFill;
    _certificateImage.clipsToBounds = YES;
    [_scrollView addSubview:_certificateImage];
    
    [self updateMasonry];
}


- (void)updateMasonry
{
    [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [_rangeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left).offset(15);
        make.right.equalTo(self.scrollView.right).offset(-15);
        make.top.equalTo(self.scrollView.top).offset(25);
        make.width.equalTo(kScreenW - 10*2 - 15*2);
    }];
    
    [_rangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.rangeTitleLabel.bottom).offset(10);
    }];
    
    CGFloat height1 = _sendTitleLabel.hidden ? 0 : 25;
    [_sendTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.rangeLabel.bottom).offset(height1);
    }];
    
    CGFloat height2 = _sendLabel.hidden ? 0 : 10;
    [_sendLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.sendTitleLabel.bottom).offset(height2);
    }];
    
    CGFloat height3 = _infoTitleLabel.hidden ? 0 : 25;
    [_infoTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.sendLabel.bottom).offset(height3);
    }];
    
    CGFloat height4 = _infoLabel.hidden ? 0 : 10;
    [_infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.infoTitleLabel.bottom).offset(height4);
    }];
    
    CGFloat height5 = _infoLabel.hidden ? 0 : 25;
    [_rengzhengTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.infoLabel.bottom).offset(height5);
    }];
    
    [_rengzhengImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rengzhengTitleLabel.left);
        make.top.equalTo(self.rengzhengTitleLabel.bottom).offset(15);
        make.size.equalTo(CGSizeMake(60, 20));
    }];
    
    [_certificateTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.rengzhengImage.bottom).offset(25);
    }];
    
    [_certificateImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rangeTitleLabel.left);
        make.right.equalTo(self.rangeTitleLabel.right);
        make.top.equalTo(self.certificateTitleLabel.bottom).offset(10);
        make.height.equalTo(233);
        make.bottom.equalTo(self.scrollView.bottom).offset(-10);
    }];
}

@end
