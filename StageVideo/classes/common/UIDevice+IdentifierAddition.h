
#import <Foundation/Foundation.h>

typedef enum tagEDeviceType
{
    E_NOTVALID_TYPE,
    E_IPHONE_1G,
    E_IPHONE_3G,
    E_IPHONE_3GS,
    E_IPHONE_4,
    E_IPHONE_4S,
    E_IPHONE_5,
    E_IPHONE_5C,
    E_IPHONE_5S,
    E_IPOD_TOUCH_1G,
    E_IPOD_TOUCH_2G,
    E_IPOD_TOUCH_3G,
    E_IPOD_TOUCH_4G,
    E_IPAD_1,
    E_IPAD_2_WIFI,
    E_IPAD_2_GSM,
    E_IPAD_2_CDMA,
    E_IPAD_4_WIFI,
    E_SIMULATOR
}EDeviceType;

typedef enum {
    E_BRIEF_IPHONE = 0,
    E_BRIEF_IPOD,
    E_BRIEF_IPAD,
    E_BRIEF_SIMULATOR,
    
    E_DEVICE_BRIEF_INVALIDTYPE,
}E_Device_BRIEF_TYPE;

@interface UIDevice (IdentifierAddition)

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

//- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

- (NSString *) macaddress;

- (NSString *)platformString;

//type:@see enum EDeviceType
-(EDeviceType)getDeviceScreenType;
-(E_Device_BRIEF_TYPE)getDeviceBriefType;
@end
