
#import <UIKit/UIKit.h>
#import "KKNavigationController.h"

@class BNavigationViewController;
//@class KKNavigationController;
@class MKNetworkEngine;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                     *window;
//@property (strong, nonatomic) BNavigationViewController    *appNavi;
@property (strong, nonatomic) KKNavigationController    *appNavi;

@property (strong,nonatomic)  MKNetworkEngine           *httpEngine;

+(instancetype)shareAppInstace;



@end
