//
//  TokboxBridge.m
//  StageVideo
//
//  Created by kmgao on 14-5-21.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "TokboxBridge.h"
#import "CallViewController.h"
#import "NSNotificationAdditions.h"


static NSString *const kApiKey = @"44725532";
// Replace with your generated session ID
static NSString *const kSessionId = @"1_MX40NDcyNTUzMn5-U3VuIEp1biAwMSAwOTozNjo1NSBQRFQgMjAxNH4wLjE4MzY1NzExflB-";
// Replace with your generated token
static NSString *const kToken = @"T1==cGFydG5lcl9pZD00NDcyNTUzMiZzZGtfdmVyc2lvbj10YnJ1YnktdGJyYi12MC45MS4yMDExLTAyLTE3JnNpZz0wNmEzNDQ5ZGNlNWYxNzc0N2ExMjgyMGQzNjdiMGQ2Njc2ZmUxNTIzOnJvbGU9bW9kZXJhdG9yJnNlc3Npb25faWQ9MV9NWDQwTkRjeU5UVXpNbjUtVTNWdUlFcDFiaUF3TVNBd09Ub3pOam8xTlNCUVJGUWdNakF4Tkg0d0xqRTRNelkxTnpFeGZsQi0mY3JlYXRlX3RpbWU9MTQwMTY0MDYyMyZub25jZT0wLjEyNzE5NjUyNjEzMjgzMTE3JmV4cGlyZV90aW1lPTE0MDQyMzI1ODcmY29ubmVjdGlvbl9kYXRhPQ==";
// Replace with your generated token (use the Dashboard or an OpenTok server-side library)

static bool subscribeToSelf = NO; // Change to NO to subscribe streams other than your own

@interface TokboxBridge()
{
    OTSession* _session;
    OTPublisher* _publisher;
    OTSubscriber* _subscriber;
}

@end


@implementation TokboxBridge

static TokboxBridge *g_instance = nil;
+(instancetype)shareTokbox
{
    @synchronized(self)
    {
        if(g_instance == nil)
        {
            g_instance = [[TokboxBridge alloc] init];
        }
        return g_instance;
    }
}
-(void)install
{
    _session = [[OTSession alloc]initWithApiKey:kApiKey sessionId:kSessionId delegate:self];
}

#pragma mark - OpenTok methods

- (void)doConnect:(NSString*)token
{
    [_session addObserver:self
               forKeyPath:@"connectionCount"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    OTError  *error = nil;
    NSString *conToken = kToken;
    
    [_session connectWithToken:conToken error:&error];
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kCallEventNotification object:[NSNumber numberWithInt:OTSessionConnectionStatusConnecting] userInfo:nil];

    if(error != nil)
        KFLog_Debug(YES,@"connectWithToken error = %@",error);
}

- (void)doDisconnect
{
   OTError  *error = nil;
   [_session disconnect:&error];
   if(error != nil)
        KFLog_Debug(YES,@"disconnect error = %@",error);
}

- (void)doPublish
{
    _publisher = [[OTPublisher alloc] initWithDelegate:self name:UIDevice.currentDevice.name];
    _publisher.publishAudio = YES;
    _publisher.publishVideo = YES;
    OTError  *error = nil;
    [_session publish:_publisher error:&error];
    
    if(error != nil)
        KFLog_Debug(YES,@"publish error = %@",error);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"connectionCount"]) {
        
    }
}

- (void)doUnpublish
{
    NSError  *error = nil;
    [_session unpublish:_publisher error:&error];
    if(error != nil)
    {
        NSLog(@"doUnpublish >>>= error = %@",error);
    }
}

- (void)doSubscriber
{
    [_subscriber subscribeToVideo];
}

- (void)doUnSubcriber
{
    
}


#pragma mark - OTSessionDelegate methods

- (void)sessionDidConnect:(OTSession*)session
{
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kCallEventNotification object:[NSNumber numberWithInt:OTSessionConnectionStatusConnected] userInfo:nil];
}

