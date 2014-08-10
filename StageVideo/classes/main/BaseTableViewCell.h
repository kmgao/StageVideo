//
//  BaseTableViewCell.h
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

//驱动数据来更新UI,通过子类实现
-(void)buildUI;

-(CGFloat)getCellContentH;

@end
