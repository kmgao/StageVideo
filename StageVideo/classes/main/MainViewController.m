//
//  MainViewController.m
//  StageVideo
//
//  Created by kmgao on 14-5-15.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "MainViewController.h"
#import "BNaviBarVIew.h"

#import "SUNSlideSwitchView.h"

#import "MainListViewController.h"
#import "PublisherDetailController.h"
#import "HomeListTableView.h"
#import "PublisherParser.h"

#import "MMDrawerController.h"
#import "MoreSetViewController.h"
#import "MMDrawerVisualState.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController+Subclass.h"

#import "ParserBridge.h"

#import "PublisherModel.h"

#import "ViewController.h"

#define  kTopListBarHeight  44.0


@interface MainViewController()<BNaviBarVIewDelegate,SUNSlideSwitchViewDelegate,HomeListTableViewDelegate>
{
     MainListViewController *dollar5List;
     MainListViewController *freeList;
     MainListViewController *dollar7List;
     BaseParser *parser;
}

@property(nonatomic,strong) SUNSlideSwitchView  *slidSwitchView;

@end

@implementation MainViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AppDelegate shareAppInstace].appNavi setCanDragBack:NO];
    
    [self.naviBar setbackgrounImage:@"Main_Navi_Menubarbg.png"];
    self.naviBar.delegate = self;
    [self.view addSubview:self.naviBar];
    
    [self.naviBar setNaviTitle:nil titleColde:nil imgTitle:@"stage_log_title.png"];
    
    UIButton *setBtn = [self.naviBar addNaviButton:@"Settings.png" lightBg:nil andImage:nil andTag:0];
    setBtn.frame = CGRectMake(kScale2x(25), kScale2x(70), kScale2x(44), kScale2x(30));
    setBtn.showsTouchWhenHighlighted = YES;
    
    UIButton *searchBtn = [self.naviBar addNaviButton:@"search.png" lightBg:nil andImage:nil andTag:1];
    searchBtn.frame = CGRectMake(kScale2x(490), kScale2x(56), kScale2x(62), kScale2x(62));
//    searchBtn.showsTouchWhenHighlighted = YES;
    
    UIButton *recordBtn = [self.naviBar addNaviButton:@"Record.png" lightBg:nil andImage:nil andTag:1];
    recordBtn.frame = CGRectMake(kScale2x(571), kScale2x(63), kScale2x(44), kScale2x(44));
    recordBtn.showsTouchWhenHighlighted = YES;
    
    
    self.slidSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEGITH, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT - NAVIGATION_BAR_HEGITH)];
    self.slidSwitchView.slideSwitchViewDelegate = self;
    
    self.slidSwitchView.topScrollViewBg.image = [UIImage imageNamed:@"main_slidswitchBarbg.png"];
    
    self.slidSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slidSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"0"];
    self.slidSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    [self.slidSwitchView  buildUI];
    
    [self.view addSubview:self.slidSwitchView];
    
    if([ParserBridge shareParser].hasRegisted)
    {
        [self loging2Parser];
    }
    
}

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view{
    return 3;
}

-(HomeListTableView*)getHomeListTableView:(int)type
{
    HomeListTableView *homeTable = [[HomeListTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEGITH-kTopListBarHeight)];
    homeTable.clickCellDelegate = self;
    
    if(parser == nil)
    {
        parser = [[PublisherParser alloc] init];
        [parser parser:nil];
    }
    
    return homeTable;
}


- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number{
   
   CGRect listFrame = CGRectMake(0, NAVIGATION_BAR_HEGITH, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT - NAVIGATION_BAR_HEGITH);
    
    if(number == 0)
    {
        if(dollar5List == nil)
        {
            HomeListTableView *homeTable =[self getHomeListTableView:number];
            
            dollar5List = [[MainListViewController alloc] init];
            dollar5List.type = eMainView_List_5Dollar;
            [dollar5List.view addSubview:homeTable];
            
            dollar5List.view.frame = listFrame;
            
        }
        return  dollar5List;
    }
    else if(number == 1){
        if(freeList == nil)
        {
            HomeListTableView *homeTable =[self getHomeListTableView:number];
            
            freeList = [[MainListViewController alloc] init];
            freeList.type = eMainView_List_Freee;
            [freeList.view addSubview:homeTable];
            freeList.view.frame = listFrame;
        }
        return  freeList;
    }
    else if(number == 2){
       if(!dollar7List)
       {
           HomeListTableView *homeTable =[self getHomeListTableView:number];
           
           dollar7List = [[MainListViewController alloc] init];
           dollar7List.type = eMainView_List_7Dollar;
           [dollar7List.view addSubview:homeTable];
           dollar7List.view.frame = listFrame;
       }
       return  dollar7List;
    }
    
    return freeList;
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    MMDrawerController *drawerController = (MMDrawerController *)self.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}



#pragma mark -
#pragma BNaviBarVIewDelegate

-(void)clickNaviButton:(BNaviBarView*)navView andIndex:(int)index{
    if(index == 0){
//        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//            
//        }];
        
        MoreSetViewController *moreSetting = [[MoreSetViewController alloc] init];
        [self.navigationController pushViewController:moreSetting animated:YES];

    }
}


-(void)viewDidAppear:(BOOL)animated{

}

-(void)clickWatchButton{
   //跳到
    
//    ViewController *videoController = [[ViewController alloc] initWithNibName:<#(NSString *)#> bundle:<#(NSBundle *)#>];

}

-(void)clickHeartButton{
    
}

-(void)clickMusicButton{
    
}

-(void)clickSearchButton{

}

-(void)clickRecordButton{
    
}


-(void)clickTableViewCell:(NSIndexPath*)indexPath
{
    PublisherDetailController *detailCtrl = [[PublisherDetailController alloc] init];
    detailCtrl.pubEntity = [[PublisherModel shareInstance].puberList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
}


+(UIViewController*)createSlidViewController
{
//    MoreSetViewController *leftVC = [[MoreSetViewController alloc] init];
    MainViewController *mainView = [[MainViewController alloc] init];
    
    MMDrawerController *drawerCtrl = [[MMDrawerController alloc] initWithCenterViewController:mainView leftDrawerViewController:nil rightDrawerViewController:nil];
    
    [drawerCtrl setMaximumLeftDrawerWidth:180];
    [drawerCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerCtrl setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerCtrl setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        block(drawerController, drawerSide, percentVisible);
    }];
    return drawerCtrl;
}

-(void)loging2Parser
{
    [[ParserBridge shareParser] loginIn2ParserBackground:^(PFUser *user, NSError *error) {
        if(error)
        {
            dispatch_after(dispatch_time(NSEC_PER_SEC*1, 0), dispatch_get_global_queue(0, 0), ^{
                [self loging2Parser];
            });
//            [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"login faild" okButton:@"cancel" ancelButton:nil];
        }
    }];
}


@end
