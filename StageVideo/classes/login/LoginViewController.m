//
//  LoginViewController.m
//  StageVideo
//
//  Created by kmgao on 14-5-15.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:kWhiteColor];
    
    UIImage *imgBg = [UIImage imageNamed:@"guideBg.png"];
    UIImageView  *bgImgView = [[UIImageView alloc] initWithImage:imgBg];
    bgImgView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
    [self.view addSubview:bgImgView];
    
    UIImage  *simleImg = [UIImage imageNamed:@"smile_Letter.png"];
    CGRect mFrame = CGRectMake(kScale2x(62), kScale2x(417), kScale2x(517), kScale2x(132));
    UIImageView *simleImgView = [[UIImageView alloc] initWithFrame:mFrame];
    simleImgView.image = simleImg;
    
    [self.view addSubview:simleImgView];
    
    UIImage  *loginImg = [UIImage imageNamed:@"login_facebook.png"];
    UIImageView *logImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, kScale2x(717), IPHONE_SCREEN_WIDTH, kScale2x(98))];
    logImgView.image = loginImg;
    
    [self.view addSubview:logImgView];
    
    UIButton *fbBtn = [[UIButton alloc] initWithFrame:logImgView.frame];
    fbBtn.showsTouchWhenHighlighted = YES;
    fbBtn.backgroundColor = [UIColor clearColor];
    [fbBtn addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbBtn];
    
    UIImage  *lg_email = [UIImage imageNamed:@"login_email.png"];
    UIImageView *lg_emailView = [[UIImageView alloc] initWithFrame:CGRectMake(1, kScale2x(830), IPHONE_SCREEN_WIDTH, kScale2x(157))];
    lg_emailView.image = lg_email;
    
    [self.view addSubview:lg_emailView];
    
    UIButton *mailBtn = [[UIButton alloc] initWithFrame:lg_emailView.frame];
    mailBtn.showsTouchWhenHighlighted = YES;
    mailBtn.backgroundColor = [UIColor clearColor];
    [mailBtn addTarget:self action:@selector(loginWithMail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mailBtn];
    
    CGRect _frame = lg_emailView.frame;
    _frame.origin.x = 40;
    _frame.origin.y += 20 + lg_emailView.frame.size.height/2;
    _frame.size.width = IPHONE_SCREEN_WIDTH - 40*2;
    _frame.size.height = 40;
    
    UIButton *registBtn = [[UIButton alloc] initWithFrame:_frame];
    registBtn.showsTouchWhenHighlighted = YES;
    registBtn.backgroundColor = [UIColor clearColor];
    [registBtn addTarget:self action:@selector(registByNow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    
}

-(void)loginWithFacebook{
    
}

-(void)loginWithMail{
    
}

-(void)registByNow{
    RegisterViewController *registVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
