//
//  PublisherModel.h
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BaseModel.h"

extern NSString* const Publisher_Data_Update_Notification;


@interface PublisherModel : BaseModel

@property(nonatomic,strong) NSMutableArray   *puberList;
//是否清空上次数据,默认清空
@property(nonatomic,assign) BOOL             isCleanLastData;

+(instancetype)shareInstance;

-(void)cleanAllData;

@end
