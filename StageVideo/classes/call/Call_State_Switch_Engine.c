//
//  Call_Status_Engine.m
//  TalkingFlower
//
//  Created by kmgao on 14-6-02.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#include <stdio.h>

#include "Call_State_Switch_Engine.h"

#define kMax_User_Count   16

#define CHECK_APP_IMP_POINT(ptr) if((ptr) == NULL){return 0;}

#define CHECK_CALL_LIST_STATE_ACTIVE    \
{                                        \
    if(checkUserActiveState())           \
    {                                     \
        handle_busy_event(callInfo);        \
        return 0;                         \
    }                                      \
}

typedef struct  cx_call_user_list
{
    int state;
    int call_id;
}cx_call_user_list;

static cx_call_user_list g_call_user_list[kMax_User_Count] = {0};

static int g_resetUsesListState();
static int checkUserActiveState();


static App_Callback_FunPtr          g_App_Callback_Interface_fun = NULL;

//回电话忙音
extern  void pjsip_busyAnswer(int call_id);

static int handle_busy_event(const struct cx_call_obj_info* callInfo)
{
    pjsip_busyAnswer(callInfo->call_id);
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_BUSY,callInfo);
    return 0;
}

static int handle_disconnect_event(const struct cx_call_obj_info* callInfo)
{
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_DISCONNECTED,callInfo);
    g_resetUsesListState();
    
    return  1;
}

//===========================Calling Null state ======================//
static int CL_ST_Null2Null(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Null2Calling(const struct cx_call_obj_info* callInfo)
{
//    CHECK_CALL_LIST_STATE_ACTIVE;//
    if(checkUserActiveState())
    {//异常处理,如果当前还有通话，当前状态不改变，这通电话不做任何处理
        return 0;
    }
    
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_CALLING,callInfo);
    return 1;
}

static int CL_ST_Null2Incoming(const struct cx_call_obj_info* callInfo)
{
    CHECK_CALL_LIST_STATE_ACTIVE;
    
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_INCOMING,callInfo);
    return 1;
}

static int CL_ST_Null2Early(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}


static int CL_ST_Null2Connectting(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Null2ConFirmed(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}


static int CL_ST_Null2Disconnected(const struct cx_call_obj_info* callInfo)
{
    if(checkUserActiveState())
    {//如果当前还有通话，当前状态不改变，这通电话不做任何处理
        return 0;
    }
    handle_disconnect_event(callInfo);
    return 1;
}

//===========================Calling Call state ======================//

static int CL_ST_Calling2NULL(const struct cx_call_obj_info* callInfo)
{ //不可能出现
    return 0;
}

static int CL_ST_Calling2Calling(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Calling2Icoming(const struct cx_call_obj_info* callInfo)
{//拒听,要给对方回忙音
    return handle_busy_event(callInfo);
}
//对方响铃
static int CL_ST_Calling2Early(const struct cx_call_obj_info* callInfo)
{
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_EARLY,callInfo);
    
    return 1;
}

static int CL_ST_Calling2Connectting(const struct cx_call_obj_info* callInfo)
{
    return 1;
}

static int CL_ST_Calling2Confirmed(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Calling2Disconnected(const struct cx_call_obj_info* callInfo)
{
    handle_disconnect_event(callInfo);
    return 1;
}


//===========================inComing Call state ======================//

static int CL_ST_InComing2NULL(const struct cx_call_obj_info* callInfo)
{ //不可能出现
    return 0;
}

static int CL_ST_InComing2Calling(const struct cx_call_obj_info* callInfo)
{ //不可能出现
    return 0;
}

static int CL_ST_InComing2InComing(const struct cx_call_obj_info* callInfo)
{
    //拒听,要给对方回忙音
    return handle_busy_event(callInfo);
}

static int CL_ST_InComing2Early(const struct cx_call_obj_info* callInfo)
{ //来电到响铃
    return 1;
}

static int CL_ST_InComing2Connectting(const struct cx_call_obj_info* callInfo)
{
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_CONNECTING,callInfo);
    return 1;
}

static int CL_ST_InComing2ConFirmed(const struct cx_call_obj_info* callInfo)
{
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_CONFIRMED,callInfo);
    return 1;
}

