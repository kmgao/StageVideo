//
//  MainListViewController.m
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "MainListViewController.h" 

@interface MainListViewController ()

@end

@implementation MainListViewController

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
    
    if(self.type == eMainView_List_5Dollar){
        self.title = @"$5";
    }
    else if(self.type == eMainView_List_Freee){
        self.title = @"Free";
    }
    else if(self.type == eMainView_List_7Dollar){
        self.title = @"$7";
    } 

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
