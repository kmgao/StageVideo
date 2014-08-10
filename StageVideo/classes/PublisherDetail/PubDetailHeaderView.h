//
//  PublishDetailTableViewCell.h
//  StageVideo
//
//  Created by kmgao on 14-5-26.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PublisherEntity;

@protocol PubDetailHeaderViewDelegate <NSObject>

enum
{
    E_Comment_TxtMSG = 11101,
    E_Rate_BtnMSG,
    E_Heart_BtnMSG,
    E_Share_BtnMSG
};

@optional

-(void)clickControl:(int)ctrlTag;

@end

@interface PubDetailHeaderView : UIView

@property(nonatomic,weak)  id<PubDetailHeaderViewDelegate>  delegate;

-(void)makeUI:(PublisherEntity*)pubEntity;

@end
