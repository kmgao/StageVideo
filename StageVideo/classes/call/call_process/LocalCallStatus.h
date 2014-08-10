//
//  LocalCallStatus.h
//  UIVoice
//
//  Created by lab on 13-4-11.
//  Copyright (c) 2013年 coson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CallPJSIPStatus;
@interface LocalCallStatus : NSObject
{
    CallPJSIPStatus *mCallStatus;
}

- (NSInteger)getCallStatus;
- (void)setCallStatus:(NSInteger)eCallStatus;
@end
