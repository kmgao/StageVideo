//
//  CallModel.m
//  StageVideo
//
//  Created by kmgao on 14-6-3.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "CallModel.h"
#import "Call_State_Switch_Engine.h"
#import "CallViewController.h"

@implementation CallModel

void  Call_State_Event_Handle(int callState, const struct cx_call_obj_info* call_info)
{
    //    NSLog(@"===============call type = %d",call_info->call_type);
    CallModel *model = [CallModel shareInstance];
    model.callState = callState;
    
    if(callState == E_CALL_STATE_CALLING){
        [model.viewCtrl handle_calling_event:call_info];
    }
    else if(callState == E_CALL_STATE_INCOMING){
        [model.viewCtrl handle_inComing_event:call_info];
    }
    else if(callState == E_CALL_STATE_EARLY){
        [model.viewCtrl handle_early_event:call_info];
    }
    else if(callState == E_CALL_STATE_CONNECTING){
        [model.viewCtrl handle_connectting_event:call_info];
    }
    else  if(callState == E_CALL_STATE_CONFIRMED){
        [model.viewCtrl handle_confirmed_event:call_info];
    }
    else  if(callState == E_CALL_STATE_DISCONNECTED){
        [model.viewCtrl handle_disconnected_event:call_info];
    }
    else if(callState == E_CALL_STATE_BUSY){
        //处理忙音
        [model.viewCtrl handle_busy_event:call_info];
    }
}

static CallModel *g_instance = nil;
+(instancetype)shareInstance
{
    if(g_instance == nil)
    {
        g_instance = [[CallModel alloc]  init];
    }
    return g_instance;
}


-(instancetype)init
{
    self = [super init];
    if(self)
    {
        regist_App_Callback_funtion(&Call_State_Event_Handle);
    }
    return self;
}

@end
