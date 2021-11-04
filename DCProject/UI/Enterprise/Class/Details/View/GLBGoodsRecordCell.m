//
//  GLBGoodsRecordCell.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsRecordCell.h"
#import "GLBGoodsRecordView.h"

@interface GLBGoodsRecordCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) GLBGoodsRecordView *recordView1;
@property (nonatomic, strong) GLBGoodsRecordView *recordView2;
@property (nonatomic, strong) GLBGoodsRecordView *recordView3;
@property (nonatomic, strong) GLBGoodsRecordView *recordView4;
@property (nonatomic, strong) GLBGoodsRecordView *recordView5;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation GLBGoodsRecordCell

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
    _titleLabel.text = @"采购记录（0笔）";
    [self.contentView addSubview:_titleLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor dc_colorWithHexString:@"#999999"];
    _countLabel.font = PFRFont(12);
    _countLabel.text = @"累计已采购0盒";
    _countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLabel];
    
    _recordView1 = [[GLBGoodsRecordView alloc] init];
    _recordView1.hidden = YES;
    [self.contentView addSubview:_recordView1];
    
    _recordView2 = [[GLBGoodsRecordView alloc] init];
    _recordView2.hidden = YES;
    [self.contentView addSubview:_recordView2];
    
    _recordView3 = [[GLBGoodsRecordView alloc] init];
    _recordView3.hidden = YES;
    [self.contentView addSubview:_recordView3];
    
    _recordView4 = [[GLBGoodsRecordView alloc] init];
    _recordView4.hidden = YES;
    [self.contentView addSubview:_recordView4];
    
    _recordView5 = [[GLBGoodsRecordView alloc] init];
    _recordView5.hidden = YES;
    [self.contentView addSubview:_recordView5];
    
    _line = [[UIImageView alloc] init];
    _line.backgroundColor = [UIColor dc_colorWithHexString:DC_LineColor];
    [self.contentView addSubview:_line];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setTitle:@"查看更多记录" forState:0];
    [_moreBtn setTitleColor:[UIColor dc_colorWithHexString:@"#303D55"] forState:0];
    _moreBtn.titleLabel.font = PFRFont(14);
    [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_moreBtn];
    
    [self layoutIfNeeded];
}


#pragma mark - action
- (void)moreBtnClick:(UIButton *)button
{
    if (_recordCellBlock) {
        _recordCellBlock();
    }
}


#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.top.equalTo(self.contentView.top);
        make.size.equalTo(CGSizeMake(150, 36));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-15);
        make.left.equalTo(self.titleLabel.right);
        make.centerY.equalTo(self.titleLabel.centerY);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.contentView.bottom);
        make.height.equalTo(36);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.bottom.equalTo(self.moreBtn.top);
        make.height.equalTo(1);
    }];
    
    CGFloat recordView1Height = self.recordView1.hidden ? 0 : 36;
    CGFloat recordView2Height = self.recordView2.hidden ? 0 : 36;
    CGFloat recordView3Height = self.recordView3.hidden ? 0 : 36;
    CGFloat recordView4Height = self.recordView4.hidden ? 0 : 36;
    CGFloat recordView5Height = self.recordView5.hidden ? 0 : 36;
    
    [self.recordView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.titleLabel.bottom);
        make.height.equalTo(recordView1Height);
    }];
    
    [self.recordView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.recordView1.bottom);
        make.height.equalTo(recordView2Height);
    }];
    
    [self.recordView3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.recordView2.bottom);
        make.height.equalTo(recordView3Height);
    }];
    
    [self.recordView4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.recordView3.bottom);
        make.height.equalTo(recordView4Height);
    }];
    
    [self.recordView5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(15);
        make.right.equalTo(self.contentView.right).offset(-15);
        make.top.equalTo(self.recordView4.bottom);
        make.height.equalTo(recordView5Height);
        make.bottom.equalTo(self.line.top);
    }];
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    _titleLabel.text = [NSString stringWithFormat:@"采购记录（%ld笔）",(long)_detailModel.orderCount];
    _countLabel.text = [NSString stringWithFormat:@"累计已采购%ld盒",(long)_detailModel.quantityCount];
    
    _recordView1.hidden = YES;
    _recordView2.hidden = YES;
    _recordView3.hidden = YES;
    _recordView4.hidden = YES;
    _recordView5.hidden = YES;
    
    NSArray<GLBRecordModel *> *array = _detailModel.orderList; // 采购记录
    for (int i=0; i<array.count; i++) {
        
        GLBRecordModel *model = array[i];
        
        if (i == 0) {
            _recordView1.hidden = NO;
            _recordView1.recordModel = model;
        } else if (i == 1) {
            _recordView2.hidden = NO;
            _recordView2.recordModel = model;
        } else if (i == 2) {
            _recordView3.hidden = NO;
            _recordView3.recordModel = model;
        } else if (i == 3) {
            _recordView4.hidden = NO;
            _recordView4.recordModel = model;
        } else if (i == 4) {
            _recordView5.hidden = NO;
            _recordView5.recordModel = model;
        }
    }
    
    [self layoutSubviews];
}

@end
