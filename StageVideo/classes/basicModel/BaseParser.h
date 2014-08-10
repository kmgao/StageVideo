//
//  BaseParser.h
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseModel;

@interface BaseParser : NSObject

@property(nonatomic,strong) BaseModel *model;

//data parse interface
//must be implement by sub class
-(void)parser:(id)data;
//must be implement by subclass
-(id)dataModel;

@end
