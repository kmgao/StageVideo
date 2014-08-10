

#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/utsname.h>

@interface UIDevice(Private)


@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

//千万不要用这个函数，方颖，13年01月07日，未来要删除
//- (NSString *) uniqueDeviceIdentifier{
//    NSString *macaddress = [[UIDevice currentDevice] macaddress];
//    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
//    
//    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
//    NSString *uniqueIdentifier = [stringToHash stringFromMD5];
//    
//    return uniqueIdentifier;
//}


- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress stringFromMD5];
    
    return uniqueIdentifier;
}
- (NSString *)platformString
{
    NSString *platform = machineName();
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad2 (CDMA)";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])         return @"Simulator";
    
    return platform;
}

NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
/***
 E_NOTVALID_TYPE,
 E_IPHONE_1G,
 E_IPHONE_3G,
 E_IPHONE_3GS,
 E_IPHONE_4,
 E_IPHONE_4S,
 E_IPHONE_5,
 E_IPHONE_5S,
 E_IPOD_TOUCH_1G,
 E_IPOD_TOUCH_2G,
 E_IPOD_TOUCH_3G,
 E_IPOD_TOUCH_4G,
 E_IPAD_1,
 E_IPAD_2_WIFI,
 E_IPAD_2_GSM,
 E_IPAD_2_CDMA,
 E_SIMULATOR
 ***/
-(EDeviceType)getDeviceScreenType
{
    NSString *platform = machineName();
    if ([platform isEqualToString:@"iPhone1,1"])    return E_IPHONE_1G;
    if ([platform isEqualToString:@"iPhone1,2"])    return E_IPHONE_3G;
    if ([platform isEqualToString:@"iPhone2,1"])    return E_IPHONE_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])    return E_IPHONE_4;
    if ([platform isEqualToString:@"iPhone4,1"])    return E_IPHONE_4S;
    if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"])  return E_IPHONE_5;
    if ([platform isEqualToString:@"iPhone5,4"] )    return E_IPHONE_5C;
    if ([platform isEqualToString:@"iPhone6,2"])    return E_IPHONE_5S;
    if ([platform isEqualToString:@"iPod1,1"])      return E_IPOD_TOUCH_1G;
    if ([platform isEqualToString:@"iPod2,1"])      return E_IPOD_TOUCH_2G;
    if ([platform isEqualToString:@"iPod3,1"])      return E_IPOD_TOUCH_3G;
    if ([platform isEqualToString:@"iPod4,1"])      return E_IPOD_TOUCH_4G;
    if ([platform isEqualToString:@"iPad1,1"])      return E_IPAD_1;
    if ([platform isEqualToString:@"iPad2,1"])      return E_IPAD_2_WIFI;
    if ([platform isEqualToString:@"iPad2,2"])      return E_IPAD_2_GSM;
    if ([platform isEqualToString:@"iPad2,3"])      return E_IPAD_2_CDMA;
    if ([platform isEqualToString:@"iPad3,4"])      return E_IPAD_4_WIFI;
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])         return E_SIMULATOR;
    
    return E_NOTVALID_TYPE;
}

- (E_Device_BRIEF_TYPE)getDeviceBriefType{
    E_Device_BRIEF_TYPE briefType = E_DEVICE_BRIEF_INVALIDTYPE;
    NSString *model = [[UIDevice currentDevice] model];
    if([model isEqualToString:@"iPhone"]){
        briefType = E_BRIEF_IPHONE;
    }else if ([model isEqualToString:@"iPod touch"]){
        briefType = E_BRIEF_IPOD;
    }else if([model isEqualToString:@"iPad"]){
        briefType = E_BRIEF_IPAD;
    }
    return briefType;
}
@end
