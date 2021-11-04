//
//  GLPGroupDetailsFootterView.h
//  DCProject
//
//  Created by LiuMac on 2021/9/14.
//

#import <UIKit/UIKit.h>
#import "DCActivityBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLPGroupDetailsFootterView : UIView

@property (nonatomic, strong) DCMyCollageListModel *model;


@property (nonatomic, copy) dispatch_block_t GLPGroupDetailsFootterView_block;
@property (nonatomic, copy) void(^GLPGroupDetailsFootterView_endblock)(NSString *title) ;


@end




@interface GLPGroupDetailsTimeView : UIView

@property (nonatomic, strong) DCMyCollageListModel *model;

@property (nonatomic, assign) NSInteger timeType;
@property (nonatomic, copy) void(^GLPGroupDetailsTimeView_endblock)(NSString *title) ;

/*秒*/
@property(nonatomic,strong) UILabel *secondLab;
@property(nonatomic,strong) UILabel *spacLab1;
/*分*/
@property(nonatomic,strong) UILabel *minuteLab;
@property(nonatomic,strong) UILabel *spacLab2;
/*时*/
@property(nonatomic,strong) UILabel *hourLab;
@property(nonatomic,strong) UILabel *spacLab3;
/*天*/
@property(nonatomic,strong) UILabel *dayLab;

@end

NS_ASSUME_NONNULL_END
