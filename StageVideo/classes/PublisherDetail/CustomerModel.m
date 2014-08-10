//
//  CustomerModel.m
//  StageVideo
//
//  Created by kmgao on 14-5-26.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "CustomerModel.h"

NSString* const PubDetail_Data_Update_Notification = @"PubDetail_Data_Update_Notification";

@implementation CustomerModel

static CustomerModel *g_instance = nil;
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
    if(g_instance == nil)
    {
        return [self shareInstance];
    }
    return g_instance;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.customerLists = [[NSMutableArray alloc] init];
    }
    return  self;
}

-(void)update:(id)data
{
    if(data && [data isKindOfClass:[NSArray class]])
    {
        [self.customerLists addObjectsFromArray:(NSArray*)data];
        [[NSNotificationCenter defaultCenter] postNotificationName:PubDetail_Data_Update_Notification object:self.customerLists userInfo:nil];
    }
}



@end
