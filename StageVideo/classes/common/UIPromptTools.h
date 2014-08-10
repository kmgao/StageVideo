//
//  UIPromptTools.h
//  StageVideo
//
//  Created by kmgao on 14-5-16.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIPromptToolsDelegate <NSObject>

-(void)clickButton:(int)index;

@end


@interface UIPromptTools : NSObject

+(instancetype) shareInstance;

-(void)showAlertView:(NSString*)title content:(NSString*)content okButton:(NSString*)okText ancelButton:(NSString*)cancelText;

@end
