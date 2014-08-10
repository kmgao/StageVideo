//
//  Call_Status_Engine.h
//  TalkingFlower
//
//  Created by kmgao on 14-6-02.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#ifndef __Call_Status_Switch_Engine_H__
#define __Call_Status_Switch_Engine_H__

#ifdef __cplusplus
extern "C" {
#endif

typedef  struct cx_call_obj_info{
    int          call_id;        /*current call id*/
    int          call_type;      /*current call type [audio && video]*/
    char         number[32];     /*current call number*/
    int          status_code;    /*curent call status code <see the enum pjsip_status_code> */
    float        con_duration;   /*curent call connect duration seconds >*/
    float        total_duration; /*curent call Total call duration, including set-up time */
    
} cx_call_obj_info;
    
/** 对接pjsip库电话状态改变接口
 *电话状态处理函数
 *@param nextState  电话下一个即将改变的状态<see pjsip num  pjsip_inv_state>
 *@param call_info  电话状态相关的信息
 */
void call_status_change_handle(int nextState, struct cx_call_obj_info* call_info);

typedef enum cx_Call_State_ID{
    E_CALL_STATE_NULL, //空状态
    E_CALL_STATE_CALLING,//打电话状态,会话还没建立
    E_CALL_STATE_INCOMING,//来话状态
    E_CALL_STATE_EARLY,  //响铃状态
    E_CALL_STATE_CONNECTING,//响铃后,正在连接状态，还没连上
    E_CALL_STATE_CONFIRMED, //已经连上状态
    E_CALL_STATE_DISCONNECTED, //电话断开状态
    E_CALL_STATE_COUNT,
    E_CALL_STATE_BUSY, //当前电话正在会话建立或通话中,此时来了一个新的电话,要弹出一个未接来电提醒,它不属于当前电话状态
}cx_Call_State_ID;
    
/** 对接App上层函数指针
 *用于电话状态机改变后,回调给上层App,因此上层App必须要定义这个函数指针指向的函数
 *@param curStatate 电话当前的状态<see the num cx_Call_State_ID>
 *@param call_info  电话状态相关的信息
 */
typedef void  (*App_Callback_FunPtr)(int callState, const struct cx_call_obj_info* call_info);
extern  void  regist_App_Callback_funtion(App_Callback_FunPtr callbackFun);

#ifdef __cplusplus
}
#endif

#endif //__Call_Status_Switch_Engine_H__