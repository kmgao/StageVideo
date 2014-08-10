//
//  PublishDetailTableViewCell.m
//  StageVideo
//
//  Created by kmgao on 14-5-26.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "PubDetailHeaderView.h"
#import "PublisherEntity.h"
#import "UIImageView+MKNetworkKitAdditions.h"

#define   kPublisherDescritionLines     6

#define   kPublisherHeaderSize  CGSizeMake(48,48)

#define   kHeaderHeight  kScale2x(140)
#define   kBodyHeight    kScale2x(480)

#define   kDecDefaultHeight    kScale2x(363)

#define   kVerGapH          kScale2x(8)

@implementation PubDetailHeaderView


-(UIView*)MakeHeader:(PublisherEntity*)pubEntity
{
    UIView  *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, kHeaderHeight)];
    header.backgroundColor = [UIColor clearColor];
    
    CGFloat xx = kScale2x(20),yy = kScale2x(22);
    
    if(pubEntity.imgURL)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, kPublisherHeaderSize.width, kPublisherHeaderSize.height)];
        
        if ([pubEntity.imgURL hasPrefix:@"http:"] || [pubEntity.imgURL hasPrefix:@"https:"])
        {
            NSURL  *imgURL = [[NSURL alloc] initWithString:pubEntity.imgURL];
            [UIImageView setDefaultEngine:[AppDelegate shareAppInstace].httpEngine];
            [imgView setImageFromURL:imgURL];
        }
        else
        {
            UIImage *imgHeader = [UIImage imageNamed:pubEntity.imgURL];
            imgView.image = imgHeader;
        }
        
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kPublisherHeaderSize.width/2;
        
        [header addSubview:imgView];
    }
    
    if(pubEntity.puberName)
    {
        xx = kScale2x(132);
        yy = kScale2x(27);
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, kScale2x(200), kScale2x(43))];
        name.text = pubEntity.puberName;
        name.backgroundColor = [UIColor clearColor];
        name.textColor = kBlackColor;
        name.font = [UIFont boldSystemFontOfSize:kNormalFontSize];
        name.textAlignment = NSTextAlignmentLeft;
        [header addSubview:name];
        
        xx += [pubEntity.puberName sizeWithFont:name.font].width;
    }
    
    if(pubEntity.country)
    {
        xx += 4;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, kScale2x(40), kScale2x(40))];
        if ([pubEntity.country hasPrefix:@"http:"] || [pubEntity.country hasPrefix:@"https:"])
        {
            NSURL  *imgURL = [[NSURL alloc] initWithString:pubEntity.country];
            [UIImageView setDefaultEngine:[AppDelegate shareAppInstace].httpEngine];
            [imgView setImageFromURL:imgURL];
        }
        else
        {
            UIImage *imgHeader = [UtileTool getConuntryIconWithName:pubEntity.country];
            imgView.image = imgHeader;
        }
        [header addSubview:imgView];
    }
    
    xx = kScale2x(132);
    yy = kScale2x(72);
    

    for(int i =0 ; i < 5;i++)
    {
        UIImage  *comImg = nil;
        if(i < pubEntity.ratingCount)
        {
            comImg = [UIImage imageNamed:@"smileys.png"];
        }
        else
        {
            comImg = [UIImage imageNamed:@"Smiley_grey.png"];
        }
        
        UIImageView *comImgView = [[UIImageView alloc] initWithImage:comImg];
        comImgView.frame = CGRectMake(xx, yy, comImg.size.width, comImg.size.height);
        xx += comImg.size.width + 2;
        
        [header addSubview:comImgView];
    }
    
    xx += 4;
    
    UILabel *people = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, kScale2x(200), kScale2x(39))];
    people.text = @"by 39 people";
    people.backgroundColor = [UIColor clearColor];
    people.textColor = kBlackColor;
    people.font = kDefaultFont;
    people.textAlignment = NSTextAlignmentLeft;
    
    [header addSubview:people];
    
    //commont button
    UIButton   *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comBtn.tag = E_Comment_TxtMSG;
    [comBtn setBackgroundImage:[UIImage imageNamed:@"chat_msg.png"] forState:UIControlStateNormal];
    comBtn.frame = CGRectMake(kScale2x(553), kScale2x(47), kScale2x(50), kScale2x(45));
    [comBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [header addSubview:comBtn];
    
    return  header;
}

