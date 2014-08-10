//
//  common.h
//  ITouchUI
//
//  Created by candy on 14-5-3.
//  Copyright (c) 2014年 candy. All rights reserved.
//

#import "UIDevice+screenType.h"

#define isPhone568 ([UIDevice currentScreenType] == UIDeviceScreenType_iPhoneRetina4Inch)
#define iosVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define isIOS6     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define isIOS7     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define ABAuthStatus  (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)

#define IPHONE_SCREEN_WIDTH 320
#define IPHONE_SCREEN_HEIGHT (isPhone568 ? 568 : 480)
#define IPHONE_STATUS_BAR_HEIGHT 20                     //状态栏高度

#define NAVIGATION_BAR_HEGITH      (44+20)
#define TAB_NAVIGATION_BAR_HEGITH  (49)

#define kIOS7OffX                   (-15)


#define kSmallFontSize               14
#define kNormalFontSize              16
#define kBigFontSize                 20

#define kRGB2HexColor(r,g,b)  ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

#define kDefaultBlueColor   kRGB2HexColor(0x5f,0x88,0xfe)
#define kDefaultGrayColor   kRGB2HexColor(0xaa,0xaa,0xaa)
#define kWhiteColor         kRGB2HexColor(0xFF,0xFF,0xFF)
#define kBlackColor         kRGB2HexColor(0x0,0x0,0x0)
#define kScale2x(x)         (x)/2

#define kDefaultFont        [UIFont systemFontOfSize:kNormalFontSize]
#define kSmallFont         [UIFont systemFontOfSize:kSmallFontSize]
#define kBigFont           [UIFont systemFontOfSize:kBigFontSize]


#define kapplicationDidEnterBackground   @"applicationDidEnterBackground"
#define kapplicationWillEnterForground   @"applicationWillEnterForground"

#define kCallEventNotification   @"kCallEventNotification"




#define kCellHeight               40.0f
#define kDefaultNoDataCellNum     10


#define kSaveHeaderImageName      @"%@/headImage.dat"









