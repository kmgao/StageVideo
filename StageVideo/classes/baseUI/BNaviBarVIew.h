//
//  BNaviBarVIew.h
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNaviBarHeight    64.0f

@protocol  BNaviBarVIewDelegate;

@interface BNaviBarView : UIView

@property(nonatomic,assign) id<BNaviBarVIewDelegate> delegate;
@property(nonatomic,assign) CGFloat                  naviBarH;

-(void) setbackgrounImage:(NSString*)imgName;
-(void) setNaviTitle:(NSString*)title titleColde:(UIColor*)color imgTitle:(NSString*)imgName;
-(UIButton*) addNaviButton:(NSString*)normalBg lightBg:(NSString*)lightBg andImage:(NSString*)image andTag:(int)tag;

@end


@protocol BNaviBarVIewDelegate <NSObject>

@optional

-(void)clickNaviButton:(BNaviBarView*)navView andIndex:(int)index;

@end
