//
//  CustomerTBViewCell.m
//  StageVideo
//
//  Created by kmgao on 14-5-26.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "CustomerTBViewCell.h"
#import "CustomerEntity.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "AppDelegate.h"

#define   kCustomerHeaderSize  CGSizeMake(48,48)

#define   kCustomerCellHeight     105

@implementation CustomerTBViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
 
}

-(void)buildUI:(CustomerEntity*)entity
{
    CGFloat  xx = kScale2x(32),yy = kScale2x(28);
    if(entity.headImgURL)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, kCustomerHeaderSize.width, kCustomerHeaderSize.height)];
        
        if ([entity.headImgURL hasPrefix:@"http:"] || [entity.headImgURL hasPrefix:@"https:"])
        {
            NSURL  *imgURL = [[NSURL alloc] initWithString:entity.headImgURL];
            [UIImageView setDefaultEngine:[AppDelegate shareAppInstace].httpEngine];
            [imgView setImageFromURL:imgURL];
            imgView.userInteractionEnabled = YES;            
        }
        else
        {
            UIImage *imgHeader = [UIImage imageNamed:entity.headImgURL];
            imgView.image = imgHeader;
        }
        
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = kCustomerHeaderSize.width/2;
        
        [self.contentView addSubview:imgView];
    }
    
    if(entity.name)
    {
        CGFloat tmpY = yy + kCustomerHeaderSize.height + 2;
        
        UILabel  *name = [[UILabel alloc] initWithFrame:CGRectMake(xx, tmpY,kCustomerHeaderSize.width,20)];
        name.backgroundColor = [UIColor clearColor];
        name.textColor = kDefaultGrayColor;
        name.textAlignment = NSTextAlignmentLeft;
        name.text = entity.name;
        name.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:name];
    }
    
    xx = kScale2x(174);
    for(int i =0 ; i < 5;i++)
    {
        UIImage  *comImg = nil;
        if(i < entity.comCount)
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
        
        [self.contentView addSubview:comImgView];
    }
    
    if(entity.time)
    {
        xx = kScale2x(473);
        UILabel  *time = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, IPHONE_SCREEN_WIDTH - xx, kScale2x(39))];
        time.backgroundColor = [UIColor clearColor];
        time.textColor = kDefaultGrayColor;
        time.textAlignment = NSTextAlignmentLeft;
        time.text = entity.time;
        time.font = kDefaultFont;
        [self addSubview:time];
    }
    
    if(entity.comContent)
    {
        xx = kScale2x(174);
        yy += kScale2x(30);

        UILabel  *content = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy,kScale2x(428),kCustomerCellHeight - yy)];
        content.backgroundColor = [UIColor clearColor];
        content.textColor = kDefaultGrayColor;
        content.textAlignment = NSTextAlignmentLeft;
        content.lineBreakMode = NSLineBreakByTruncatingTail;
        content.text = entity.comContent;
        content.font = kDefaultFont;
        content.numberOfLines = 3;
        
        [self addSubview:content];
    }
    
    xx = kScale2x(174);
    
    UIImage *lineImg = [UIImage imageNamed:@"separator_line.png"];
    UIImageView *lineView = [[UIImageView alloc] initWithImage:lineImg];
    lineView.frame = CGRectMake(xx, kCustomerCellHeight-1, IPHONE_SCREEN_WIDTH - xx, 1);
    [self.contentView  addSubview:lineView];
}


+(CGFloat)getCellHeight
{
    return kCustomerCellHeight;
}

@end
