//
//  ParserBridge.h
//  StageVideo
//
//  Created by kmgao on 14-5-21.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParserBridge : NSObject

+(instancetype)shareParser;
-(void)install;

@property(nonatomic,copy)   NSString *usrName;
@property(nonatomic,copy)   NSString *usrMail;
@property(nonatomic,assign) BOOL     hasRegisted;//是否已经注册了

//注册
-(void)registeNewUser:(NSString*)name
            password:(NSString*)psword
               eMail:(NSString*)email
            andBlock:(PFBooleanResultBlock)blockFinish;
//登录
-(void)loginIn2Parser:(NSString*)user
           password:(NSString*)psw
        finishBlock:(PFUserResultBlock)block;

-(void)loginIn2ParserBackground:(PFUserResultBlock)block;

//登出
+(void)loginOut2Parser;

@end
