//
//  BaseParser.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BaseParser.h" 

@implementation BaseParser

-(id)init
{
    self = [super init];
    if(self)
    {
        self.model = [self dataModel];
    }
    return self;
}

-(id)dataModel
{
    return nil;
}

-(void)parser:(id)data
{
    //must be implement by sub class
}

@end
