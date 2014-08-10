//
//  PublisherParser.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "PublisherParser.h"
#import "BaseModel.h"
#import "PublisherEntity.h"
#import "PublisherModel.h"

@implementation PublisherParser

-(void)parser:(id)data
{
    if(data && [data isKindOfClass:[NSData class]])
    {
        [self parserPublisher:data];
    }
    else
    {
        [self TestLocalData];
    }
}

-(id)dataModel
{
    return [PublisherModel shareInstance];  
}


-(void)parserPublisher:(NSData*)data
{
    NSMutableArray *datArray = [[NSMutableArray alloc] init];
    
    
    //数据解析完成,通知数据模型更新数据
    [self.model update:datArray];
}


-(void)TestLocalData
{
    NSMutableArray *datArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 10 ; i++)
    {
        PublisherEntity *entify = [[PublisherEntity alloc] init];
        entify.title = [NSString stringWithFormat:@"Eat everything in %d sec",(30+i)];
        entify.puberName = @"index-name";
        entify.playTime = [NSString stringWithFormat:@"%dm",(i+1)];
        entify.country = @"china";
        entify.ratingCount = (i+1);
        if(!(i&1)){
            entify.isHeart = YES;
            entify.imgURL = @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1401/10/c0/30457342_1389342593146_800x600.jpg";
        }
        else{
            entify.isHeart = NO;
            entify.imgURL = @"main_back_cell.png";
        }
        entify.pubTime = [NSDate date];
        entify.isWatch = YES;
        entify.description = @"I graduated from The Hong Kong Polytechnic University majoring in Fashion Design and have never been too far away from the visual excitements afterwards. I continued with the bags and design freelance jobs while working in events and";
        [datArray addObject:entify];
    }
    
    //数据解析完成,通知数据模型更新数据
    [self.model update:datArray];
}


@end
