/*
 Copyright (c) 2011, Tony Million.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE. 
 */

#import "Reachability.h"

#if defined(KFLOG_OPEN) && defined(kDEBUG)
#define DEBUG_LOG_INFO   KFLog_Normal
#else
#define DEBUG_LOG_INFO
#endif

NSString *const kReachabilityChangedNotification = @"kReachabilityChangedNotification";

@interface Reachability ()
{
    BOOL _alwaysReturnLocalWiFiStatus; //default is NO
}
@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;


#if NEEDS_DISPATCH_RETAIN_RELEASE
@property (nonatomic, assign) dispatch_queue_t          reachabilitySerialQueue;
#else
@property (nonatomic, strong) dispatch_queue_t          reachabilitySerialQueue;
#endif


@property (nonatomic, strong) id reachabilityObject;

-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags;
-(BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags;

@end

static NSString *reachabilityFlags(SCNetworkReachabilityFlags flags) 
{
    return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c",
#if	TARGET_OS_IPHONE
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
#else
            'X',
#endif
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
}

//Start listening for reachability notifications on the current run loop
static void TMReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) 
{
#pragma unused (target)
#if __has_feature(objc_arc)
    Reachability *reachability = ((__bridge Reachability*)info);
#else
    Reachability *reachability = ((Reachability*)info);
#endif
    
    char *flagValue = NULL;
    if(flags == kSCNetworkReachabilityFlagsTransientConnection)  flagValue ="FlagsTransientConnection";
    if(flags == kSCNetworkReachabilityFlagsReachable)  flagValue ="FlagsReachable";
    if(flags == kSCNetworkReachabilityFlagsConnectionOnTraffic)  flagValue ="FlagsConnectionOnTraffic";
    if(flags == kSCNetworkReachabilityFlagsInterventionRequired)  flagValue ="FlagsInterventionRequired";
    if(flags == kSCNetworkReachabilityFlagsConnectionOnDemand)  flagValue ="FlagsConnectionOnDemand";
    if(flags == kSCNetworkReachabilityFlagsIsLocalAddress)  flagValue ="FlagsIsLocalAddress";
    if(flags == kSCNetworkReachabilityFlagsIsDirect)  flagValue ="FlagsIsDirect";
    if(flags == kSCNetworkReachabilityFlagsIsWWAN)  flagValue ="FlagsIsWWAN";
    if(flags == kSCNetworkReachabilityFlagsConnectionAutomatic)  flagValue ="FlagsConnectionAutomatic";
    
    DEBUG_LOG_INFO(YES,@"网络监听开始回调[网络标记:%s,info=%@,target=%p]",flagValue,reachability,target);
    DEBUG_LOG_INFO(YES,@"=======当前网络变化标记:%@",reachabilityFlags(flags));
    
    // we probably dont need an autoreleasepool here as GCD docs state each queue has its own autorelease pool
    // but what the heck eh?
    @autoreleasepool 
    {
        [reachability reachabilityChanged:flags];
    }
}


@implementation Reachability

@synthesize reachabilityRef;
@synthesize reachabilitySerialQueue;

@synthesize reachableOnWWAN;

@synthesize reachableBlock;
@synthesize unreachableBlock;

@synthesize reachabilityObject;

#pragma mark - class constructor methods
+(Reachability*)reachabilityWithHostname:(NSString*)hostname
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    DEBUG_LOG_INFO(YES,@">>>>使用[域名方式]初始化网络监听对象[ReachabilityRef=%p]",ref);
    if (ref) 
    {
        Reachability *reachability = [[self alloc] initWithReachabilityRef:ref];
        if(reachability){
            reachability->_alwaysReturnLocalWiFiStatus = NO;
        }
#if __has_feature(objc_arc)
        return reachability;
#else
        return [reachability autorelease];
#endif

    }
    
    return nil;
}

