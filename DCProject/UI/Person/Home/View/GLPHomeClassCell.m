//
//  GLPHomeDrugTypeCell.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeClassCell.h"

@interface GLPHomeClassCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GLPHomeClassBigTypeView *bigTypeView1;
@property (nonatomic, strong) GLPHomeClassBigTypeView *bigTypeView2;
@property (nonatomic, strong) GLPHomeClassSmallTypeView *smallTypeView1;
@property (nonatomic, strong) GLPHomeClassSmallTypeView *smallTypeView2;
@property (nonatomic, strong) GLPHomeClassSmallTypeView *smallTypeView3;
@property (nonatomic, strong) GLPHomeClassSmallTypeView *smallTypeView4;

@end

@implementation GLPHomeClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView dc_cornerRadius:7];
    [self.contentView addSubview:_bgView];
    
    _iconImage = [[UIImageView alloc] init];
    [_bgView addSubview:_iconImage];

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:20];
    _titleLabel.text = @"";
    [_bgView addSubview:_titleLabel];
    
    _bigTypeView1 = [[GLPHomeClassBigTypeView alloc] init];
    _bigTypeView1.userInteractionEnabled = YES;
    _bigTypeView1.tag=100;
    [_bgView addSubview:_bigTypeView1];
    
    _bigTypeView2 = [[GLPHomeClassBigTypeView alloc] init];
    _bigTypeView2.userInteractionEnabled = YES;
    _bigTypeView2.tag=101;
    [_bgView addSubview:_bigTypeView2];
    
    _smallTypeView1 = [[GLPHomeClassSmallTypeView alloc] init];
    _smallTypeView1.userInteractionEnabled = YES;
    _smallTypeView1.tag=102;
    [_bgView addSubview:_smallTypeView1];
    
    _smallTypeView2 = [[GLPHomeClassSmallTypeView alloc] init];
     _smallTypeView2.userInteractionEnabled = YES;
    _smallTypeView2.tag=103;
    [_bgView addSubview:_smallTypeView2];
    
    _smallTypeView3 = [[GLPHomeClassSmallTypeView alloc] init];
     _smallTypeView3.userInteractionEnabled = YES;
    _smallTypeView3.tag=104;
    [_bgView addSubview:_smallTypeView3];
    
    _smallTypeView4 = [[GLPHomeClassSmallTypeView alloc] init];
     _smallTypeView4.userInteractionEnabled = YES;
    _smallTypeView4.tag=105;
    [_bgView addSubview:_smallTypeView4];
    UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    [_bigTypeView1 addGestureRecognizer:tap1];
    UITapGestureRecognizer*tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    [_bigTypeView2 addGestureRecognizer:tap2];
    UITapGestureRecognizer*tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    [_smallTypeView1 addGestureRecognizer:tap3];
    UITapGestureRecognizer*tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    [_smallTypeView2 addGestureRecognizer:tap4];
    UITapGestureRecognizer*tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    [_smallTypeView3 addGestureRecognizer:tap5];
    UITapGestureRecognizer*tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    [_smallTypeView4 addGestureRecognizer:tap6];
    [self layoutIfNeeded];
}

