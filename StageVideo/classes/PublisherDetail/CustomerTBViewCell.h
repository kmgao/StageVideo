//
//  CustomerTBViewCell.h
//  StageVideo
//
//  Created by kmgao on 14-5-26.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerEntity;

@interface CustomerTBViewCell : UITableViewCell

-(void)buildUI:(CustomerEntity*)entity;

+(CGFloat)getCellHeight;

@end
