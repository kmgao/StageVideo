//
//  CustomerParser.m
//  StageVideo
//
//  Created by kmgao on 14-5-26.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "CustomerParser.h"
#import "CustomerModel.h"
#import "CustomerEntity.h"

@implementation CustomerParser


-(id)dataModel
{
    return [CustomerModel shareInstance];
}

-(void)parser:(id)data
{
    if(data && [data isKindOfClass:[NSData class]])
    {
        
    }
    else
    {
        [self TestLocalData];
    }
}

-(void)TestLocalData
{
    NSMutableArray *datArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 10 ; i++)
    {
        CustomerEntity *customer = [[CustomerEntity alloc] init];
        customer.name = [NSString stringWithFormat:@"Chris-%d",(i+1)];
        if(i&1)
            customer.headImgURL = @"http://f.hiphotos.baidu.com/image/pic/item/b3b7d0a20cf431ad2e84fdb24936acaf2fdd98e3.jpg";
        else
            customer.headImgURL = @"customer_header_default.png";
        if(i&1)
            customer.comCount = 4;
        else
            customer.comCount = 3;
        customer.time = @"yesterday";
        customer.comContent = @"This is the comment; this is the comment; this is the comment too, this is the comment!This is the comment; this is the comme";
        [datArray addObject:customer];
    }
    
    //数据解析完成,通知数据模型更新数据
    [self.model update:datArray];
}



@end
