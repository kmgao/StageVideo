//
//  CallConstDefine.h
//  StageVideo
//
//  Created by kmgao on 14-6-4.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#ifndef StageVideo_CallConstDefine_h
#define StageVideo_CallConstDefine_h

typedef enum ECallType
{
    E_Call_Audio,
    E_Call_Video
}ECallType;

typedef enum E_Call_Statue
{
    E_Call_State_Null, //空状态
    E_Call_State_Calling,//打电话状态,会话还没建立
    E_Call_State_InComing,//来话状态
    E_Call_State_Early,  //响铃状态
    E_Call_State_Connectting,//响铃后,正在连接状态，还没连上
    E_Call_State_Conformed, //已经连上状态
    E_Call_State_Disconnected, //电话断开状态
    E_Call_State_Busy,//忙音
    E_Call_State_Count
}E_Call_Statue;


#endif