+(Reachability *)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress 
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    DEBUG_LOG_INFO(YES,@">>>>使用[SockAddr_in]初始化网络监听对象[ReachabilityRef=%p]",ref);
    if (ref) 
    {
        Reachability *reachability = [[self alloc] initWithReachabilityRef:ref];
        if(reachability){
            reachability->_alwaysReturnLocalWiFiStatus = NO;
        }
#if __has_feature(objc_arc)
        return reachability;
#else
        return [reachability autorelease];
#endif
    }
    
    return nil;
}

+(Reachability *)reachabilityForInternetConnection 
{   
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    DEBUG_LOG_INFO(YES,@">>>>使用[InternetConnection]初始化网络监听对象<<<<<<<");
    return [self reachabilityWithAddress:&zeroAddress];
}

+(Reachability*)reachabilityForLocalWiFi
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len            = sizeof(localWifiAddress);
    localWifiAddress.sin_family         = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr    = htonl(IN_LINKLOCALNETNUM);
    
    Reachability *reachability = [self reachabilityWithAddress:&localWifiAddress];
    if(reachability){
        reachability->_alwaysReturnLocalWiFiStatus = NO;
    }
    DEBUG_LOG_INFO(YES,@">>>使用[WIFI方式]初始化网络监听对象[reachability=%@]",reachability);
    return reachability;
}


// initialization methods

-(Reachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref 
{
    self = [super init];
    if (self != nil) 
    {
        self.reachableOnWWAN = YES;
        self.reachabilityRef = ref;
    }
    
    return self;    
}

-(void)dealloc
{
    [self stopNotifier];

    if(self.reachabilityRef)
    {
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }

	self.reachableBlock		= nil;
	self.unreachableBlock	= nil;
    
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif

    
}

#pragma mark - notifier methods

// Notifier 
// NOTE: this uses GCD to trigger the blocks - they *WILL NOT* be called on THE MAIN THREAD
// - In other words DO NOT DO ANY UI UPDATES IN THE BLOCKS.
//   INSTEAD USE dispatch_async(dispatch_get_main_queue(), ^{UISTUFF}) (or dispatch_sync if you want)

-(BOOL)startNotifier
{
    SCNetworkReachabilityContext    context = { 0, NULL, NULL, NULL, NULL };
    
    // this should do a retain on ourself, so as long as we're in notifier mode we shouldn't disappear out from under ourselves
    // woah
    self.reachabilityObject = self;
    
    DEBUG_LOG_INFO(YES,@"Start network monitor........");

    // first we need to create a serial queue
    // we allocate this once for the lifetime of the notifier
    self.reachabilitySerialQueue = dispatch_queue_create("com.tonymillion.reachability", NULL);
    if(!self.reachabilitySerialQueue)
    {
        return NO;
    }
    
#if __has_feature(objc_arc)
    context.info = (__bridge void *)self;
#else
    context.info = (void *)self;
#endif
    
    if (!SCNetworkReachabilitySetCallback(self.reachabilityRef, TMReachabilityCallback, &context)) 
    {
        DEBUG_LOG_INFO(YES,@"SCNetworkReachabilitySetCallback() failed: %s", SCErrorString(SCError()));
        //clear out the dispatch queue
        if(self.reachabilitySerialQueue)
        {
#if NEEDS_DISPATCH_RETAIN_RELEASE
            dispatch_release(self.reachabilitySerialQueue);
#endif
            self.reachabilitySerialQueue = nil;
        }
        
        self.reachabilityObject = nil;

        return NO;
    }
    
    // set it as our reachability queue which will retain the queue
    if(!SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilitySerialQueue))
    {
        DEBUG_LOG_INFO(YES,@"SCNetworkReachabilitySetDispatchQueue() failed: %s", SCErrorString(SCError()));

        //UH OH - FAILURE!
        
        // first stop any callbacks!
        SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
        
        // then clear out the dispatch queue
        if(self.reachabilitySerialQueue)
        {
#if NEEDS_DISPATCH_RETAIN_RELEASE
            dispatch_release(self.reachabilitySerialQueue);
#endif
            self.reachabilitySerialQueue = nil;
        }
        
        self.reachabilityObject = nil;
        
        return NO;
    }
    
    return YES;
}

