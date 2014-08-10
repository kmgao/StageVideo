//
//  HomeListTableView.h
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeListTableViewDelegate;

@interface HomeListTableView : UITableView

@property(nonatomic,assign)  id<HomeListTableViewDelegate> clickCellDelegate;
@end


@protocol HomeListTableViewDelegate <NSObject>

@optional

-(void)clickTableViewCell:(NSIndexPath*)indexPath;

@end