//
//  CustomerEntity.h
//  StageVideo
//
//  Created by kmgao on 14-5-17.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseEntity.h"

@interface CustomerEntity : BaseEntity

@property(nonatomic,copy)    NSString  *name;
@property(nonatomic,copy)    NSString  *headImgURL;
@property(nonatomic,assign)  int       comCount; //评分数
@property(nonatomic,copy)    NSString  *time; //时间
@property(nonatomic,copy)    NSString  *comContent; //评论内容


@end
