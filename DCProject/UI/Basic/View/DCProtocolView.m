//
//  DCProtocolView.m
//  DCProject
//
//  Created by bigbing on 2020/4/26.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "DCProtocolView.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "GLBProtocolModel.h"

@interface DCProtocolView ()<YBAttributeTapActionDelegate>

@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) NSMutableArray<GLBProtocolModel *> *protocolArray;

@end

@implementation DCProtocolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)logoutBtnClick:(id)sender
{
    exit(0);
}

- (void)agreeBtnClick:(id)sender
{
    [self removeFromSuperview];
    
    if (_agreeBlock) {
        _agreeBlock();
    }
}


- (void)yb_tapAttributeInLabel:(UILabel *)label
                        string:(NSString *)string
                         range:(NSRange)range
                         index:(NSInteger)index
{
    NSLog(@"点击了协议 - %@ - %ld",string , index);
    if (_protocolBlock) {
        if (index < self.protocolArray.count) {
            GLBProtocolModel *m = self.protocolArray[index];
            _protocolBlock(m.api);
        }
    }
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#333333" alpha:0.3];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView dc_cornerRadius:5];
    [self addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = PFRFont(17);
    titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"欢迎使用金利达";
    [bgView addSubview:titleLabel];
    
//    UILabel *subLabel = [[UILabel alloc] init];
//    subLabel.font = PFRFont(14);
//    subLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    subLabel.textAlignment = NSTextAlignmentCenter;
//    subLabel.text = @"为保证您正常、安全使用金利达，我们将向您申请如下权限:";
//    subLabel.numberOfLines = 0;
//    [bgView addSubview:subLabel];
//
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [bgView addSubview:scrollView];
//
//    UILabel *label1 = [[UILabel alloc] init];
//    label1.font = PFRFont(14);
//    label1.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    label1.text = @"多媒体功能";
//    label1.numberOfLines = 0;
//    [scrollView addSubview:label1];
//
//    UILabel *label11 = [[UILabel alloc] init];
//    label11.font = PFRFont(14);
//    label11.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    label11.text = @"用户修改头像、聊天使用";
//    label11.numberOfLines = 0;
//    [scrollView addSubview:label11];
//
//    UIImageView *image1 = [[UIImageView alloc] init];
//    image1.image = [UIImage imageNamed:@"dmt"];
//    [scrollView addSubview:image1];
//
//    UILabel *label2 = [[UILabel alloc] init];
//    label2.font = PFRFont(14);
//    label2.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    label2.text = @"手机存储";
//    label2.numberOfLines = 0;
//    [scrollView addSubview:label2];
//
//    UILabel *label22 = [[UILabel alloc] init];
//    label22.font = PFRFont(14);
//    label22.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    label22.text = @"用户存取用户信息使用";
//    label22.numberOfLines = 0;
//    [scrollView addSubview:label22];
//
//    UIImageView *image2 = [[UIImageView alloc] init];
//    image2.image = [UIImage imageNamed:@"sjcc"];
//    [scrollView addSubview:image2];
//
//    UILabel *label3 = [[UILabel alloc] init];
//    label3.font = PFRFont(14);
//    label3.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    label3.text = @"电话权限";
//    label3.numberOfLines = 0;
//    [scrollView addSubview:label3];
//
//    UILabel *label33 = [[UILabel alloc] init];
//    label33.font = PFRFont(14);
//    label33.textColor = [UIColor dc_colorWithHexString:@"#333333"];
//    label33.text = @"获取设备信息用于分享、聊天使用";
//    label33.numberOfLines = 0;
//    [scrollView addSubview:label33];
//
//    UIImageView *image3 = [[UIImageView alloc] init];
//    image3.image = [UIImage imageNamed:@"dmt"];
//    [scrollView addSubview:image3];
    
    self.protocolLabel = [[UILabel alloc] init];
//    self.protocolLabel.font = PFRFont(14);
    self.protocolLabel.font = [UIFont fontWithName:PFRMedium size:15];
    self.protocolLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
//    protocol.text = @"您可通过阅读完整的《金利达隐私政策》和《金利达会员服务协议》来了解详细信息";
    self.protocolLabel.textAlignment = NSTextAlignmentLeft;
    self.protocolLabel.numberOfLines = 0;
    [scrollView addSubview:self.protocolLabel];
    
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"感谢您对金利达一直以来的信任！为了给您提供更加优质、便捷的服务保证您正常、安全使用金利达，我们升级了相应的服务功能；\n同时根据最新监管政策的要求，我们更新了《金利达隐私政策》和《金利达会员服务协议》，特向您说明如下：\n我们将向您申请如下权限\n1.访问相机\n我们访问您的相机是为了使您可以使用摄像头进行拍摄并上传图片以进行晒图评价、纸质处方上传、头像更改。\n2.访问相册\n我们访问您的相机可以使您直接调取您手机中的照片或图片以进行进行晒图评价、纸质处方上传、头像更改以与客服沟通时遇到的问题。\n3.存储权限  \n我们访问您的存储空间是为了向您提供保存图片及上传图片功能。\n4.位置信息\n我们会收集您的位置信息（我们仅收集您当时所处的地理位置，但不会将您各时段的位置信息进行结合以判断您的行踪轨迹）来为您提供附近的商家及商品服务。\n您可通过阅读完整的《金利达隐私政策》来了解详细信息"];
//    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:DC_BtnColor]} range:NSMakeRange(55, 9)];
//    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:DC_BtnColor]} range:NSMakeRange(69, 9)];
//    self.protocolLabel.attributedText = attStr;

//    [self.protocolLabel yb_addAttributeTapActionWithStrings:@[@"《金利达隐私政策》",@"《金利达会员服务协议》"] delegate:self];
//    [self.protocolLabel yb_addAttributeTapActionWithRanges:@[NSStringFromRange(NSMakeRange(9, 9)),NSStringFromRange(NSMakeRange(19, 9))] delegate:self];
    
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"拒绝并退出" forState:0];
    [logoutBtn setTitleColor:[UIColor dc_colorWithHexString:@"#666666"] forState:0];
    logoutBtn.titleLabel.font = PFRFont(14);
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:logoutBtn];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setTitle:@"同意" forState:0];
    [agreeBtn setTitleColor:[UIColor dc_colorWithHexString:@"#ffffff"] forState:0];
    agreeBtn.titleLabel.font = PFRFont(14);
    agreeBtn.backgroundColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:agreeBtn];
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY).offset(-kStatusBarHeight);
        make.width.equalTo(kScreenW *0.8);
        make.height.equalTo(kScreenW *0.8 *1.2);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(bgView.top).offset(12);
        make.height.equalTo(40);
    }];
    
