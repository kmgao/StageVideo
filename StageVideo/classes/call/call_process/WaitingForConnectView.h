//
//  WaitingForConnectController.h
//  UIVoice
//
//  Created by le ting on 13-1-20.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitForServiceCallbackView.h"

@protocol WaitingForConnectViewDelegate <NSObject>
- (void)finishRemotionPush;
@end

@interface WaitingForConnectView : WaitForServiceCallbackView
{
    NSString *mTelNumber;
    id <WaitingForConnectViewDelegate>mRemotionPushDelegate;
}
@property (nonatomic, assign)id<WaitingForConnectViewDelegate>remotionPushDelegate;
@property (nonatomic,assign)NSString *telNumber;
@end
