//
//  PublisherEntity.m
//  StageVideo
//
//  Created by kmgao on 14-5-17.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "PublisherEntity.h"

@implementation PublisherEntity

+(PublisherEntity*)getInstance
{
    PublisherEntity *pubEntity = [[PublisherEntity alloc] init];
    return pubEntity;
}


@end
