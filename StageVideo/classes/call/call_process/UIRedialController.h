//
//  UIRedialController.h
//  UIVoice
//
//  Created by  on 12-9-8.
//  Copyright (c) 2012年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRedialController : UIViewController{
   	UIImageView	*portrait;
    UILabel     *name;
    UILabel     *status;
    
    //six buttons
    UIButton    *btnRedial;
    UIButton    *btnCancel;
    UIButton    *btnGSMCall;
    
    NSString    *username;
    NSString    *callStatus;
}

@property (nonatomic, retain) UIImageView *portrait;
@property (nonatomic, retain) UILabel     *name;
@property (nonatomic, retain) UILabel     *status;

@property (nonatomic, retain) UIButton    *btnRedial;
@property (nonatomic, retain) UIButton    *btnCancel;
@property (nonatomic, retain) UIButton    *btnGSMCall;

@property (nonatomic, retain) NSString    *username;
@property (nonatomic, retain) NSString    *callStatus;

@end