static int CL_ST_InComing2Disconnected(const struct cx_call_obj_info* callInfo)
{
    handle_disconnect_event(callInfo);
    return 1;
}


//===========================Early Call state ======================//

static int CL_ST_Early2NULL(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Early2Calling(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Early2Incoming(const struct cx_call_obj_info* callInfo)
{
    //拒听,要给对方回忙音
    return handle_busy_event(callInfo);
}

static int CL_ST_Early2Early(const struct cx_call_obj_info* callInfo)
{ //不可能出现
    return 0;
}

static int CL_ST_Early2Connectting(const struct cx_call_obj_info* callInfo)
{
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_CONNECTING,callInfo);
    return 1;
}

static int CL_ST_Early2Conformed(const struct cx_call_obj_info* callInfo)
{ //不可能出现
    return 0;
}

static int CL_ST_Early2Disconnected(const struct cx_call_obj_info* callInfo)
{
    handle_disconnect_event(callInfo);
    return 1;
}

//===========================CONNECTING Call state ======================//

static int CL_ST_Connectting2NUll(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Connectting2Calling(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Connectting2InComing(const struct cx_call_obj_info* callInfo)
{
    //拒听,要给对方回忙音
    return handle_busy_event(callInfo);
}

static int CL_ST_Connectting2Early(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Connectting2Connectting(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Connectting2Confirmed(const struct cx_call_obj_info* callInfo)
{
    CHECK_APP_IMP_POINT(g_App_Callback_Interface_fun);
    g_App_Callback_Interface_fun(E_CALL_STATE_CONFIRMED,callInfo);
    return 1;
}

static int CL_ST_Connectting2Disconnected(const struct cx_call_obj_info* callInfo)
{
    handle_disconnect_event(callInfo);
    return 1;
}


//===========================Confirmed Call state ======================//

static int CL_ST_Confirmed2NUll(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Confirmed2Calling(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Confirmed2InComing(const struct cx_call_obj_info* callInfo)
{
    //拒听,要给对方回忙音
    return handle_busy_event(callInfo);
}

static int CL_ST_Confirmed2Early(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Confirmed2Connectting(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Confirmed2Confirmed(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Confirmed2Disconnected(const struct cx_call_obj_info* callInfo)
{
    handle_disconnect_event(callInfo);
    return 1;
}


//===========================Disconnected Call state ======================//
static int CL_ST_Disconnected2NUll(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Disconnected2Calling(const struct cx_call_obj_info* callInfo)
{
    return 0;
}

static int CL_ST_Disconnected2Icoming(const struct cx_call_obj_info* callInfo)
{
    return 0;
}

static int CL_ST_Disconnected2Early(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Disconnected2Connectting(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Disconnected2Confirmed(const struct cx_call_obj_info* callInfo)
{//不可能出现
    return 0;
}

static int CL_ST_Disconnected2Disconnected(const struct cx_call_obj_info* callInfo)
{
    return 0;
}

typedef int (*call_status_handle)(const struct cx_call_obj_info* callInfo);

/***************************************************
 typedef enum pjsip_inv_state
 {
 PJSIP_INV_STATE_NULL,	    //< Before INVITE is sent or received
 PJSIP_INV_STATE_CALLING,	//< After INVITE is sent
 PJSIP_INV_STATE_INCOMING,	// < After INVITE is received.
 PJSIP_INV_STATE_EARLY,	    // < After response with To tag.
 PJSIP_INV_STATE_CONNECTING,  // < After 2xx is sent/received.
 PJSIP_INV_STATE_CONFIRMED,	  //< After ACK is sent/received.
 PJSIP_INV_STATE_DISCONNECTED,  //< Session is terminated.
 } pjsip_inv_state;
 **************************************************/

static call_status_handle g_call_handle_fun[E_CALL_STATE_COUNT][E_CALL_STATE_COUNT] =
{
    {
        CL_ST_Null2Null,
        CL_ST_Null2Calling,
        CL_ST_Null2Incoming,
        CL_ST_Null2Early,
        CL_ST_Null2Connectting,
        CL_ST_Null2ConFirmed,
        CL_ST_Null2Disconnected
    },
    {
        CL_ST_Calling2NULL,
        CL_ST_Calling2Calling,
        CL_ST_Calling2Icoming,
        CL_ST_Calling2Early,
        CL_ST_Calling2Connectting,
        CL_ST_Calling2Confirmed,
        CL_ST_Calling2Disconnected
    },
    {
        CL_ST_InComing2NULL,
        CL_ST_InComing2Calling,
        CL_ST_InComing2InComing,
        CL_ST_InComing2Early,
        CL_ST_InComing2Connectting,
        CL_ST_InComing2ConFirmed,
        CL_ST_InComing2Disconnected
    },
    {
        CL_ST_Early2NULL,
        CL_ST_Early2Calling,
        CL_ST_Early2Incoming,
        CL_ST_Early2Early,
        CL_ST_Early2Connectting,
        CL_ST_Early2Conformed,
        CL_ST_Early2Disconnected,
    },
    {
        CL_ST_Connectting2NUll,
        CL_ST_Connectting2Calling,
        CL_ST_Connectting2InComing,
        CL_ST_Connectting2Early,
        CL_ST_Connectting2Connectting,
        CL_ST_Connectting2Confirmed,
        CL_ST_Connectting2Disconnected,
    },
    {
        CL_ST_Confirmed2NUll,
        CL_ST_Confirmed2Calling,
        CL_ST_Confirmed2InComing,
        CL_ST_Confirmed2Early,
        CL_ST_Confirmed2Connectting,
        CL_ST_Confirmed2Confirmed,
        CL_ST_Confirmed2Disconnected,
    },
    {
        CL_ST_Disconnected2NUll,
        CL_ST_Disconnected2Calling,
        CL_ST_Disconnected2Icoming,
        CL_ST_Disconnected2Early,
        CL_ST_Disconnected2Connectting,
        CL_ST_Disconnected2Confirmed,
        CL_ST_Disconnected2Disconnected,
    },
};

static void printLog(int call_id,int current,int next,int call_type,int code,long totalTime)
{
    char *stateInf[] = {
        "E_Call_STATE_NULL","E_Call_STATE_CALLING","E_Call_STATE_INCOMING",\
        "E_Call_STATE_EARLY","E_Call_STATE_CONNECTING","E_Call_STATE_CONFIRMED",\
        "E_Call_STATE_DISCONNECTED"
    };
    printf("call id = %d\t status current->%s\t next->%s\t call_type=%d\t code=%d\t time=%ld\n",call_id,stateInf[current],stateInf[next],call_type,code,totalTime);
}

static int checkUserActiveState()
{
    for(int i = kMax_User_Count - 1; i >= 0 ;i--)
    {
        if((g_call_user_list[i].state > E_CALL_STATE_NULL) && (g_call_user_list[i].state < E_CALL_STATE_DISCONNECTED))
        {
            return 1;
        }
    }
    return 0;
}

static int g_resetUsesListState()
{
  //  printf("<<<<<<<<<<<<<<<<<<<<<<<<<11111111>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    for(int i = kMax_User_Count - 1; i >= 0 ;i--)
    {
        g_call_user_list[i].state = E_CALL_STATE_NULL;
        g_call_user_list[i].call_id = 0;
    }
    return 1;
}


void call_status_change_handle(int nextState, cx_call_obj_info* call_info)
{
    if(nextState < 0 || nextState >= E_CALL_STATE_COUNT)
    {
        printf("invalid call statue[%d] change \n",nextState);
        return;
    }
    if(call_info == NULL) return ;
    
    printLog(call_info->call_id,g_call_user_list[call_info->call_id].state,nextState,call_info->call_type,call_info->status_code,call_info->total_duration);
 
    call_status_handle fun = g_call_handle_fun[g_call_user_list[call_info->call_id].state][nextState];
    if(fun)
    {
        int ret = fun(call_info);
        if(!ret) return ;
    }
    g_call_user_list[call_info->call_id].state = nextState;//这个状态保存方便日志调试用
    if(nextState == E_CALL_STATE_DISCONNECTED)
    {//解决最后一次挂电话后,又重新把当前电话状态最后一次状态给它赋值bug
        g_resetUsesListState();
    }
}

void regist_App_Callback_funtion(App_Callback_FunPtr callbackFun)
{
    g_App_Callback_Interface_fun = callbackFun;
}