- (void)viewClick:(UITapGestureRecognizer*)reg
{
    if (self.viewBlock) {
        self.viewBlock(reg.view.tag);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bigWidth = (kScreenW - 14*2 - 12*2 - 7)/2;
    CGFloat bigHeight = bigWidth;//106;
    
    CGFloat smallWidth = (kScreenW - 14*2 - 12*2 - 7*3)/4;
    CGFloat smallHeight = smallWidth;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 14, 0, 14));
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(12);
        make.top.equalTo(self.bgView.top).offset(15);
        make.size.equalTo(CGSizeMake(23, 23));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.right).offset(10);
        make.centerY.equalTo(self.iconImage.centerY);
    }];
    
    [_bigTypeView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.left).offset(12);
        make.top.equalTo(self.iconImage.bottom).offset(15);
        make.size.equalTo(CGSizeMake(bigWidth, bigHeight));
    }];
    
    [_bigTypeView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigTypeView1.right).offset(7);
        make.centerY.equalTo(self.bigTypeView1.centerY);
        make.size.equalTo(CGSizeMake(bigWidth, bigHeight));
    }];
    
    [_smallTypeView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigTypeView1.left);
        make.top.equalTo(self.bigTypeView1.bottom).offset(7);
        make.size.equalTo(CGSizeMake(smallWidth, smallHeight));
        //make.bottom.equalTo(self.bgView.bottom).offset(-12);//lj_change_约束
    }];
    
    [_smallTypeView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallTypeView1.right).offset(7);
        make.centerY.equalTo(self.smallTypeView1.centerY);
        make.size.equalTo(CGSizeMake(smallWidth, smallHeight));
    }];
    
    [_smallTypeView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallTypeView2.right).offset(7);
        make.centerY.equalTo(self.smallTypeView2.centerY);
        make.size.equalTo(CGSizeMake(smallWidth, smallHeight));
    }];
    
    [_smallTypeView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.smallTypeView3.right).offset(7);
        make.centerY.equalTo(self.smallTypeView3.centerY);
        make.size.equalTo(CGSizeMake(smallWidth, smallHeight));
    }];
}


#pragma mark - 赋值
- (void)setValueWithDataModel:(GLPHomeDataModel *)dataModel indexPath:(NSIndexPath *)indexPath
{
    _titleLabel.text = dataModel.spaceName;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:dataModel.spacePic] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
    
    NSArray *subColor1 = @[@"#4483FF",@"#FF4444",@"#FF44C1",@"#FF6C6C"];
    NSArray *subColor2 = @[@"#FF5801",@"#FF9701",@"#27D738",@"#465DFF"];
    _bigTypeView1.openBtn.backgroundColor = [UIColor dc_colorWithHexString:subColor1[indexPath.section - 4]];
    _bigTypeView2.openBtn.backgroundColor = [UIColor dc_colorWithHexString:subColor2[indexPath.section - 4]];
    
    _bigTypeView1.hidden = YES;
    _bigTypeView2.hidden = YES;
    _smallTypeView1.hidden = YES;
    _smallTypeView2.hidden = YES;
    _smallTypeView3.hidden = YES;
    _smallTypeView4.hidden = YES;
    
    if (dataModel.dataList && dataModel.dataList.count > 0) {
        for (int i=0; i<dataModel.dataList.count; i++) {
            GLPHomeDataListModel *listModel = dataModel.dataList[i];
            
            if (i == 0) {
                _bigTypeView1.hidden = NO;
                [_bigTypeView1 setValueWithListModel:listModel indexPath:indexPath];
            } else if (i == 1) {
                _bigTypeView2.hidden = NO;
                [_bigTypeView2 setValueWithListModel:listModel indexPath:indexPath];
            } else if (i == 2) {
                _smallTypeView1.hidden = NO;
                [_smallTypeView1 setValueWithListModel:listModel indexPath:indexPath];
            } else if (i == 3) {
                _smallTypeView2.hidden = NO;
                [_smallTypeView2 setValueWithListModel:listModel indexPath:indexPath];
            } else if (i == 4) {
                _smallTypeView3.hidden = NO;
                [_smallTypeView3 setValueWithListModel:listModel indexPath:indexPath];
            } else if (i == 5) {
                _smallTypeView4.hidden = NO;
                [_smallTypeView4 setValueWithListModel:listModel indexPath:indexPath];
            }
        }
    }
}


@end


#pragma mark - 类型1
@interface GLPHomeClassBigTypeView ()

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *goodsImage;

@end

