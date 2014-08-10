//
//  MainListViewController.h
//  StageVideo
//
//  Created by kmgao on 14-5-18.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "BaseViewController.h"

typedef enum MainView_List_Type{
    eMainView_List_5Dollar,
    eMainView_List_Freee,
    eMainView_List_7Dollar,
}MainView_List_Type;

@interface MainListViewController : BaseViewController

@property(nonatomic,assign)   int type;

@end
