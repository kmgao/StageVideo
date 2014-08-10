//
//  CallBaseView.m
//  StageVideo
//
//  Created by kmgao on 14-6-6.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "CallBaseView.h"
#import "CallConstDefine.h"

@interface CallBaseView()
{
    UILabel        *m_callState;
}
@end


@implementation CallBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)initialCallUI
{
    //imp by subclass
}

-(void)setCallStateInfFrame:(CGRect)_frame
{
    [m_callState setFrame:_frame];
}

- (void)setSpeaker:(BOOL)bSpeaker
{
    //imp by subclass
}
- (void)setCamera:(BOOL)bCamera
{
    //imp by subclass
}

-(void)setStatueInfo:(NSString*)statInfo
{
    if(m_callState == nil)
    {
        m_callState = [[UILabel alloc] init];
        m_callState.backgroundColor = [UIColor clearColor];
        m_callState.textColor = [UIColor whiteColor];
        m_callState.textAlignment = NSTextAlignmentCenter;
        m_callState.frame = CGRectMake(0, kScale2x(117), IPHONE_SCREEN_WIDTH, kScale2x(140));
        m_callState.font = [UIFont systemFontOfSize:36];
        
        [self addSubview:m_callState];
    }
    
    _statueInfo = statInfo;
    m_callState.text = statInfo;
}

-(void)setCallState:(int)state
{
    if(state == E_Call_State_Calling)
    {
        [self setStatueInfo:@"Connecting"];
    }
    if(state == E_Call_State_InComing)
    {
        [self setStatueInfo:@"You've got a Stage Request"];
    }
    if(state == E_Call_State_Early)
    {
        
    }
    if(state == E_Call_State_Connectting)
    {
        [self setStatueInfo:@"Accepting Request"];
    }
    if(state == E_Call_State_Conformed)
    {
        
    }
}



@end
