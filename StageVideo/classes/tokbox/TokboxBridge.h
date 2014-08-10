//
//  TokboxBridge.h
//  StageVideo
//
//  Created by kmgao on 14-5-21.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenTok/Opentok.h>

@class CallViewController;

@interface TokboxBridge : NSObject<OTSessionDelegate, OTSubscriberKitDelegate,OTPublisherDelegate>

@property(nonatomic,weak) CallViewController  *ctrlDelegate;

+(instancetype)shareTokbox;
-(void)install;

- (void)doConnect:(NSString*)token;
- (void)doDisconnect;
- (void)doPublish;
- (void)doUnpublish;

- (void)doSubscriber;
- (void)doUnSubcriber;



@end
