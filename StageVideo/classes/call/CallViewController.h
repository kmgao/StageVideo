//
//  CallViewController.h
//  StageVideo
//
//  Created by kmgao on 14-5-31.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BaseViewController.h"

struct cx_call_obj_info;

@class CallModel;

@interface CallViewController : BaseViewController

@property(nonatomic,strong) CallModel   *model;

+(instancetype)shareInstance;

-(void)presentViewController:(BOOL)animation;
-(void)dismissViewController:(BOOL)animation;

//<see the enum ECallType in CallConstDefine.h>
//mobile 为token
-(void)makeCall:(NSString*)mobile callType:(int)type;
-(void)inComingCall:(int)callID callType:(int)type number:(NSString*)num;
-(void)hangUpCall:(int)callID;
-(void)answerCall:(int)callType;

//type 0: localtion call 1:remote call
-(void)handlePushCall:(int)type;

#pragma 电话状态处理函数
- (void)handle_calling_event:(const struct cx_call_obj_info*)call_info;
- (void)handle_inComing_event:(const struct cx_call_obj_info*)call_info;
- (void)handle_early_event:(const struct cx_call_obj_info*)call_info;
- (void)handle_connectting_event:(const struct cx_call_obj_info*)call_info;
- (void)handle_confirmed_event:(const struct cx_call_obj_info*)call_info;
- (void)handle_disconnected_event:(const struct cx_call_obj_info*)call_info;
- (void)handle_busy_event:(const struct cx_call_obj_info*)call_info;
#pragma End

@end
