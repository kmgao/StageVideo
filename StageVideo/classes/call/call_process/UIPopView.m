//
//  UIPopView.m
//  UIVoice
//
//  Created by lab on 13-1-29.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import "UIPopView.h"

@implementation UIPopView
@synthesize tip;
@synthesize duration = mDuration;

- (void)dealloc
{
    [self removeAllGesture];
    [super dealloc];
}

- (void)removeAllGesture
{
    for(UIGestureRecognizer *gesture in [self gestureRecognizers])
    {
        [self removeGestureRecognizer:gesture];
    }
}

- (id)init
{
    if(self = [super init])
    {
//        CGRect wndRect = [[UIApplication sharedApplication].keyWindow bounds];
        CGRect wndRect = [AppDelegate sharedDelegate].window.bounds;
        UIImage *callTipImage = [UIImage imageNamed:@"dial_whitetips.png"];
        UIImageView *callTipImageView = [[UIImageView alloc] initWithImage:callTipImage];
        CGSize callTipSize = callTipImage.size;
        callTipViewHeight = callTipSize.height;
        callTipViewWidth = callTipSize.width;
        
        CGRect callTipViewRect = CGRectMake((wndRect.size.width-callTipViewWidth)*0.5,
                                            (wndRect.size.height-callTipViewHeight)*0.5, callTipViewWidth, 1);
        self.frame = callTipViewRect;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self addSubview:callTipImageView];
        [callTipImageView release];
        
        CGFloat gap = 2.0;
        callTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 6 + gap, callTipImage.size.width - 10, callTipImage.size.height - 6 - gap*2)];
        callTip.textAlignment = UITextAlignmentCenter;
        callTip.numberOfLines = 2;
        callTip.textColor = [UIColor blackColor];
        callTip.font = [UIFont systemFontOfSize:14.0];
        callTip.backgroundColor = [UIColor clearColor];
        [callTipImageView addSubview:callTip];
        [callTip release];
        
        mDuration = 3.0;
    }
    return self;
}

- (void)removeFromKeyWindow
{
    if(tap)
    {
        [self removeGestureRecognizer:tap];
        tap = nil;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hide
{
    [self fadePopView:nil];
}

- (void)fadePopView:(UITapGestureRecognizer*)tap
{
    [self removeFromKeyWindow];
}

- (void)setTip:(NSString *)_tip
{
    callTip.text = _tip;
}

- (void)show
{
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[AppDelegate sharedDelegate].window addSubview:self];
    CGRect frame = self.frame;
    CGPoint pt = frame.origin;
    pt.x -= (callTipViewWidth - frame.size.width)*0.5;
    frame = CGRectMake(pt.x, pt.y, callTipViewWidth, callTipViewHeight);
    CGFloat dur = 0.5;
    [UIView animateWithDuration:dur animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadePopView:)];
        [self addGestureRecognizer:tap];
        [tap release];
        [self performSelector:@selector(removeFromKeyWindow) withObject:nil afterDelay:mDuration];
    }];
}

- (void)reversedPopView;
{
    self.transform = CGAffineTransformMakeRotation(M_PI);
    callTip.transform = CGAffineTransformMakeRotation(M_PI);
    bReverse = YES;
}

- (void)setFont:(UIFont*)font
{
    callTip.font = font;
}

static NSMutableArray *popViewArray;
+ (void)emptyPopViewQueue
{
    @synchronized(popViewArray)
    {
        if(!popViewArray)
        {
            popViewArray = [[NSMutableArray alloc] init];
        }
    }
    for(UIPopView *popView in popViewArray)
    {
        [popView hide];
    }
    [popViewArray removeAllObjects];
}

- (void)addToPopQueue
{
    @synchronized(popViewArray)
    {
        if(!popViewArray)
        {
            popViewArray = [[NSMutableArray alloc] init];
        }
    }
    [popViewArray addObject:self];
}
@end
