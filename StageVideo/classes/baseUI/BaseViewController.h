//
//  BaseViewController.h
//  ITouchUI
//
//  Created by candy on 14-5-3.
//  Copyright (c) 2014年 candy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNaviBarView;

#define kNaviBarLeftBackFrame  CGRectMake(kScale2x(25), kScale2x(64), kScale2x(18), kScale2x(35))

@interface BaseViewController : UIViewController 

@property(nonatomic,strong) BNaviBarView   *naviBar;


-(void)setNaviBarTitle:(NSString*)title;
-(void)setNaviBarBg:(NSString*)bgName;
-(void)setNaviBarBack:(NSString*)imgName;


-(UIBarButtonItem*)addLeftButtonItem:(NSString*)strName isImgBtn:(BOOL)imagBtn;
-(UIBarButtonItem*)addRightButtonItem:(NSString*)strName isImgBtn:(BOOL)imagBtn;

-(void)handlLeftButton:(id)sender;
-(void)handlRightButton:(id)sender;

-(void)setBgImageView:(NSString*)imagePath;

-(void)setNavibarHide:(BOOL)hide animation:(BOOL)animation;


@end
