//
//  CallModel.h
//  StageVideo
//
//  Created by kmgao on 14-6-3.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BaseModel.h"

@class CallViewController;

@interface CallModel : BaseModel

+(instancetype)shareInstance;

@property(nonatomic,assign) int     callID;
@property(nonatomic,assign) int     callType;
@property(nonatomic,assign) int     callState;
@property(nonatomic,assign) CallViewController   *viewCtrl;



@end

