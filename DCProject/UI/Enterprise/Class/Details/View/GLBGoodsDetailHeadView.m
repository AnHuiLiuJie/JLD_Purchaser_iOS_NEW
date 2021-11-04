//
//  GLBGoodsDetailHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/7/30.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLBGoodsDetailHeadView.h"
//#import "YBImage.h"
#import <YBImageBrowser/YBImageBrowser.h>
@interface GLBGoodsDetailHeadView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) NSMutableArray *bannerArray;

@end

@implementation GLBGoodsDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
        
    _scrollView = [[SDCycleScrollView alloc] initWithFrame:self.bounds];
    _scrollView.placeholderImage = [[DCPlaceholderTool shareTool] dc_placeholderImage];
//    _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
//        // 按钮点击
//    };
    WEAKSELF;
    _scrollView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        weakSelf.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)currentIndex+1,(long)weakSelf.bannerArray.count];
    };
    _scrollView.showPageControl = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 36 - 11, self.dc_height - 18 - 13, 36, 18)];
    _countLabel.backgroundColor = [UIColor dc_colorWithHexString:@"#999999"];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.text = @"0/0";
    _countLabel.font = PFRFont(12);
    [_countLabel dc_cornerRadius:9];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countLabel];
}


#pragma mark - setter
- (void)setDetailModel:(GLBGoodsDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    if (_detailModel && _detailModel.picUrl) {
        
        [self.bannerArray removeAllObjects];
        [self.bannerArray addObjectsFromArray:_detailModel.picUrl];
        
        self.scrollView.imageURLStringsGroup = nil;
        self.scrollView.imageURLStringsGroup = self.bannerArray;
        
        if (self.bannerArray.count > 0) {
            _countLabel.hidden = NO;
            _countLabel.text = [NSString stringWithFormat:@"1/%ld",(long)self.bannerArray.count];
        }
       
    } else {
        _countLabel.hidden = YES;
    }
    
}


#pragma mark - lazy load
- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSString *url  in _scrollView.imageURLStringsGroup) {
        YBIBImageData *data0 = [YBIBImageData new];
        data0.imageURL = [NSURL URLWithString:url];
        [arr addObject:data0];
    }
   YBImageBrowser *_brow = [YBImageBrowser new];
//    _brow.outTransitionType = 0;
//    _brow.enterTransitionType = 0;
    _brow.dataSourceArray = arr;
    _brow.currentPage = index;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    _brow.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
     [_brow show];
}
@end
