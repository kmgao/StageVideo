
#import <UIKit/UIKit.h>
#import <OpenTok/Opentok.h>

@interface VideoViewController : UIViewController <OTSessionDelegate, OTSubscriberDelegate, OTPublisherDelegate>
- (void)doConnect;
- (void)doDisconnect;
- (void)doPublish;
- (void)doUnpublish;
- (void)createUI;
- (void)setStatusLabel;
@end
