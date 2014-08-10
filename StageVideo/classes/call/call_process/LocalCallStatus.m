//
//  LocalCallStatus.m
//  UIVoice
//
//  Created by lab on 13-4-11.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import "LocalCallStatus.h"
#import "AppDelegate.h"

@interface CallPJSIPStatus : NSObject
{
    NSInteger mStatus;
}
@property(assign)NSInteger status;
@end

@implementation CallPJSIPStatus
@synthesize status=mStatus;
@end

@implementation LocalCallStatus

- (id)init
{
    if(self = [super init])
    {
        mCallStatus = [[CallPJSIPStatus alloc] init];
        mCallStatus.status = E_CALL_VALID;
    }
    return self;
}
//设置通话状态
- (void)setCallStatus:(NSInteger)eCallStatus
{
    @synchronized(mCallStatus)
    {
        mCallStatus.status = eCallStatus;
        
        AppDelegate *app = [AppDelegate sharedDelegate];
        if(eCallStatus == E_CALL_VALID)
        {
            //设置当前是否正在通话
            app.pjsipConfig->incalling = NO;
            //设置当前自动回复
            [app pjsipConfig]->auto_answer = 180;
            INFO(@"%s set auto answer = %d", __FUNCTION__, [app pjsipConfig]->auto_answer);
        }else
        {
            app.pjsipConfig->incalling = YES;
            [app pjsipConfig]->auto_answer = 486;
            INFO(@"%s set auto answer = %d", __FUNCTION__, [app pjsipConfig]->auto_answer);
        }
    }
}

- (NSInteger)getCallStatus
{
    return mCallStatus.status;
}
@end
