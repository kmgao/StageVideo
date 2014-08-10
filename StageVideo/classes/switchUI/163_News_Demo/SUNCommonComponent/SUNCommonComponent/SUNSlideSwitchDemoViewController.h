//
//  SUNSlideSwitchDemoViewController.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "SUNListViewController.h"
#import "SUNViewController.h"

@interface SUNSlideSwitchDemoViewController : UIViewController<SUNSlideSwitchViewDelegate>
{
  
}

@property (nonatomic, strong) SUNSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) SUNListViewController *vc1;
@property (nonatomic, strong) SUNListViewController *vc2;
@property (nonatomic, strong) SUNListViewController *vc3;
@property (nonatomic, strong) SUNListViewController *vc4;
@property (nonatomic, strong) SUNListViewController *vc5;
@property (nonatomic, strong) SUNListViewController *vc6;

@end
