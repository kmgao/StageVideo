//
//  MoreSetViewController.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "MoreSetViewController.h"
#import "PublisherEntity.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "BNaviBarVIew.h"
#import "PublisherModel.h"

#define   kCusotmHeaderH    70
#define   kCusotmHeaderH1   51
#define   kpubHeaderSize    CGSizeMake(48,48)

@interface MoreSetViewController ()<BNaviBarVIewDelegate>
{
    UITableView   *mTableView;
    
    NSArray       *cellInfArray;//image and text dictionary
}

@end

@implementation MoreSetViewController

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
    // Do any additional setup after loading the view.
    
    [[AppDelegate shareAppInstace].appNavi setCanDragBack:YES];
    self.naviBar.delegate = self;
    [self.naviBar setbackgrounImage:@"Main_Navi_Menubarbg.png"];
    [self.view addSubview:self.naviBar];
    
    [self.naviBar setNaviTitle:nil titleColde:nil imgTitle:@"stage_log_title.png"];
    
    
    UIButton *leftBtn = [self.naviBar addNaviButton:@"navigation_back.png" lightBg:nil andImage:nil andTag:0];
    leftBtn.frame = kNaviBarLeftBackFrame;
    leftBtn.tag = 0;
    
    cellInfArray = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Flag_notify.png",@"icon", @"Notifications",@"name", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Favorite.png",@"icon", @"Favorite",@"name", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"history.png",@"icon", @"History",@"name", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Setting_more.png",@"icon",@"Settings",@"name", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Star_Ratings.png",@"icon", @"My Ratings", @"name", nil],
                    nil];
    
//    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//    mTableView.delegate = self;
//    mTableView.dataSource = self;
    
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.pubEntity = [[PublisherModel shareInstance].puberList objectAtIndex:1];
    
}

-(void)clickNaviButton:(BNaviBarView*)navView andIndex:(int)index
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return kCusotmHeaderH;
    }
    return  kCusotmHeaderH1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"cell-item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    
    if(indexPath.row == 0)
    {
        cell.contentView.backgroundColor = kDefaultGrayColor;
        
        CGFloat xx = kScale2x(20),yy = kScale2x(22);

        if(self.pubEntity.imgURL)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, kpubHeaderSize.width, kpubHeaderSize.height)];
            
            if ([self.pubEntity.imgURL hasPrefix:@"http:"] || [self.pubEntity.imgURL hasPrefix:@"https:"])
            {
                NSURL  *imgURL = [[NSURL alloc] initWithString:self.pubEntity.imgURL];
                [UIImageView setDefaultEngine:[AppDelegate shareAppInstace].httpEngine];
                [imgView setImageFromURL:imgURL];
            }
            else
            {
                UIImage *imgHeader = [UIImage imageNamed:self.pubEntity.imgURL];
                imgView.image = imgHeader;
            }
            
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius = kpubHeaderSize.width/2;
            
            [cell.contentView addSubview:imgView];
        }
        
        if(self.pubEntity.puberName)
        {
            xx = kScale2x(132);
            yy = kScale2x(27);
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, kScale2x(200), kScale2x(43))];
            name.text = self.pubEntity.puberName;
            name.backgroundColor = [UIColor clearColor];
            name.textColor = kBlackColor;
            name.font = [UIFont boldSystemFontOfSize:kNormalFontSize];
            name.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:name];
            
            xx += [self.pubEntity.puberName sizeWithFont:name.font].width;
        }
        
        if(self.pubEntity.country)
        {
            xx += 4;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, kScale2x(40), kScale2x(40))];
            if ([self.pubEntity.country hasPrefix:@"http:"] || [self.pubEntity.country hasPrefix:@"https:"])
            {
                NSURL  *imgURL = [[NSURL alloc] initWithString:self.pubEntity.country];
                [UIImageView setDefaultEngine:[AppDelegate shareAppInstace].httpEngine];
                [imgView setImageFromURL:imgURL];
            }
            else
            {
                UIImage *imgHeader = [UtileTool getConuntryIconWithName:self.pubEntity.country];
                imgView.image = imgHeader;
            }
            [cell.contentView addSubview:imgView];
        }
        
    }
    else
    {
        int mIndex = indexPath.row - 1;
        NSDictionary *dic = cellInfArray[mIndex];
        UIImage *iconImg = [UIImage imageNamed:[dic objectForKey:@"icon"]];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImg];
        CGFloat yy = (kCusotmHeaderH1 - iconImg.size.height)/2;
        CGFloat xx = kScale2x(36);
        iconView.frame = CGRectMake(xx, yy, iconImg.size.width, iconImg.size.height);
        [cell.contentView addSubview:iconView];
        
        xx = kScale2x(119);
        
        NSString *mTitle = [dic objectForKey:@"name"];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, kScale2x(200), kScale2x(39))];
        title.text = mTitle;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = kBlackColor;
        title.font = kDefaultFont;
        title.textAlignment = NSTextAlignmentLeft;
        
        [cell.contentView addSubview:title];
        
        UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_line.png"]];
        lineView.frame  = CGRectMake(xx, kCusotmHeaderH1 - 1, IPHONE_SCREEN_WIDTH - xx, 1);
        [cell.contentView addSubview:lineView];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
