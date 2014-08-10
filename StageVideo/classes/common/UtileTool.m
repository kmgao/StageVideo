//
//  UtileTool.m
//  StageVideo
//
//  Created by kmgao on 14-5-23.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "UtileTool.h"

@implementation UtileTool 

+(NSString*)getAppDirPath
{
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = pathArr[0];
    NSLog(@"cur path = %@",path);
    
    NSString *savePath = [[NSString alloc] initWithFormat:@"%@/DataSave",path];
    if(![[NSFileManager defaultManager ] fileExistsAtPath:savePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"=======cur path = %@",savePath);
    return savePath;
}


+(UIImage*)getConuntryIconWithName:(NSString*)conuntry
{
    NSString *iconName = @"";
    if([conuntry isEqualToString:@"china"])
    {
        iconName = @"Canada.png";
    }
    else if([iconName isEqualToString:@""] || iconName == nil)
    {
        return  nil;
    }
    UIImage *image = [UIImage imageNamed:iconName];
    return  image;
}

@end
