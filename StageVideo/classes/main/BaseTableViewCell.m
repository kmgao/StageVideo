//
//  BaseTableViewCell.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)getCellContentH;
{
    //must be implement by subclass
    return 0.0;
}

-(void)buildUI
{
    //must be implement by subclass
}

@end
