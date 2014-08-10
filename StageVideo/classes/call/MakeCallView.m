//
//  MakeCallView.m
//  StageVideo
//
//  Created by kmgao on 14-6-5.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "MakeCallView.h"
#import "CallViewController.h"

#define kUserHeaderSize   CGSizeMake(147,147)

@interface MakeCallView()
{
    UIImageView  *headerView;
    UIImageView  *bgView;
    UILabel      *desLabel;
}
@end

@implementation MakeCallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage  *bgImage = [UIImage imageNamed:@"CallingBg.png"];
        bgView = [[UIImageView alloc] initWithImage:bgImage];
        bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:bgView];

        UIImage  *alphaBgImage = [UIImage imageNamed:@"CallingBgAlpha.png"];
        UIImageView *alphaBgView = [[UIImageView alloc] initWithImage:alphaBgImage];
        alphaBgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:alphaBgView];

        
        UIButton  *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.showsTouchWhenHighlighted = YES;
        closeBtn.frame = CGRectMake(kScale2x(571), 20, 22, 22);
        UIImage  *btnImage = [UIImage imageNamed:@"CallingClose.png"];
        [closeBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        [closeBtn setBackgroundImage:btnImage forState:UIControlStateHighlighted];
        [closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        
        headerView = [[UIImageView alloc] initWithFrame:CGRectMake((IPHONE_SCREEN_WIDTH-kUserHeaderSize.width)/2, kScale2x(313), kUserHeaderSize.width, kUserHeaderSize.height)];
        headerView.image = [UIImage imageNamed:@"CallingUserHeader.png"];
        
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = kUserHeaderSize.width/2;
        
        [self addSubview:headerView];
        
        
        desLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, kScale2x(784), IPHONE_SCREEN_WIDTH-16, kScale2x(400))];
        desLabel.backgroundColor = [UIColor clearColor];
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.textColor = [UIColor grayColor];
        desLabel.numberOfLines = 100;
        desLabel.lineBreakMode = NSLineBreakByWordWrapping;
        desLabel.text = @"adasdasdasdsdasdasdsssadsdfafqrewqwerqwreqwreqwrewqreqrewqrdafdsafdsafdsafdasfdaafafdsafdsafdasdasdsssadsdfafqrewqwerqwreqwreqwrewqreqrewqrdafdsafdsafdsafdasfdaafafdsafdsafdasdasdsssadsdfafqrewqwerqwreqwreqwrewqreqrewqrdafdsafdsafdsafdasfdaafafdsafdsafssadsdfafqrewqwerqwreqwreqwrewqreqrewqrdafdsafdsafdsafdasfdaafafdsafdsaf";
        
        [self addSubview:desLabel];
        
    }
    return self;
}

-(void)closeClick:(id)sender
{
    [[CallViewController shareInstance] hangUpCall:0];
}

-(void)initialCallUI
{
    if(self.description)
    {
        desLabel.text = self.description;
    }
    if(self.header)
    {
        headerView.image = self.header;
    }
}


@end