- (void)session:(OTSession*)session streamCreated:(OTStream*)stream
{
    
}

- (void)session:(OTSession*)session streamDestroyed:(OTStream*)stream
{
    
}


- (void)sessionDidDisconnect:(OTSession*)session
{
    
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error
{
 
}

- (void)session:(OTSession*)mySession didReceiveStream:(OTStream*)stream
{
    NSLog(@"session: didReceiveStream:");
    NSLog(@"- connection.connectionId: %@", stream.connection.connectionId);
    NSLog(@"- connection.creationTime: %@", stream.connection.creationTime);
    NSLog(@"- session.sessionId: %@", stream.session.sessionId);
    NSLog(@"- streamId: %@", stream.streamId);
    NSLog(@"- type %@", stream.type);
    NSLog(@"- creationTime %@", stream.creationTime);
    NSLog(@"- name %@", stream.name);
    NSLog(@"- hasAudio %@", (stream.hasAudio ? @"YES" : @"NO"));
    NSLog(@"- hasVideo %@", (stream.hasVideo ? @"YES" : @"NO"));
    
    if ( (subscribeToSelf && [stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ||
        (!subscribeToSelf && ![stream.connection.connectionId isEqualToString: _session.connection.connectionId])
        ) {
        if (!_subscriber) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            _subscriber.subscribeToAudio = YES;
            _subscriber.subscribeToVideo = YES;
        }
        NSLog(@"subscriber.session.sessionId: %@", _subscriber.session.sessionId);
        NSLog(@"- stream.streamId: %@", _subscriber.stream.streamId);
        NSLog(@"- subscribeToAudio %@", (_subscriber.subscribeToAudio ? @"YES" : @"NO"));
        NSLog(@"- subscribeToVideo %@", (_subscriber.subscribeToVideo ? @"YES" : @"NO"));
    }
}

- (void)session:(OTSession*)session didDropStream:(OTStream*)stream
{  
    NSLog(@"session didDropStream (%@)", stream.streamId);
    if (!subscribeToSelf
        && _subscriber
        && [_subscriber.stream.streamId isEqualToString: stream.streamId]) {
        _subscriber = nil;
        [self updateSubscriber];
    }
}

- (void)updateSubscriber
{
    for (NSString* streamId in _session.streams) {
        OTStream* stream = [_session.streams valueForKey:streamId];
        if (stream.connection.connectionId != _session.connection.connectionId) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            break;
        }
    }
}

#pragma mark - OTPublisherDelegate methods

- (void)publisher:(OTPublisher*)publisher didFailWithError:(OTError*) error
{
    NSLog(@"publisher: %@ didFailWithError:", publisher);
    NSLog(@"- error code: %d", error.code);
    NSLog(@"- description: %@", error.localizedDescription);
}

- (void)publisher:(OTPublisherKit*)publisher streamCreated:(OTStream*)stream
{
    NSLog(@"publisherDidStartStreaming: %@", publisher);
    NSLog(@"- publisher.session: %@", publisher.session.sessionId);
    NSLog(@"- publisher.name: %@", publisher.name);
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:kCallEventNotification object:[NSNumber numberWithInt:OTSessionConnectionStatusConnected] userInfo:nil];

}
- (void)publisher:(OTPublisherKit*)publisher streamDestroyed:(OTStream*)stream
{
    NSLog(@"publisherDidStopStreaming:%@", publisher);
}

#pragma mark - OTSubscriberDelegate methods

- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
  
}

- (void)subscriberVideoDataReceived:(OTSubscriber*)subscriber {
    NSLog(@"subscriberVideoDataReceived (%@)", subscriber.stream.streamId);
}

- (void)subscriber:(OTSubscriber *)subscriber didFailWithError:(OTError *)error
{
    NSLog(@"subscriber: %@ didFailWithError: ", subscriber.stream.streamId);
    NSLog(@"- code: %d", error.code);
    NSLog(@"- description: %@", error.localizedDescription);
}



@end
