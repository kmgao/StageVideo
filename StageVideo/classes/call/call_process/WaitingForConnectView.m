#import "WaitingForConnectView.h"
#import "WaitForServiceCallbackView.h"

#define kYOffset 20

@implementation WaitingForConnectView
@synthesize telNumber = mTelNumber;
@synthesize remotionPushDelegate = mRemotionPushDelegate;
- (id)init
{
    if(self = [super init])
    {
        self.backGroundImage = [UIImage imageNamed:@"Default.png"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissForOverTime)
                                                     name: K_STOP_WAITING_NOCALLINCOME object:nil];
        
        CGRect frame = _idicatorView.frame;
        
        frame.origin.y += kYOffset;
        _idicatorView.frame = frame;
    }
    return self;
}

- (void)showAnimatTip
{
    [self showAnimatTip:NSLocalizedString(@"findRout", nil)];
    
    CGRect rect = _animateLabel.frame;
    rect.origin.y += kYOffset;
}

- (void)showOverTimeTip
{
    [self showStaticTip:NSLocalizedString(@"heHungUp", nil)];
}

- (void)unshow
{
    [super unshow];
    if([mRemotionPushDelegate respondsToSelector:@selector(finishRemotionPush)])
    {
        [mRemotionPushDelegate finishRemotionPush];
    }
}

- (void)cancelAllAsynSelector
{
    [super cancelAllAsynSelector];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_STOP_WAITING_NOCALLINCOME object:nil];
}

- (void)dismissForCallBack
{
    [super dismissForCallBack];
}

- (void)dismissForOverTime
{
    [self cancelAllAsynSelector];
    NSString *tel = [NSString stringWithFormat:@"%@", mTelNumber];
    dispatch_async(dispatch_get_current_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:K_MISS_APUSH_CALL object:tel];
    });
    
    [super dismissForOverTime];
}

- (void)dealloc
{
    [super dealloc];
}
@end
