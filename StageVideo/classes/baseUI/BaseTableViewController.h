//
//  BaseTableViewController.h
//  ITouchUI
//
//  Created by kmgao on 14-5-5.
//  Copyright (c) 2014年 candy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong) UITableView   *tbView;
@end
