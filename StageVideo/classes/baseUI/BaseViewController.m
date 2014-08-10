//
//  BaseViewController.m
//  ITouchUI
//
//  Created by candy on 14-5-3.
//  Copyright (c) 2014年 candy. All rights reserved.
//

#import "BaseViewController.h"

#import "BNaviBarVIew.h"

@interface BaseViewController ()
{

}
@end

@implementation BaseViewController

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
	[self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavibarHide:YES animation:NO];
    self.naviBar = [[BNaviBarView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, kNaviBarHeight)];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ( isIOS7 )
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isIOS7) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}


-(void)setBgImageView:(NSString*)imagePath{
    if(imagePath == nil) return ;
    UIImage *img = [UIImage imageNamed:imagePath];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 

-(void)setNaviBarTitle:(NSString*)title{
    if(self.navigationController){
        [self.navigationItem setTitle:title];
    }
}

-(void)setNaviBarBg:(NSString*)bgName{
    if(bgName == nil) return;
    
    UIImage *navImgBg = [UIImage imageNamed:bgName];//@"Main_Navi_Menubarbg.png"
    UIImageView  *navBgImgView = [[UIImageView alloc] initWithImage:navImgBg];
    navBgImgView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, NAVIGATION_BAR_HEGITH);
    [self.view addSubview:navBgImgView];
}

-(void)setNaviBarBack:(NSString*)imgName{
    if(imgName == nil){
        return ;
    }
    
    
    
    
}



-(UIBarButtonItem*)addLeftButtonItem:(NSString*)strName isImgBtn:(BOOL)imagBtn{
    if(strName == nil) return  nil;
    
    UIBarButtonItem  *leftBtn;
    if(imagBtn){
        
        UIImage *image = [UIImage imageNamed:@"strName"];
        leftBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handlLeftButton:)];
    }
    else{
        leftBtn = [[UIBarButtonItem alloc] initWithTitle:strName style:UIBarButtonItemStylePlain target:self action:@selector(handlLeftButton:)];
    }
    self.navigationItem.leftBarButtonItem = leftBtn;
    return leftBtn;
}


-(UIBarButtonItem*)addRightButtonItem:(NSString*)strName isImgBtn:(BOOL)imagBtn{
    if(strName == nil) return nil;
    
    UIBarButtonItem  *rightBtn;
    if(imagBtn){
        UIImage *image = [UIImage imageNamed:strName];
       rightBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handlRightButton:)];
    }
    else{
         rightBtn = [[UIBarButtonItem alloc] initWithTitle:strName style:UIBarButtonItemStylePlain target:self action:@selector(handlLeftButton:)];
    }
    self.navigationItem.rightBarButtonItem = rightBtn;
    return  rightBtn;
}

-(void)handlLeftButton:(id)sender{
//subclass implement
}

-(void)handlRightButton:(id)sender{
//subclass implement
}

-(void)setNavibarHide:(BOOL)hide animation:(BOOL)animation{
    [self.navigationController setNavigationBarHidden:hide animated:animation];
}


@end
