//
//  GLPHomeDrugTypeCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/19.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPHomeDataModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HomeClassViewBlock)(NSInteger tag);
@interface GLPHomeClassCell : UITableViewCell

@property (nonatomic,assign) BOOL arte;
// 赋值
- (void)setValueWithDataModel:(GLPHomeDataModel *)dataModel indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,copy)HomeClassViewBlock viewBlock;
@end



@interface GLPHomeClassBigTypeView : UIView

// 赋值
- (void)setValueWithListModel:(GLPHomeDataListModel *)listModel indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UIButton *openBtn;

@end


@interface GLPHomeClassSmallTypeView : UIView

// 赋值
- (void)setValueWithListModel:(GLPHomeDataListModel *)listModel indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
