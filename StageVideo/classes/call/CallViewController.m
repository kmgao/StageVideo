//
//  CallViewController.m
//  StageVideo
//
//  Created by kmgao on 14-5-31.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "CallViewController.h"
#import "TokboxBridge.h"
#import "CallModel.h"
#import "MakeCallView.h"
#import "InComingView.h"
#import "CallConstDefine.h"
#import "CallConstDefine.h"

#define kVideoFrame CGRectMake(10, topOffset, self.view.frame.size.width - 20, self.view.frame.size.height - topOffset-30)

static NSString *const kTestToken = @"T1==cGFydG5lcl9pZD00NDcyNTUzMiZzZGtfdmVyc2lvbj10YnJ1YnktdGJyYi12MC45MS4yMDExLTAyLTE3JnNpZz0wNmEzNDQ5ZGNlNWYxNzc0N2ExMjgyMGQzNjdiMGQ2Njc2ZmUxNTIzOnJvbGU9bW9kZXJhdG9yJnNlc3Npb25faWQ9MV9NWDQwTkRjeU5UVXpNbjUtVTNWdUlFcDFiaUF3TVNBd09Ub3pOam8xTlNCUVJGUWdNakF4Tkg0d0xqRTRNelkxTnpFeGZsQi0mY3JlYXRlX3RpbWU9MTQwMTY0MDYyMyZub25jZT0wLjEyNzE5NjUyNjEzMjgzMTE3JmV4cGlyZV90aW1lPTE0MDQyMzI1ODcmY29ubmVjdGlvbl9kYXRhPQ==";



@interface CallViewController ()
{
    MakeCallView  *makeCallView;
    InComingView  *inComingCallView;
    CallBaseView  *curCallView;
}
@end

@implementation CallViewController

static CallViewController *g_instance = nil;
+(instancetype)shareInstance
{
    @synchronized(self)
    {
        if(g_instance == nil)
        {
            g_instance = [[CallViewController alloc] init];
        }
        return  g_instance;
    }
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self addCallObserver];
        self.model = [CallModel shareInstance];
    }
    return self;
}


-(void)addCallObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleObverserCallEvent:) name:kCallEventNotification object:nil];
}

-(void)removeCallObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCallEventNotification object:nil];
}

-(void)handleObverserCallEvent:(NSNotification*)notify
{
    NSNumber *statNum = (NSNumber*)notify.object;
    int status = [statNum intValue];
    
    if(status == OTSessionConnectionStatusNotConnected)
    {
        
    }
    else if(status == OTSessionConnectionStatusConnecting)
    {
        if(curCallView == makeCallView)
            [curCallView setCallState:E_Call_State_Connectting];
        else
            [curCallView setCallState:E_Call_State_Calling];
    }
    else if(status == OTSessionConnectionStatusConnected)
    {
        [curCallView setCallState:E_Call_State_Connectting];
        if(curCallView == makeCallView)
        {
            [[TokboxBridge shareTokbox] doPublish];
        }
        else
        {
            
        }
    }
    else if(status == OTSessionConnectionStatusDisconnecting)
    {
    
    }
    else if(status == OTSessionConnectionStatusFailed)
    {
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


-(void)makeCall:(NSString*)mobile callType:(int)type
{
    if(makeCallView == nil)
    {
        makeCallView = [[MakeCallView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT)];
        makeCallView.description = @"I graduated from The Hong Kong Polytechnic University majoring in Fashion Design and have never been too far away from the visual excitements afterwards. I continued with the bags and design freelance jobs while working in events and marketing full-time. « Nothing. Just Hype » is my take on all visual elements.I continued with the bags and design freelance jobs while working I continued with the bags and design freelance jobs while working";
        [makeCallView initialCallUI];
        
        curCallView = makeCallView;
    }
    [makeCallView setCallState:E_Call_State_Calling];
    [self.view addSubview:curCallView];
    
    [self presentViewController:YES];
    
    mobile = kTestToken;
    [[TokboxBridge shareTokbox] doConnect:mobile];
}

-(void)inComingCall:(int)callID callType:(int)type number:(NSString*)num
{

}

-(void)hangUpCall:(int)callID
{
    [[TokboxBridge shareTokbox] doDisconnect];
    [self dismissViewController:YES];
}

-(void)answerCall:(int)callType
{

}

//type 0: localtion call 1:remote call
-(void)handlePushCall:(int)type
{
    
}


#pragma 电话状态处理函数
- (void)handle_calling_event:(const struct cx_call_obj_info*)call_info
{
    
}

- (void)handle_inComing_event:(const struct cx_call_obj_info*)call_info
{

}

- (void)handle_early_event:(const struct cx_call_obj_info*)call_info
{

}

- (void)handle_connectting_event:(const struct cx_call_obj_info*)call_info
{

}

- (void)handle_confirmed_event:(const struct cx_call_obj_info*)call_info
{

}

- (void)handle_disconnected_event:(const struct cx_call_obj_info*)call_info
{

}

- (void)handle_busy_event:(const struct cx_call_obj_info*)call_info
{

}
#pragma End

#pragma mark- OTSessionDelegate

- (void)sessionDidConnect:(OTSession*)session
{

}

- (void)sessionDidDisconnect:(OTSession*)session
{


}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error
{

}

- (void)session:(OTSession*)session streamCreated:(OTStream*)stream
{
    
}

#pragma End


-(void)presentViewController:(BOOL)animation
{
    UIApplication *app = [UIApplication sharedApplication];
    if(animation)
    {
        self.view.alpha = 0;
        [app.keyWindow addSubview:self.view];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.view.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [app.keyWindow addSubview:self.view];
    }
}

-(void)dismissViewController:(BOOL)animation
{
    if(!animation)
    {
        [self.view removeFromSuperview];
    }
    else
    {
        __block CGRect _frame = self.view.frame;
        [UIView animateWithDuration:0.2 animations:^{
            _frame.origin.y += _frame.size.height;
            self.view.frame = _frame;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            inComingCallView = nil;
            makeCallView = nil;
            
            CGRect _frame = self.view.frame;
            
            if (isIOS7)
            {
                _frame.origin.y = 0;
            }
            else
            {
                _frame.origin.y = 20;
            }
            self.view.frame = _frame;
        }];
    }
    

}




@end
