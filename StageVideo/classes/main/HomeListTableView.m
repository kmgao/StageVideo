//
//  HomeListTableView.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "HomeListTableView.h"
#import "PublisherEntity.h"
#import "PublisherModel.h"
#import "PublisherTBCell.h"

#import "MJRefreshFooterView.h"

#import "PublisherParser.h"

@interface HomeListTableView()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation HomeListTableView
{
    MJRefreshFooterView *refreshFoot;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataUpdateObserver:) name:Publisher_Data_Update_Notification object:nil];
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //添加上拉加载更多
        refreshFoot = [[MJRefreshFooterView alloc] init];
        refreshFoot.delegate = self;
        refreshFoot.scrollView = self;        
    }
    return self;
}

-(void)dealloc
{
    [refreshFoot free];
}

-(void)addDataUpdateObserver:(NSNotification*)notify
{
    [self reloadData];
}

#pragma mark- UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PublisherModel shareInstance].puberList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublisherTBCell *cell = (PublisherTBCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return [cell getCellContentH];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentify = [NSString stringWithFormat:@"Cell-%d%d",indexPath.section,indexPath.row];
    PublisherTBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if(cell == nil)
    {
        cell = [[PublisherTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        PublisherEntity *entity = [[PublisherModel shareInstance].puberList objectAtIndex:indexPath.row];
        cell.entity = entity;
        [cell buildUI];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.clickCellDelegate && [self.clickCellDelegate respondsToSelector:@selector(clickTableViewCell:)])
    {
        [self.clickCellDelegate clickTableViewCell:indexPath];
    }
}
#pragma  mark- end UITableViewDataSource & UITableViewDelegate

#pragma mark- 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    if (refreshFoot == refreshView)
    {
        
    }
    else
    {
       
    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
}

// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    [self ParserMoreData];
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

-(void)ParserMoreData
{
    BaseParser *p = [[PublisherParser alloc] init];
    [p parser:nil];
}

#pragma  mark- end 代理方法-进入刷新状态就会调用


@end
