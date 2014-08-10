//
//  UIPopView.h
//  UIVoice
//
//  Created by lab on 13-1-29.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPopView : UIView
{
    CGFloat callTipViewHeight;
    CGFloat callTipViewWidth;
    UILabel     *callTip;
    UITapGestureRecognizer *tap;
    
    CGFloat mDuration;
    BOOL bReverse;
}

@property (nonatomic, assign)NSString *tip;
@property (nonatomic,assign)CGFloat duration;

- (void)show;
- (void)setFont:(UIFont*)font;
- (void)reversedPopView;

+ (void)emptyPopViewQueue;
- (void)addToPopQueue;
@end