-(void)stopNotifier
{
    // first stop any callbacks!
    SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
    
    // unregister target from the GCD serial dispatch queue
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);
    
    if(self.reachabilitySerialQueue)
    {
#if NEEDS_DISPATCH_RETAIN_RELEASE
        dispatch_release(self.reachabilitySerialQueue);
#endif
        self.reachabilitySerialQueue = nil;
    }
    
    DEBUG_LOG_INFO(YES,@"================Stop network monitor........");
    
    self.reachabilityObject = nil;
}

#pragma mark - reachability tests

// this is for the case where you flick the airplane mode
// you end up getting something like this:
//Reachability: WR ct-----
//Reachability: -- -------
//Reachability: WR ct-----
//Reachability: -- -------
// we treat this as 4 UNREACHABLE triggers - really apple should do better than this

#define testcase (kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)

-(BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags
{
    BOOL connectionUP = YES;
    
    if(!(flags & kSCNetworkReachabilityFlagsReachable))
        connectionUP = NO;
    
    if( (flags & testcase) == testcase )
        connectionUP = NO;
    
#if	TARGET_OS_IPHONE
    if(flags & kSCNetworkReachabilityFlagsIsWWAN)
    {
        DEBUG_LOG_INFO(YES,@"检测系统网络变化-当前系统网络是蜂窝网络[self.reachableOnWWAN = %s]", (self.reachableOnWWAN ? "YES" : "NO"));
        // we're on 3G
        if(!self.reachableOnWWAN)
        {
            // we dont want to connect when on 3G
            connectionUP = NO;
        }
    }
#endif
    
    DEBUG_LOG_INFO(YES,@"检测系统网络变化-是否可到达[connectionUP = %s]", (connectionUP?"YES":"NO"));
    
    return connectionUP;
}

-(BOOL)isReachable
{
    SCNetworkReachabilityFlags flags;  
    
    if(!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        return NO;
    
    return [self isReachableWithFlags:flags];
}

-(BOOL)isReachableViaWWAN 
{
#if	TARGET_OS_IPHONE

    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) 
    {
        // check we're REACHABLE
        if(flags & kSCNetworkReachabilityFlagsReachable)
        {
            DEBUG_LOG_INFO(YES,@"检当前系统网络可到达,是否是蜂窝网络:%d",(flags & kSCNetworkReachabilityFlagsIsWWAN));
            // now, check we're on WWAN
            if(flags & kSCNetworkReachabilityFlagsIsWWAN)
            {
                return YES;
            }
        }
    }
#endif
    
    DEBUG_LOG_INFO(YES,@"检当前系统网络是蜂窝网络[SCNetworkReachabilityFlags = %d,reachabilityRef=%@]",flags,reachabilityRef);
    
    return NO;
}

-(BOOL)isReachableViaWiFi 
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) 
    {
        // check we're reachable
        if((flags & kSCNetworkReachabilityFlagsReachable))
        {
            DEBUG_LOG_INFO(YES,@"检当前系统网络可到达,是否是WiFi网络:%d",(flags & kSCNetworkReachabilityFlagsIsWWAN));
#if	TARGET_OS_IPHONE
            // check we're NOT on WWAN
            if((flags & kSCNetworkReachabilityFlagsIsWWAN))
            {
                return NO;
            }
#endif
            return YES;
        }
    }
    DEBUG_LOG_INFO(YES,@"检当前系统网络是WiFi网络[SCNetworkReachabilityFlags = %d,reachabilityRef=%@]",flags,reachabilityRef);
    return NO;
}


// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired
{
    return [self connectionRequired];
}

-(BOOL)connectionRequired
{
    SCNetworkReachabilityFlags flags;
	
	if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) 
    {
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}
    
    return NO;
}

// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand
{
	SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) 
    {
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & (kSCNetworkReachabilityFlagsConnectionOnTraffic | kSCNetworkReachabilityFlagsConnectionOnDemand)));
	}
	
	return NO;
}

// Is user intervention required?
-(BOOL)isInterventionRequired
{
    SCNetworkReachabilityFlags flags;
	
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) 
    {
		return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
				(flags & kSCNetworkReachabilityFlagsInterventionRequired));
	}
	
	return NO;
}


#pragma mark - reachability status stuff

-(NetworkStatus)currentReachabilityStatus
{
//    if([self isReachable])
//    {
//        if([self isReachableViaWiFi])
//            return ReachableViaWiFi;
//        
//#if	TARGET_OS_IPHONE
//        return ReachableViaWWAN;
//#endif
//    }
//    return NotReachable;
    
    /***苹果最新的API接口********************/
    NSAssert(self.reachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkReachabilityRef");
    
	NetworkStatus returnValue = NotReachable;
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
	{
		if (_alwaysReturnLocalWiFiStatus)
		{
			returnValue = [self localWiFiStatusForFlags:flags];
		}
		else
		{
			returnValue = [self networkStatusForFlags:flags];
		}
	}
    DEBUG_LOG_INFO(YES,@"当前系统网络状态{returnValue=%d[0,1,2];flags = %d; _alwaysReturnLocalWiFiStatus=%d;self.reachabilityRef=%p}",returnValue,flags,_alwaysReturnLocalWiFiStatus,self.reachabilityRef);
    
	return returnValue;
}

- (NetworkStatus)localWiFiStatusForFlags:(SCNetworkReachabilityFlags)flags
{
	NetworkStatus returnValue = NotReachable;
    
	if ((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
	{
		returnValue = ReachableViaWiFi;
	}
    
    DEBUG_LOG_INFO(YES,@"当前系统WIFI网络状态[flags=%d,returnValue=%d]{kNotReachable:0;kReachableViaWWAN:1;kReachableViaWiFi:2}",flags,returnValue);
    
	return returnValue;
}


- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    DEBUG_LOG_INFO(YES,@"<<<<<<<当前系统网络状态[flags=%d]------",flags);
    
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		// The target host is not reachable.
		return NotReachable;
	}
    
    NetworkStatus returnValue = NotReachable;
    
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		/*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
		returnValue = ReachableViaWiFi;
	}
    
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = ReachableViaWiFi;
        }
    }
    
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
		/*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
		returnValue = ReachableViaWWAN;
	}
    
     DEBUG_LOG_INFO(YES,@"=========当前系统网络状态[returnValue=%d]{0,1,2}>>>>>>>",returnValue);
    
	return returnValue;
}


-(SCNetworkReachabilityFlags)reachabilityFlags
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) 
    {
        return flags;
    }
    
    return 0;
}

-(NSString*)currentReachabilityString
{
	NetworkStatus temp = [self currentReachabilityStatus];
	
	if(temp == reachableOnWWAN)
	{
        // updated for the fact we have CDMA phones now!
		return NSLocalizedString(@"Cellular", @"");
	}
	if (temp == ReachableViaWiFi) 
	{
		return NSLocalizedString(@"WiFi", @"");
	}
	
	return NSLocalizedString(@"No Connection", @"");
}

-(NSString*)currentReachabilityFlags
{
    return reachabilityFlags([self reachabilityFlags]);
}

#pragma mark - callback function calls this method

-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags
{
    DEBUG_LOG_INFO(YES,@"网络变化-系统回调[NetworkReachabilityFlags = %d]", flags);
    if([self isReachableWithFlags:flags])
    {
        if(self.reachableBlock)
        {
            self.reachableBlock(self);
        }
    }
    else
    {
        if(self.unreachableBlock)
        {
            self.unreachableBlock(self);
        }
    }
    // this makes sure the change notification happens on the MAIN THREAD
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification 
                                                            object:self];
    });
}

@end
