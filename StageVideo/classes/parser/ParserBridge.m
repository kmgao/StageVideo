//
//  ParserBridge.m
//  StageVideo
//
//  Created by kmgao on 14-5-21.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "ParserBridge.h" 

static  NSString*  const application_ID = @"IwWMDUWTD9wg6Vt4DMoroSLusLADoYOUgxiQODKR";
static  NSString*  const client_key = @"93bL7XYpi0ATsqPB0q1Kgt9hUuvIeeFaWdJCoqCr";

#define kUserName  @"userName"
#define kPassword  @"password"
#define kEmail     @"email"
#define kRegAccount   @"RegAccount"

@implementation ParserBridge

static ParserBridge *g_instance = nil;
+(instancetype)shareParser
{
    @synchronized(self)
    {
        if(g_instance == nil)
        {
            g_instance = [[ParserBridge alloc] init];
        }
        return g_instance;
    }
}

-(void)install
{
    [Parse setApplicationId:application_ID
                  clientKey:client_key];
    
    [PFUser enableAutomaticUser];
    
    PFUser *user = [PFUser currentUser];
    [user refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
    }];
    
    self.hasRegisted = [[NSUserDefaults standardUserDefaults] objectForKey:kRegAccount] != NULL;
} 

-(void)registeNewUser:(NSString*)name
            password:(NSString*)psword
               eMail:(NSString*)email
            andBlock:(PFBooleanResultBlock)blockFinish
{
    PFUser *newUser = [PFUser user];
    newUser.username = name;
    newUser.password = psword;
    newUser.email = email;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        blockFinish(succeeded,error);
        if(error == nil)
        {
            self.usrName = name;
            self.usrMail = email;
            self.hasRegisted = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:kUserName];
            [[NSUserDefaults standardUserDefaults] setObject:psword forKey:kPassword];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:kEmail];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kRegAccount];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

-(void)loginIn2Parser:(NSString*)user
           password:(NSString*)psw
        finishBlock:(PFUserResultBlock)block
{
    [PFUser logInWithUsernameInBackground:user password:psw block:^(PFUser *user, NSError *error) {
        block(user,error);
    }];
}

-(void)loginIn2ParserBackground:(PFUserResultBlock)block
{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
    if(user && password)
    {
        [self loginIn2Parser:user password:password finishBlock:block];
    }
    else
    {
        block(NO,[NSError errorWithDomain:@"User Name or Password is NULL" code:-1 userInfo:nil]);
    }
}

+(void)loginOut2Parser
{
    [PFUser logOut];
    [ParserBridge shareParser].hasRegisted = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEmail];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRegAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
