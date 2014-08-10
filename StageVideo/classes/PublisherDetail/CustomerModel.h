//
//  CustomerModel.h
//  StageVideo
//
//  Created by kmgao on 14-5-26.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BaseModel.h"

extern  NSString* const PubDetail_Data_Update_Notification;

@interface CustomerModel : BaseModel

@property(nonatomic,strong) NSMutableArray   *customerLists;

+(instancetype)shareInstance;

@end
