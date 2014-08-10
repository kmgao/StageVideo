//
//  CallBaseView.h
//  StageVideo
//
//  Created by kmgao on 14-6-6.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallBaseView : UIView

@property(nonatomic,assign) BOOL isMute;
@property(nonatomic,assign) BOOL isSpeaker;
@property(nonatomic,assign) BOOL isCamera;

@property(nonatomic,copy)   NSString *statueInfo;

-(void)initialCallUI;
-(void)setCallStateInfFrame:(CGRect)_frame;

-(void)setCallState:(int)state;


@end
