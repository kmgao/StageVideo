//
//  PublisherModel.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "PublisherModel.h"

#define kTest_DataDefine    1

NSString* const Publisher_Data_Update_Notification = @"Publisher_Data_Update_Notification";

@implementation PublisherModel

static PublisherModel *g_instance = nil;
+(instancetype)shareInstance
{
    @synchronized(self)
    {
        if(g_instance == nil)
        {
            g_instance = [[super allocWithZone:NULL] init];
        }
        return  g_instance;
    }
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}


-(instancetype)init
{
    self = [super init];
    if(self){
        self.puberList = [[NSMutableArray alloc] init];
        self.isCleanLastData = YES;
    }
    return  self;
}  

-(void)cleanAllData
{
    [self.puberList removeAllObjects];
}

-(void)update:(id)data
{
    if(data && [data isKindOfClass:[NSArray class]])
    {
//        if(self.isCleanLastData){
//            [self cleanAllData];
//        }
        [self.puberList addObjectsFromArray:(NSArray*)data];
        [[NSNotificationCenter defaultCenter] postNotificationName:Publisher_Data_Update_Notification object:self.puberList userInfo:nil];
    }
}


@end