-(UIView*)MakeBody:(PublisherEntity*)pubEntity
{
    UIView  *bodyView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeaderHeight+kVerGapH, IPHONE_SCREEN_WIDTH, kBodyHeight)];
    bodyView.backgroundColor = [UIColor clearColor];
    
    CGFloat xx = 0,yy = 0;
    
    if(pubEntity.imgURL)
    {//back ground
        UIImageView *backGround = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, IPHONE_SCREEN_WIDTH, kBodyHeight)];
        
        if ([pubEntity.imgURL hasPrefix:@"http:"] || [pubEntity.imgURL hasPrefix:@"https:"])
        {
            NSURL  *imgURL = [[NSURL alloc] initWithString:pubEntity.imgURL];
            [UIImageView setDefaultEngine:[AppDelegate shareAppInstace].httpEngine];
            [backGround setImageFromURL:imgURL];
        }
        else
        {
            UIImage *imgHeader = [UIImage imageNamed:pubEntity.imgURL];
            backGround.image = imgHeader;
        }
        
        [bodyView addSubview:backGround];
    }
    
    if(pubEntity.title)
    {
        UIImageView *bgBarImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alpha_bar_rectange.png"]];
        bgBarImgView.frame = CGRectMake(xx, yy, IPHONE_SCREEN_WIDTH, kScale2x(78));
        
        [bodyView addSubview:bgBarImgView];
        
        xx = kScale2x(25);
        yy += kScale2x(21);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, kScale2x(408), kScale2x(36))];
        title.text = pubEntity.title;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = kWhiteColor;
        title.font = kDefaultFont;
        title.textAlignment = NSTextAlignmentLeft;
        
        [bodyView addSubview:title];
        
        xx = kScale2x(508);
        yy -= kScale2x(8);
        
        UIButton *rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rateBtn.tag = E_Rate_BtnMSG;
        [rateBtn setBackgroundImage:[UIImage imageNamed:@"music_button.png"] forState:UIControlStateNormal];
        rateBtn.frame = CGRectMake(xx, yy, kScale2x(52), kScale2x(52));
        [rateBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [bodyView addSubview:rateBtn];
        
        xx += kScale2x(52);
    }
    
    if(pubEntity.playTime)
    {
        xx += 4;
        yy += 8;
        
        UILabel *mTime = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, IPHONE_SCREEN_WIDTH - xx, kScale2x(36))];
        mTime.text = pubEntity.playTime;
        mTime.backgroundColor = [UIColor clearColor];
        mTime.textColor = kWhiteColor;
        mTime.font = kDefaultFont;
        mTime.textAlignment = NSTextAlignmentLeft;
        
        [bodyView addSubview:mTime];
    }
    
    xx = kScale2x(20);
    yy = kScale2x(410);
    
    UIButton *heardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    heardBtn.tag = E_Heart_BtnMSG;
    if(pubEntity.isHeart)
        [heardBtn setBackgroundImage:[UIImage imageNamed:@"Heart_full.png"] forState:UIControlStateNormal];
    else
        [heardBtn setBackgroundImage:[UIImage imageNamed:@"Heart_full.png"] forState:UIControlStateNormal];
    heardBtn.frame = CGRectMake(xx, yy, kScale2x(69), kScale2x(58));
    [heardBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [bodyView addSubview:heardBtn];
    
    yy -= 4;
    xx = kScale2x(579);
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.tag = E_Share_BtnMSG;
//    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_button.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share_button.png"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(xx, yy, kScale2x(49), kScale2x(64));
    [shareBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [bodyView addSubview:shareBtn];
    
    return bodyView;
}

-(UIView*)MakeDescription:(PublisherEntity*)pubEntity
{
    UIView  *decView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeaderHeight + kBodyHeight+kVerGapH, IPHONE_SCREEN_WIDTH, kDecDefaultHeight)];
    decView.backgroundColor = [UIColor clearColor];
    
    CGFloat xx = kScale2x(40),yy = kScale2x(40);
    
    UILabel *decription = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, IPHONE_SCREEN_WIDTH - xx, kScale2x(36))];
    decription.text = @"Desctiption";
    decription.backgroundColor = [UIColor clearColor];
    decription.textColor = kBlackColor;
    decription.font = [UIFont boldSystemFontOfSize:kBigFontSize];
    decription.textAlignment = NSTextAlignmentLeft;
    
    [decView addSubview:decription];
    
    
    yy += kScale2x(40);
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, IPHONE_SCREEN_WIDTH - xx, kDecDefaultHeight - yy - kScale2x(40))];
    content.text = pubEntity.description;
    content.backgroundColor = [UIColor clearColor];
    content.textColor = kDefaultGrayColor;
    content.font = kDefaultFont;
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = kPublisherDescritionLines;
    content.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [decView addSubview:content];
    
    return decView;
}

-(UIView*)MakeCustomerReview
{
    UIView  *header = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight + kBodyHeight+kVerGapH+kDecDefaultHeight, IPHONE_SCREEN_WIDTH, kScale2x(42))];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel   *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(kScale2x(32), 0, IPHONE_SCREEN_WIDTH, kScale2x(42))];
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.text = @"Customer Reviews";
    sectionHeader.font = kDefaultFont;
    sectionHeader.textAlignment = NSTextAlignmentLeft;
    sectionHeader.textColor = kBlackColor;
    [header addSubview:sectionHeader];
    
    return header;
}



-(void)makeUI:(PublisherEntity*)pubEntity
{
    if(pubEntity == nil) return;
    
    CGFloat  sumHeight = 0;
    
    UIView *headerView = [self MakeHeader:pubEntity];
    
    [self addSubview: headerView];
    
    sumHeight += headerView.frame.size.height;
    
    UIView *bodyView = [self MakeBody:pubEntity];
    [self addSubview: bodyView];
    
    sumHeight += kVerGapH;
    sumHeight += bodyView.frame.size.height;
    
    UIView *decView = [self MakeDescription:pubEntity];
    [self addSubview: decView];
    
    sumHeight += kVerGapH;
    sumHeight += decView.frame.size.height;
    
    UIView *cusReviewVew = [self MakeCustomerReview];
    [self addSubview: cusReviewVew];
    sumHeight += cusReviewVew.frame.size.height;
    
    self.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, sumHeight);
}

-(void)clickButton:(id)sender
{
    UIView *clickCtrl = (UIView*)sender;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickControl:)])
    {
        [self.delegate clickControl:clickCtrl.tag];
    }
}



@end
