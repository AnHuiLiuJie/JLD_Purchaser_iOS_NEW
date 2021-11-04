//
//  GLPGoodsDetailsHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/20.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsHeadView.h"
#import <YBImageBrowser/YBImageBrowser.h>

@interface GLPGoodsDetailsHeadView ()

@property (nonatomic, strong)UILabel *placeholderLab;

@end


//#import "YBImage.h"
@implementation GLPGoodsDetailsHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.placeholderImage = [[DCPlaceholderTool shareTool] dc_placeholderImage];
    _scrollView.autoScroll = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.currentPageDotColor = [UIColor dc_colorWithHexString:DC_BtnColor];
    _scrollView.showPageControl = NO;
    [self addSubview:_scrollView];
    
    _placeholderLab = [[UILabel alloc] init];
    _placeholderLab.backgroundColor = [UIColor dc_colorWithHexString:@"#b2b2b2"];
    _placeholderLab.textColor = [UIColor whiteColor];
    _placeholderLab.textAlignment = NSTextAlignmentCenter;
    _placeholderLab.font = [UIFont fontWithName:PFR size:12];
    [self addSubview:_placeholderLab];
    
    [_scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.bottom.equalTo(self.bottom);
        make.height.equalTo(kScreenW);
    }];
    
    [_placeholderLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-15);
        make.bottom.equalTo(self.bottom).offset(-5);
        make.height.equalTo(20);
        make.width.equalTo(40);
    }];
    
    [_placeholderLab dc_cornerRadius:10];

    WEAKSELF;
    _scrollView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        NSLog(@"%ld",currentIndex);
        weakSelf.placeholderLab.text = [NSString stringWithFormat:@"%ld/%ld",currentIndex+1,weakSelf.imageArray.count];
    };
    
    //[self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


#pragma mark - set
- (void)setDetailModel:(GLPGoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    
    _scrollView.imageURLStringsGroup = nil;

    NSMutableArray *imgurlArray = [NSMutableArray array];
    if (_detailModel.goodsImgs) {
        if ([_detailModel.goodsImgs containsString:@","]) {
            [imgurlArray addObjectsFromArray:[_detailModel.goodsImgs componentsSeparatedByString:@","]];
        } else {
            [imgurlArray addObject:_detailModel.goodsImgs];
        }
    }
    _scrollView.imageURLStringsGroup = imgurlArray;
    _imageArray = [imgurlArray mutableCopy];
    
    self.placeholderLab.text = [NSString stringWithFormat:@"%d/%ld",1,self.imageArray.count];
;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    
    _scrollView.imageURLStringsGroup = nil;
    _scrollView.imageURLStringsGroup = imageArray;
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSString *url  in _scrollView.imageURLStringsGroup) {
        NSString *strUrl = [url stringByReplacingOccurrencesOfString:@"_420x420" withString:@""];
        YBIBImageData *data0 = [YBIBImageData new];
        data0.imageURL = [NSURL URLWithString:strUrl];
        [arr addObject:data0];
    }
    _brow = [YBImageBrowser new];
    _brow.autoHideProjectiveView = NO;
//    _brow.outTransitionType = 0;
//    _brow.enterTransitionType = 0;
    _brow.dataSourceArray = arr;
    _brow.currentPage = index;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    _brow.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [_brow show];
}



@end
