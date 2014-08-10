//
//  AudioPlayer.m
//  UIVoice
//
//  Created by lab on 13-4-11.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import "LocalAudioPlayer.h"

@implementation LocalAudioPlayer

static AVAudioPlayer *incomingRingPlayer;
static AVAudioPlayer *pushPlayer;
static AVAudioPlayer *busyPlayer;
static AVAudioPlayer *rejectPlayer;
static AVAudioPlayer *overtimePlayer;
static AVAudioPlayer *beginCallPlayer;
static AVAudioPlayer *finishCallPlayer;

+ (CGFloat)busyRingDuration
{
    return busyPlayer.duration;
}

+ (CGFloat)rejectRingDuration
{
    return rejectPlayer.duration;
}

+ (CGFloat)overtimeRingDuration
{
    return overtimePlayer.duration;
}

+ (void)initLocalAudioPlayer
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pushRing" ofType:@"aiff"];
    NSURL *url = [NSURL fileURLWithPath:path];
    pushPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"busy" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    busyPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"reject" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    rejectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"overTime" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    overtimePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"call_start" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    beginCallPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"call_end" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    finishCallPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    path = [[NSBundle mainBundle] pathForResource:@"incomCall" ofType:@"caf"];
    url = [NSURL fileURLWithPath:path];
    incomingRingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

+ (void)startBeginCallSound
{
    [beginCallPlayer prepareToPlay];
    beginCallPlayer.currentTime = 0.0;
    beginCallPlayer.volume = 3.0;
    [beginCallPlayer play];
}

+ (void)startFinishCallSound
{
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    AudioServicesPlaySystemSound(finishCallID);
    [finishCallPlayer prepareToPlay];
    finishCallPlayer.currentTime = 0.0;
    finishCallPlayer.volume = 3.0;
    [finishCallPlayer play];
}

+ (void)startPushRing
{
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    [pushPlayer prepareToPlay];
    //    pushPlayer.numberOfLoops = -1;
    //    pushPlayer.volume = 1.5;
    //    [pushPlayer play];
    [pushPlayer prepareToPlay];
    pushPlayer.currentTime = 0.0;
    pushPlayer.numberOfLoops = -1;
    pushPlayer.volume = 1.5;
    [pushPlayer play];
}

+ (void)stopPushRing
{
    [pushPlayer stop];
}

+ (void)startRejectRing
{
    [rejectPlayer prepareToPlay];
    rejectPlayer.currentTime = 0.0;
    rejectPlayer.numberOfLoops = -1;
    [rejectPlayer play];
    
}
+ (void)stopRejectRing
{
    [rejectPlayer stop];
}

+ (void)stopOvertimeRing
{
    [overtimePlayer stop];
}
+ (void)startOvertimeRing
{
    [overtimePlayer prepareToPlay];
    overtimePlayer.currentTime = 0.0;
    overtimePlayer.numberOfLoops = -1;
    overtimePlayer.volume = 1.5;
    [overtimePlayer play];
}


+ (void)startBusyRing
{
    busyPlayer.currentTime = 0.0;
    busyPlayer.numberOfLoops = -1;
    busyPlayer.volume = 1.0;
    [busyPlayer prepareToPlay];
    [busyPlayer play];
}

+ (void)stopBusyRing
{
    [busyPlayer stop];
}

+ (void)startIncomingRing
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    incomingRingPlayer.currentTime = 0.0;
    [incomingRingPlayer prepareToPlay];
    incomingRingPlayer.numberOfLoops = -1;
    [incomingRingPlayer play];
}

+ (void)stopIncomingRing
{
    [incomingRingPlayer stop];
}

+ (void)stopAllRing
{
    [LocalAudioPlayer stopBusyRing];
    [LocalAudioPlayer stopPushRing];
    [LocalAudioPlayer stopRejectRing];
    [LocalAudioPlayer stopOvertimeRing];
    [LocalAudioPlayer stopIncomingRing];
}


@end
