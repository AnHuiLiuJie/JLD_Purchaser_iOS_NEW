//
//  GLPEtpCenterRebateCell.h
//  DCProject
//
//  Created by 赤道 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "CustomTitleView.h"
#import "FHXSingleTrendModel.h"

#import "FHXMaskLineView.h"
//#import "FHXChartNoDataView.h"

@protocol GLPEtpCenterRebateCellDelegate <NSObject>
@optional
- (void)switchSelectTypeAction:(NSInteger)type;
@end

NS_ASSUME_NONNULL_BEGIN

@interface GLPEtpCenterRebateCell : UITableViewCell<FHXMaskLineViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *allBgView;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *dataBgView;
@property (weak, nonatomic) IBOutlet CustomTitleView *switchBgView;

@property(nonatomic,strong)NSString *title;//标题
@property(nonatomic,strong)NSString *unitStr;//单位

//折线类型
@property(nonatomic,assign) NSInteger type;
@property (nonatomic, copy) void(^GLPEtpCenterRebateCell_block)(NSInteger btnTag);

@property(nonatomic,strong)NSMutableArray *dataArray;//数据源
@property(nonatomic,weak)id<GLPEtpCenterRebateCellDelegate>delegate;

@property(nonatomic,strong) UIView *noDataView;

@end

NS_ASSUME_NONNULL_END
