//
//  PublisherEntity.h
//  StageVideo
//
//  Created by kmgao on 14-5-17.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseEntity.h"

@interface PublisherEntity : BaseEntity

+(PublisherEntity*)getInstance;

@property(nonatomic,copy)      NSString     *title;
@property(nonatomic,strong)    NSString     *playTime;
@property(nonatomic,copy)      NSString     *puberName;
@property(nonatomic,strong)    NSDate       *pubTime;
@property(nonatomic,assign)    int          ratingCount;
@property(nonatomic,assign)    BOOL         isHeart;
@property(nonatomic,assign)    BOOL         isWatch;
@property(nonatomic,copy)      NSString     *imgURL;
@property(nonatomic,copy)      NSString     *country;
@property(nonatomic,copy)      NSString     *description;

@end
