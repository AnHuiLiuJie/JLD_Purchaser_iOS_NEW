//
//  GLPHomeHeadView.m
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import "GLPHomeHeadView.h"

@interface GLPHomeHeadView ()

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) NSMutableArray<GLPAdModel *> *dataArray;

@property(nonatomic,assign) NSInteger selectindex;
@end

@implementation GLPHomeHeadView

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
    self.selectindex=1;
    _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.dc_height - 20)];
//    _bgImage.image = [UIImage imageNamed:@"bg1"];
    _bgImage.backgroundColor = [UIColor dc_colorWithHexString:@"#007B74"];
    _bgImage.clipsToBounds = YES;
    _bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_bgImage];
    
    WEAKSELF;
    _scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(14, kNavBarHeight + 13, kScreenW - 14*2, 0.376*kScreenW)];
    _scrollView.autoScrollTimeInterval = 6;
    _scrollView.placeholderImage = [UIImage imageNamed:@"ppic"];
    [_scrollView dc_cornerRadius:6];
    _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        // 按钮点击
//        if (weakSelf.bannerViewBlock) {
//            weakSelf.bannerViewBlock([weakSelf.dataArray[currentIndex] adLinkUrl]);
//        }
        if (weakSelf.bannerViewBlock) {
            weakSelf.bannerViewBlock(currentIndex);
        }
    };
    _scrollView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        weakSelf.selectindex=currentIndex;
        if (weakSelf.dataArray.count > 0) {
            GLPAdModel *adModel = weakSelf.dataArray[currentIndex];
            NSString *color = [NSString stringWithFormat:@"%@",adModel.adBgcolor] ;
            if (!color || color.length == 0) {
                color = @"#007B74";
            }
            weakSelf.bgImage.backgroundColor = [UIColor dc_colorWithHexString:color];
        }
        
    };
    [self addSubview:_scrollView];
    
    _scrollView.localizationImageNamesGroup = nil;
    _scrollView.localizationImageNamesGroup = @[@"banner",@"banner2"];
}


#pragma mark - setter
- (void)setBannerArray:(NSMutableArray<GLPAdModel *> *)bannerArray
{
    _bannerArray = bannerArray;
    
    if (!_bannerArray || [_bannerArray count] == 0) {
        return;
    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_bannerArray];
    
    NSMutableArray *imgUrlArray = [NSMutableArray array];
    for (GLPAdModel *adModel in _bannerArray) {
        [imgUrlArray addObject:adModel.adContent];
    }
    
    _scrollView.imageURLStringsGroup = nil;
    _scrollView.imageURLStringsGroup = imgUrlArray;
    NSString *color=@"#007B74";
        if (self.bannerArray.count-1>=self.selectindex)
        {
            GLPAdModel *adModel = _bannerArray[self.selectindex];
            color = adModel.adBgcolor;
        }
        else{
            GLPAdModel *adModel1 = _bannerArray[0];
            color = adModel1.adBgcolor;
        }
   
    if (!color || color.length == 0) {
        color = @"#007B74";
    }
   // _bgImage.backgroundColor = RGB_COLOR(0, 109, 103);
    _bgImage.backgroundColor = [UIColor dc_colorWithHexString:color];
   
}



#pragma mark - lazy load
- (NSMutableArray<GLPAdModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
