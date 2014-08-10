 

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetWorkEnv : NSObject

@property(nonatomic) BOOL networkIsOK;
@property(nonatomic) BOOL isWIFI;
@property(nonatomic) NetworkStatus curNetStatus;

+(instancetype)shareInstall;
-(void)startNetMonitor;
//当前网络
- (NetworkStatus)currentNetStatus;

@end
