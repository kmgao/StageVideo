//
//  BNaviBarVIew.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BNaviBarVIew.h"

#define KSCREEN_WIDH    320 
#define KNAVIBAR_TITLE_FONT    18
#define KNAVIBAR_FONT_H    30

@implementation BNaviBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setbackgrounImage:(NSString*)imgName{
    if(imgName){
        UIImage *imgBg = [UIImage imageNamed:imgName];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDH, kNaviBarHeight)];
        imgView.image = imgBg;
        [self addSubview:imgView];
    }
}

-(void) setNaviTitle:(NSString*)title titleColde:(UIColor*)color imgTitle:(NSString*)imgName{
    if(title){
        UILabel  *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+KNAVIBAR_FONT_H/2, KSCREEN_WIDH, KNAVIBAR_FONT_H)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.textColor = color;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:KNAVIBAR_TITLE_FONT];
        [self addSubview:titleLabel];
    }
    
    if(imgName){
        UIImage *img = [UIImage imageNamed:imgName];
        UIImageView *imgView = [[UIImageView alloc ]initWithImage:img];
        CGFloat xx = (self.frame.size.width - img.size.width)/2;
        CGFloat yy = 20+img.size.height/2;
        imgView.frame = CGRectMake(xx, yy, img.size.width, img.size.height);
        [self addSubview:imgView];
    }
    
}

-(UIButton*) addNaviButton:(NSString*)normalBg lightBg:(NSString*)lightBg andImage:(NSString*)image andTag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if(normalBg){
        [button setBackgroundImage:[UIImage imageNamed:normalBg] forState:UIControlStateNormal];
    }
    if(lightBg){
        [button setBackgroundImage:[UIImage imageNamed:lightBg] forState:UIControlStateHighlighted];
    }
    if(image){
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(clickButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [self addSubview:button];
    return button;
}

-(void)clickButtonEvent:(id)sender{
    UIButton *but = (UIButton*)sender;
    if(but){
        if(self.delegate && [self.delegate respondsToSelector:@selector(clickNaviButton:andIndex:)]){
            [self.delegate clickNaviButton:self andIndex:but.tag];
        }
    }
}

-(CGFloat)naviBarH{
    return  kNaviBarHeight;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
