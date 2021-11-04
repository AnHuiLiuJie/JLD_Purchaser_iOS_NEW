//
//  GLBNotificationMsgCell.h
//  DCProject
//
//  Created by bigbing on 2019/8/2.
//  Copyright © 2019 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLBNotificationMsgCell : UITableViewCell

@property (nonatomic, strong) GLBMessageModel *messageModel;

@end

NS_ASSUME_NONNULL_END
