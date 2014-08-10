 
/****************主要完成功能是系统接口的调用*******************/

#import <Foundation/Foundation.h> 
#import "NetWorkEnv.h"

/******音频中断处理通知key*********/
#define kAVAudioSessionInterruptionNotification       @"KAVAudioSessionInterruptionNotification"
#define kAVAudioSessionInterruptionNotification_End   @"KAVAudioSessionInterruptionNotification_End"

@interface KDeviceInfoterface : NSObject
 
+(KDeviceInfoterface*)shareInstance;

-(void)install;

/************音频与蓝牙设备接口****************/

/** 切换听筒和扬声器 */
+ (void)setCurrentSoundCategory;
+ (void)setSpeakerPhoneEnabled:(BOOL)enable withInputRecord:(BOOL)isRecord;
+ (UInt32)getSpeakPhoneCurStatus;
+ (void)setSoundCategory:(UInt32)category;
+ (void)UninitAudioPhoneStatus;
+ (void)setSpeakerSoundEnable:(BOOL)speaker;
//打开录音功能
+ (void)openAudioPhoneRecord;

/*******获取到设备音量************/
+ (CGFloat)getCurrentHardwareVolume;

/******让手机震动****/
+(void)vibrateDevice; 

//强迫中止其它后台声音会话
+(BOOL)forceInterruptOtherAudioSession;
//恢复中止的其它后台音频会话
+(BOOL)resumInterruptOtherAudioSession;
//蓝牙是否已经连接
+(BOOL)blueToothIsConnected;
+(void)setActiveAudioSession:(BOOL)active;
/*其它声音是否正在播放,调用之前,必须把声音激活,调用setActive*/
+(BOOL)otherSoundPlaying;
//初始化音频组件
+(void)initAudioComponent;

@end
