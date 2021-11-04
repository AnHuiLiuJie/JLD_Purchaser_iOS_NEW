//
//  DCProtocolView.h
//  DCProject
//
//  Created by bigbing on 2020/4/26.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DCProtocolBlock)(NSString *_Nullable apiStr);

NS_ASSUME_NONNULL_BEGIN

@interface DCProtocolView : UIView

@property (nonatomic, copy) NSString *showType;
@property (nonatomic, copy) dispatch_block_t agreeBlock;
@property (nonatomic, copy) DCProtocolBlock protocolBlock;

@end

NS_ASSUME_NONNULL_END
