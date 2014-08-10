//
//  PublishTBCell.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "PublisherTBCell.h"
#import "PublisherEntity.h"
#import "AppDelegate.h"
#import "MKNetworkEngine.h"
#import "UIImageView+MKNetworkKitAdditions.h"

#define kDefaultImgBgH   178

@interface PublisherTBCell()
{
    
}

@end

@implementation PublisherTBCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

-(void)buildUI
{
    if(self.entity)
    {
        if(self.entity.imgURL)
        {//去网上下载图片
            UIImageView *backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kDefaultImgBgH)];
            
            if ([self.entity.imgURL hasPrefix:@"http:"] || [self.entity.imgURL hasPrefix:@"https:"])
            {
                NSURL  *imgURL = [[NSURL alloc] initWithString:self.entity.imgURL];
                [UIImageView setDefaultEngine:[AppDelegate shareAppInstace].httpEngine];
                [backGround setImageFromURL:imgURL];
            }
            else
            {
                UIImage *imgHeader = [UIImage imageNamed:self.entity.imgURL];
                backGround.image = imgHeader;
            }
            
            backGround.userInteractionEnabled = YES;
            [self.contentView addSubview:backGround];
        }
        else
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kDefaultImgBgH)];
            imgView.image = [UIImage imageNamed:@"main_back_cell.png"];
            imgView.userInteractionEnabled = YES;
            [self.contentView addSubview:imgView];
        }
        
        UIImage *alphaBg = [UIImage imageNamed:@"alpha_bar_rectange.png"];
        UIImageView *alphaBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kScale2x(78))];
        alphaBgView.image = alphaBg;
        [self.contentView addSubview:alphaBgView];
        
        UILabel  *title = [[UILabel alloc] initWithFrame:CGRectMake(kScale2x(25), kScale2x(21), self.frame.size.width - 100-12, kScale2x(38))];
        title.text = self.entity.title;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = kWhiteColor;
        title.font = kDefaultFont;
        [self.contentView addSubview:title];
        
        if(self.entity.ratingCount > 0)
        {
            UIImage *rateImg = [UIImage imageNamed:@"music_button.png"];
            
            UIButton *rateImgBtn= [[UIButton alloc] initWithFrame:CGRectMake(kScale2x(498), kScale2x(13), kScale2x(52), kScale2x(52))];
            [rateImgBtn setBackgroundImage:rateImg forState:UIControlStateNormal];
            
            [self.contentView addSubview:rateImgBtn];
        }
        
        UILabel  *distance = [[UILabel alloc] initWithFrame:CGRectMake(kScale2x(578), kScale2x(21), self.frame.size.width - kScale2x(568), kScale2x(36))];
        distance.text = self.entity.playTime;
        distance.backgroundColor = [UIColor clearColor];
        distance.textAlignment = NSTextAlignmentLeft;
        distance.textColor = kWhiteColor;
        distance.font = kDefaultFont;
        [self.contentView addSubview:distance];
        //heart
        if(self.entity.isHeart)
        {
            UIImage *heartImg = [UIImage imageNamed:@"Heart_full.png"];
            
            UIButton *heartImgBtn= [[UIButton alloc] initWithFrame:CGRectMake(kScale2x(20), kScale2x(274), kScale2x(61), kScale2x(50))];
            [heartImgBtn setBackgroundImage:heartImg forState:UIControlStateNormal];
            
            [self.contentView addSubview:heartImgBtn];
        }
        
        //watch
        if(self.entity.isWatch)
        {
            UIImage *watchImg = [UIImage imageNamed:@"watch_button.png"];
            
            UIButton *watchImgBtn= [[UIButton alloc] initWithFrame:CGRectMake(kScale2x(483), kScale2x(274), kScale2x(137), kScale2x(50))];
            [watchImgBtn setBackgroundImage:watchImg forState:UIControlStateNormal];
            watchImgBtn.showsTouchWhenHighlighted = YES;
            [self.contentView addSubview:watchImgBtn];
        }
        self.contentView.exclusiveTouch = YES;
    }
}


-(CGFloat)getCellContentH
{
    return kDefaultImgBgH;
}


@end
