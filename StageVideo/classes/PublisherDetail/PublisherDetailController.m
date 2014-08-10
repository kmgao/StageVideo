//
//  PublisherDetailController.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "PublisherDetailController.h"
#import "BNaviBarVIew.h"
#import "PubDetailHeaderView.h"
#import "PublisherEntity.h"
#import "CustomerModel.h"
#import "CustomerTBViewCell.h"
#import "CustomerParser.h"
#import "MJRefreshFooterView.h"
#import "CallViewController.h"


@interface PublisherDetailController ()<BNaviBarVIewDelegate,PubDetailHeaderViewDelegate,MJRefreshBaseViewDelegate>
{
     MJRefreshFooterView *refreshFoot;
}
@end

@implementation PublisherDetailController

-(void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self name:PubDetail_Data_Update_Notification object:nil];
   [refreshFoot free];
}

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

    [[AppDelegate shareAppInstace].appNavi setCanDragBack:YES];
    self.naviBar.delegate = self;
    [self.naviBar setbackgrounImage:@"Main_Navi_Menubarbg.png"];
    [self.view addSubview:self.naviBar];
    
    [self.naviBar setNaviTitle:nil titleColde:nil imgTitle:@"stage_log_title.png"];
    
    
    UIButton *leftBtn = [self.naviBar addNaviButton:@"navigation_back.png" lightBg:nil andImage:nil andTag:0];
    leftBtn.frame = kNaviBarLeftBackFrame;
    leftBtn.tag = 0;
    
    UIButton *watchBtn = [self.naviBar addNaviButton:@"watch_button.png" lightBg:nil andImage:nil andTag:0];
    watchBtn.frame = CGRectMake(kScale2x(483), kScale2x(55), kScale2x(137), kScale2x(50));
    watchBtn.tag = 1;
    
    [self addObserver];
    
    PubDetailHeaderView *detailHeader = [[PubDetailHeaderView alloc] init];
    [detailHeader makeUI:self.pubEntity];
    
    [self.tbView setTableHeaderView:detailHeader];
    
    [self.tbView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    CGRect _frame = self.tbView.frame;
//    _frame.origin.y += NAVIGATION_BAR_HEGITH;
//    _frame.size.height -= NAVIGATION_BAR_HEGITH;
//    self.tbView.frame = _frame;
    
    [self parserData];
    
    //添加上拉加载更多
    refreshFoot = [[MJRefreshFooterView alloc] init];
    refreshFoot.delegate = self;
    refreshFoot.scrollView = self.tbView;
    refreshFoot.statusLabel.text = @"starting data...";
}

-(void)clickNaviButton:(BNaviBarView*)navView andIndex:(int)index
{
    if(index == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(index == 1)
    {
//        UIStoryboard *video = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        UIViewController *videoCtrl = [video instantiateInitialViewController];
////        [self.navigationController pushViewController:videoCtrl animated:YES];
//        [self presentViewController:videoCtrl animated:YES completion:nil];
        
        [[CallViewController shareInstance] makeCall:@"token" callType:0];
        
    }
}

-(void)addObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataUpdateObserver:) name:PubDetail_Data_Update_Notification object:nil];
}

-(void)addDataUpdateObserver:(NSNotification*)notity
{
    [[self tbView] reloadData];
}


-(void)parserData
{
    BaseParser *p = [[CustomerParser alloc] init];
    [p parser:nil];
} 

#pragma mark- UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CustomerTBViewCell getCellHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[CustomerModel shareInstance] customerLists].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *cellIndex = @"cellID";
    CustomerTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if(cell == nil)
    {
        cell = [[CustomerTBViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndex];
        [cell buildUI:[[CustomerModel shareInstance].customerLists objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark- end UITableViewDataSource & UITableViewDelegate


#pragma mark- PubDetailHeaderViewDelegate 

-(void)clickControl:(int)ctrlTag
{
    if(ctrlTag == E_Comment_TxtMSG)
    {
    
    }
    else  if(ctrlTag == E_Rate_BtnMSG)
    {
        
    }
    else  if(ctrlTag == E_Heart_BtnMSG)
    {
        
    }
    else  if(ctrlTag == E_Share_BtnMSG)
    {
        
    } 
    
}

#pragma mark- end PubDetailHeaderViewDelegate

// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    refreshFoot.statusLabel.text = @"starting data...";
}
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    [self parserData];
}
// 刷新状态变更就会调用
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    if(state == MJRefreshStateRefreshing)
    {
        refreshFoot.statusLabel.text = @"loading data...";
        [refreshFoot endRefreshing];
    }
}



@end