@implementation GLPHomeClassBigTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#F4F8FB"];
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#F4F8FB"];
    
    [self dc_cornerRadius:5];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _titleLabel.text = @"";
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_openBtn setTitle:@"立即进入" forState:0];
    [_openBtn setTitleColor:[UIColor dc_colorWithHexString:@"#FFFFFF"] forState:0];
    _openBtn.titleLabel.font = PFRFont(10);
    _openBtn.backgroundColor = [UIColor dc_colorWithHexString:@"#4483FF"];
    [_openBtn dc_cornerRadius:10];
    [_openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _openBtn.userInteractionEnabled = NO;
    [self addSubview:_openBtn];
    
    _goodsImage = [[UIImageView alloc] init];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    _goodsImage.clipsToBounds = YES;
    [_goodsImage dc_cornerRadius:5];
    [self addSubview:_goodsImage];
    self.goodsImage.layer.magnificationFilter = kCAFilterTrilinear;
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)openBtnClick:(UIButton *)button
{
    
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.left).offset(6);
//        make.top.equalTo(self.top).offset(6);
//        make.right.equalTo(self.right).offset(-6);
//    }];
    
//    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.left);
//        make.top.equalTo(self.titleLabel.bottom).offset(5);
//    }];
    
//    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.left);
//        make.bottom.equalTo(self.bottom).offset(-26);
//        make.size.equalTo(CGSizeMake(56, 20));
//    }];
    
//    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.right).offset(-6);
//        make.bottom.equalTo(self.bottom).offset(-6);
//        make.size.equalTo(CGSizeMake(82, 55));
//    }];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - 赋值
- (void)setValueWithListModel:(GLPHomeDataListModel *)listModel indexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    if (listModel.subTitle && listModel.subTitle.length > 0) {
        title = listModel.subTitle;
    }
    if (title.length == 0) {
        title = listModel.infoTitle;
    }
    
    _titleLabel.text = title;
    
    NSString *imageUrl = listModel.imgUrl;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];
}


@end



#pragma mark - 类型2
@interface GLPHomeClassSmallTypeView ()

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *goodsImage;


@end

@implementation GLPHomeClassSmallTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor dc_colorWithHexString:@"#ee8a58"];
    
    [self dc_cornerRadius:5];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor dc_colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont fontWithName:PFRMedium size:13];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"";
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
//    _subLabel = [[UILabel alloc] init];
//    _subLabel.textColor = [UIColor dc_colorWithHexString:@"#2CA1F8"];
//    _subLabel.font = [UIFont fontWithName:PFR size:11];
//    _subLabel.textAlignment = NSTextAlignmentCenter;
//    _subLabel.text = @"缓解痛苦";
//    [self addSubview:_subLabel];
    
    _goodsImage = [[UIImageView alloc] init];
//    _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
//    _goodsImage.clipsToBounds = YES;
    [_goodsImage dc_cornerRadius:5];
    [self addSubview:_goodsImage];
    self.goodsImage.layer.minificationFilter = kCAFilterTrilinear;

    
    [self layoutIfNeeded];
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.left);
//        make.top.equalTo(self.top).offset(6);
//        make.right.equalTo(self.right);
//    }];
    
//    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.left);
//        make.top.equalTo(self.titleLabel.bottom).offset(5);
//        make.right.equalTo(self.right);
//    }];
    
//    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.centerX);
//        make.bottom.equalTo(self.bottom).offset(0);
//        make.size.equalTo(CGSizeMake(50, 50));
//    }];
    
    [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - 赋值
- (void)setValueWithListModel:(GLPHomeDataListModel *)listModel indexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    if (listModel.subTitle && listModel.subTitle.length > 0) {
        title = listModel.subTitle;
    }
    if (title.length == 0) {
        title = listModel.infoTitle;
    }
    
    _titleLabel.text = title;
    
    NSString *imageUrl = listModel.imgUrl;
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[[DCPlaceholderTool shareTool] dc_placeholderImage]];

    
    //NSArray *bgColor = @[@"#2CA1F8",@"#FF5B00",@"#22B030",@"#465DFF"];
    //    NSArray *titleColor = @[@"#2CA1F8",@"#FF5B00",@"#22B030",@"#465DFF"];
    
    
//    self.backgroundColor = [UIColor dc_colorWithHexString:bgColor[indexPath.section - 4] alpha:0.1];
    //    _subLabel.textColor = [UIColor dc_colorWithHexString:titleColor[_indexPath.section - 4]];
}

@end