//    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bgView.left).offset(40);
//        make.right.equalTo(bgView.right).offset(-40);
//        make.top.equalTo(titleLabel.bottom).offset(15);
//    }];
    
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(bgView);
        make.width.equalTo(bgView.width).multipliedBy(0.5);
        make.height.equalTo(44);
    }];
    
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(bgView);
        make.top.equalTo(logoutBtn.top);
        make.left.equalTo(logoutBtn.right);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.left).offset(8);
        make.right.equalTo(bgView.right).offset(-8);
        make.top.equalTo(titleLabel.bottom).offset(0);
        make.bottom.equalTo(logoutBtn.top);
        make.width.equalTo(bgView.width).offset(-16);
    }];
    
//    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(scrollView.left).offset(70);
//        make.right.equalTo(scrollView.right).offset(-20);
//        make.top.equalTo(scrollView.top).offset(15);
//        make.width.equalTo(kScreenW *0.8 - 70 - 20);
//    }];
//
//    [label11 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(label1);
//        make.top.equalTo(label1.bottom).offset(6);
//    }];
//
//    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(label1.left).offset(-10);
//        make.centerY.equalTo(label1.bottom).offset(3);
//        make.size.equalTo(CGSizeMake(25, 25));
//    }];
//
//    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(label1);
//        make.top.equalTo(label11.bottom).offset(15);
//    }];
//
//    [label22 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(label1);
//        make.top.equalTo(label2.bottom).offset(6);
//    }];
//
//    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(label2.left).offset(-10);
//        make.centerY.equalTo(label2.bottom).offset(3);
//        make.size.equalTo(CGSizeMake(25, 25));
//    }];
//
//    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(label1);
//        make.top.equalTo(label22.bottom).offset(15);
//    }];
//
//    [label33 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(label1);
//        make.top.equalTo(label3.bottom).offset(6);
//    }];
//
//    [image3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(label3.left).offset(-10);
//        make.centerY.equalTo(label3.bottom).offset(3);
//        make.size.equalTo(CGSizeMake(25, 25));
//    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.left).offset(0);
        make.right.equalTo(scrollView.right).offset(0);
        make.top.equalTo(scrollView.top).offset(-20);
        make.bottom.equalTo(scrollView.bottom).offset(-20);
        make.width.equalTo(scrollView.width);
    }];
    
