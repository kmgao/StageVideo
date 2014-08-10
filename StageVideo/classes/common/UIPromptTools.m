//
//  UIPromptTools.m
//  StageVideo
//
//  Created by kmgao on 14-5-16.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "UIPromptTools.h"

@interface UIPromptTools()
{
    
}

@end

@implementation UIPromptTools
static UIPromptTools *g_instance = nil;
+(instancetype) shareInstance
{
    @synchronized(self){
        if(g_instance == nil){
            g_instance = [[UIPromptTools alloc] init];
        }
        return g_instance;
    }
}

-(id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}


-(void)showAlertView:(NSString*)title content:(NSString*)content okButton:(NSString*)okText ancelButton:(NSString*)cancelText{
    
    UIAlertView  *alertView = [[UIAlertView alloc] init];
    if(title == nil){
        [alertView setTitle:@""];
    }
    else{
        [alertView setTitle:title];
    }
    
    if(content == nil){
        [alertView setMessage:@""];
    }
    else{
        [alertView setMessage:content];
    }
    
    if(okText){
        [alertView addButtonWithTitle:okText];
    }
    
    if(cancelText){
        [alertView addButtonWithTitle:cancelText];
    }
    
    [alertView show];
}

@end
