
#import "NetWorkEnv.h"

@interface NetWorkEnv()
{
    NetworkStatus _curNetStatus;
}

@property (nonatomic) Reachability *hostReachability;

@end


@implementation NetWorkEnv

@synthesize networkIsOK = _netWorkIsOK;
@synthesize isWIFI = _isWIFI;
@synthesize hostReachability = _hostReachability;
@synthesize curNetStatus = _curNetStatus;

static NetWorkEnv *_install = nil;
+(instancetype)shareInstall
{
    @synchronized(self)
    {
        if(nil == _install){
            _install = [[NetWorkEnv alloc] init];
        }
        return _install;
    }
}

-(id)init
{
    self = [super init];
    if(self){//reachabilityWithHostname

    }
    return self;
}

-(void)startNetMonitor
{
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChange:) name:kReachabilityChangedNotification object:nil];
    
    _curNetStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if(_curNetStatus != NotReachable)
        self.networkIsOK = YES;
    else
        self.networkIsOK = NO;
 
     _hostReachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self.hostReachability startNotifier];
}

-(void)reachabilityChange:(NSNotification*)notity{
    
    Reachability* reachability = [notity object];
    if(![reachability isKindOfClass:[Reachability class]]){
        return ;
    }
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    _curNetStatus = netStatus;
    
    BOOL connectionRequired = [reachability connectionRequired];
    
    if(reachability == self.hostReachability)
        NSLog(@"===当前使用的网络对象[%@] = self.hostReachability[%@]",reachability,self.hostReachability);
    
    NSString *info = nil;
    if(netStatus == NotReachable)
        info = @"不可用";
    if(netStatus == ReachableViaWiFi)
        info = @"WIFI";
    if(netStatus == ReachableViaWWAN)
        info = @"移动蜂窝";
    NSLog(@"<<<<<<<<<当前网络状态改变为:[%@]是否要求连接:[%@]=======",info,(connectionRequired ? @"yes" : @"no"));
    
    if(netStatus != NotReachable)
    {
        self.networkIsOK = YES;
        self.isWIFI = (netStatus == ReachableViaWiFi);
    }
    else
    {
        netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        NSLog(@"11111111>>>当前网络状态改变为:[%d]================",netStatus);
        if(netStatus == NotReachable)
        {
            _curNetStatus = netStatus;
            self.networkIsOK = NO;
            self.isWIFI = NO;
        }
        else
        {
            _curNetStatus = netStatus;
            self.networkIsOK = YES;
            self.isWIFI = (netStatus == ReachableViaWiFi);
        }
    }
 
}

//当前网络
- (NetworkStatus)currentNetStatus
{
    return _curNetStatus;
}


@end