//    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bgView.left);
//        make.right.equalTo(bgView.right);
//        make.top.equalTo(scrollView.top).offset(0);
//        make.bottom.equalTo(logoutBtn.top);
//        make.width.equalTo(bgView.width);
//    }];
    
    [self requestRegisterProtocol];
}

-(void)setShowType:(NSString *)showType{
    _showType = showType;
    
    if ([_showType isEqualToString:@"YES"]) {
        [self requestRegisterProtocol];
    }
}

#pragma mark - 请求 获取注册协议
- (void)requestRegisterProtocol
{
    self.protocolArray = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    [[DCAPIManager shareManager] dc_requestRegisterProtocolWithSuccess:^(id response) {
        if (response && [response count] > 0) {
            [weakSelf.protocolArray addObjectsFromArray:response];
            
            weakSelf.protocolLabel.attributedText = [weakSelf dc_attributeStr];
            
            [weakSelf.protocolLabel yb_addAttributeTapActionWithStrings:@[@"《金利达隐私政策》",@"《金利达会员服务协议》"] delegate:weakSelf];
        }
    } failture:^(NSError *_Nullable error) {
    }];
}

#pragma mark - attributeStr
- (NSMutableAttributedString *)dc_attributeStr
{
    NSString *protocolStr = @"";
    if (self.protocolArray.count > 0) {
        NSMutableArray *nowArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<self.protocolArray.count; i++) {
            GLBProtocolModel *model = self.protocolArray[i];
            if (protocolStr.length == 0) {
                if ([model.name containsString:@"隐私"] && [model.name containsString:@"政策"]) {
                    protocolStr = @"《金利达隐私政策》";//86 9
                    model.name = @"《金利达隐私政策》";
                    [nowArray addObject:model];
                }else if (([model.name containsString:@"会员"] || [model.name containsString:@"用户"]) && [model.name containsString:@"协议"]){
                    protocolStr = @"《金利达会员服务协议》";//88 10
                    model.name = @"《金利达会员服务协议》";
                    [nowArray addObject:model];
                }
            } else {
                if ([model.name containsString:@"隐私"] && [model.name containsString:@"政策"]) {
                    protocolStr = [NSString stringWithFormat:@"%@和《金利达隐私政策》",protocolStr];
                    model.name = @"《金利达隐私政策》";
                    [nowArray addObject:model];
                }else if (([model.name containsString:@"会员"] || [model.name containsString:@"用户"]) && [model.name containsString:@"协议"]){
                    protocolStr = [NSString stringWithFormat:@"%@和《金利达会员服务协议》",protocolStr];
                    model.name = @"《金利达会员服务协议》";
                    [nowArray addObject:model];
                }
            }
        }
        self.protocolArray = [NSMutableArray arrayWithArray:nowArray];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];
    if (protocolStr.length > 0) {
        attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"感谢您对金利达一直以来的信任!为了给您提供更加优质、便捷的服务保证您正常、安全使用金利达,我们升级了相应的服务功能;同时根据最新监管政策的要求,我们更新了%@，特向您说明如下：我们将向您申请如下权限\n1.访问相机\n我们访问您的相机是为了使您可以使用摄像头进行拍摄并上传图片以进行晒图评价、纸质处方上传、头像更改。\n2.访问相册\n我们访问您的相机可以使您直接调取您手机中的照片或图片以进行进行晒图评价、纸质处方上传、头像更改以与客服沟通时遇到的问题。\n3.存储权限  \n我们访问您的存储空间是为了向您提供保存图片及上传图片功能。\n4.位置信息\n我们会收集您的位置信息（我们仅收集您当时所处的地理位置，但不会将您各时段的位置信息进行结合以判断您的行踪轨迹）来为您提供附近的商家及商品服务。\n您可通过阅读完整的《金利达隐私政策》来了解详细信息",protocolStr]];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(0, 76)];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:DC_BtnColor]} range:NSMakeRange(77, 9)];
        
        NSLog(@"===%@",attrStr.string);
        if (self.protocolArray.count > 1) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(86, 1)];
            [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#00B7AB"]} range:NSMakeRange(87, 11)];
            [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(98, attrStr.string.length-98)];
        }else{
            [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor dc_colorWithHexString:@"#999999"]} range:NSMakeRange(87, attrStr.string.length-87)];
        }
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        style.alignment = NSTextAlignmentLeft;
        [attrStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attrStr.length)];
    }
    
    return attrStr;
}



@end
