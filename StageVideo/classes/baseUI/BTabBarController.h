//
//  CustomTabBarController.h
//  UIVoice
//
//  Created by lab on 13-1-2.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BTabBarController : UITabBarController
{
    NSMutableArray *tabBarBgArray;
}

@property(nonatomic, retain)NSMutableArray *tabBarBgArray;

//- (id)initWithArray:(NSArray*)infoArray;
- (id)initViewUI;
- (void)checkIndexPath:(NSInteger)index;
@end


@interface TabBarBg : UIView
{
    UIImageView *_backgroundView;
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
    BOOL _selected;
}

@property (nonatomic,assign)BOOL selected;
- (TabBarBg*)initWithFrame:(CGRect)frame normalImageName:(NSString*)normalImgName selectedImageName:(NSString*)selectedImgName title:(NSString*)title;
@end