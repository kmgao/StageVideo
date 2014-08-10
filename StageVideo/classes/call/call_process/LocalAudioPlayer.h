//
//  AudioPlayer.h
//  UIVoice
//
//  Created by lab on 13-4-11.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalAudioPlayer : NSObject

+ (void)initLocalAudioPlayer;
+ (void)stopBusyRing;
+ (void)startBusyRing;
+ (void)stopPushRing;
+ (void)startPushRing;
+ (void)startRejectRing;
+ (void)stopRejectRing;
+ (void)startBeginCallSound;
+ (void)startFinishCallSound;
+ (void)stopOvertimeRing;
+ (void)startOvertimeRing;
+ (void)startIncomingRing;
+ (void)stopIncomingRing;
+ (void)stopAllRing;

+ (CGFloat)busyRingDuration;
+ (CGFloat)rejectRingDuration;
+ (CGFloat)overtimeRingDuration;
@end
