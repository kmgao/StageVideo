//
//  BaseTableViewController.m
//  ITouchUI
//
//  Created by kmgao on 14-5-5.
//  Copyright (c) 2014年 candy. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
{

}
@end

@implementation BaseTableViewController

@synthesize tbView = _tbView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect tbFrame = CGRectMake(0,NAVIGATION_BAR_HEGITH, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEGITH);
    self.tbView = [[UITableView alloc] initWithFrame:tbFrame];
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//   self.tbView.separatorColor = [UIColor grayColor];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    [self.view addSubview:self.tbView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //subclass must implement
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //subclass must implement
    return nil;
}

@end
