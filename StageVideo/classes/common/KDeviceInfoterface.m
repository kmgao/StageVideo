
#import <CoreTelephony/CTCallCenter.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>

#import "KDeviceInfoterface.h"

@interface KDeviceInfoterface()
{
    //是否允许开启蓝牙
@public
    BOOL                   m_allowBlueTooth;
}
@end 


@implementation KDeviceInfoterface

enum{
    ESoundUninit,
    ELoundSpeakerSound,//扬声器
    EReceiveSound,//麦克风
    EReceiveSoundWithRecord,//麦克风有录音
    ELoundSpeakWithRecord,//扬声器有录音
}CurrentSoundCate;

static UInt32    curSoundCate = ESoundUninit;

static void AudioSessionRouteChangeListener(void *inClientData, AudioSessionPropertyID	inID,UInt32   inDataSize,const void *inData);

static KDeviceInfoterface *_instance = nil;
+(KDeviceInfoterface*)shareInstance
{
    @synchronized(self)
    {
        if(_instance == nil)
        {
            _instance = [[KDeviceInfoterface alloc] init];
        } 
    }
    return _instance;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(_instance == nil)
        {
            _instance = [super allocWithZone:zone];
        }
        return _instance;
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
}

-(id)init
{
    if(self = [super init])
    {//add your custom code
 
    }
    return self;
}

-(void)install
{  
    [[NetWorkEnv shareInstall] startNetMonitor];
    
    if(isIOS6)
    {
        //路由监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVAudioSessionRouteChangeNotify:) name:AVAudioSessionRouteChangeNotification object:nil];
        // 添加AudioSession中断处理
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVAudioSessionInterruptNotify:) name:AVAudioSessionInterruptionNotification object:nil];
        
        //激活音频声音
         NSError *error = nil;
         BOOL status = [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
         if(!status) NSLog(@"AVAudio Sesstion SetActive error: %@",error);
    }
    else
    {   //路由监听
        AudioSessionInitialize(NULL,NULL,AVAudioSessionInterrupListener,(__bridge void *)(self));
        // 添加AudioSession中断处理
        AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, AudioSessionRouteChangeListener, (__bridge void *)(self));
        
        OSStatus status = AudioSessionSetActiveWithFlags(true,kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
        if(status != kAudioSessionNoError){
            NSLog(@"AudioSessionSetActiveWithFlags setActive error code = %d",(int)status);
        }
    }     
}

+ (CGFloat)getCurrentHardwareVolume
{
    float volume = 0.0;
    if(isIOS6)
    {
        volume = [[AVAudioSession sharedInstance] outputVolume];
    }
    else
    {
        UInt32 dataSize = sizeof(volume);
        AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume, &dataSize,&volume);
    }
    return volume;
}

OSStatus SetVoiceAUQuality(AudioUnit inVoiceUnit, UInt32 inQuality)
{
    if ((inVoiceUnit == NULL) || (inQuality > 127)) return kAudioSessionUnspecifiedError;
    
    OSStatus result = AudioUnitSetProperty(inVoiceUnit, kAUVoiceIOProperty_VoiceProcessingQuality, kAudioUnitScope_Input, 1, &inQuality, sizeof(inQuality));
    if (result) NSLog(@"Error setting voice unit quality: %ld\n", result);
    return result;
}

static void CheckError(OSStatus error,const char *operaton){
    if (error==noErr) {
        return;
    }
    char errorString[20]={};
    *(UInt32 *)(errorString+1)=CFSwapInt32HostToBig(error);
    if (isprint(errorString[1])&&isprint(errorString[2])&&isprint(errorString[3])&&isprint(errorString[4])) {
        errorString[0]=errorString[5]='\'';
        errorString[6]='\0';
    }else{
        sprintf(errorString, "%d",(int)error);
    }
    fprintf(stderr, "Error:%s (%s)\n",operaton,errorString);
}

+(void)initAudioComponent
{
//    AudioStreamBasicDescription mAudioFormat;
    AudioComponentInstance      mAudioUnit;
    
//    Float64 sampleRate;
//    UInt32 sampleRateSize=sizeof(sampleRate);
//    CheckError(AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &sampleRateSize, &sampleRate), "Couldn't get hardware samplerate");
    
//    mAudioFormat.mSampleRate         = sampleRate;
//    mAudioFormat.mFormatID           = kAudioFormatLinearPCM;
//    mAudioFormat.mFormatFlags        = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
//    mAudioFormat.mFramesPerPacket    = 1;
//    mAudioFormat.mChannelsPerFrame   = kChannels;
//    mAudioFormat.mBitsPerChannel     = 16;
//    mAudioFormat.mBytesPerFrame      = mAudioFormat.mBitsPerChannel*mAudioFormat.mChannelsPerFrame/8;
//    mAudioFormat.mBytesPerPacket     = mAudioFormat.mBytesPerFrame*mAudioFormat.mFramesPerPacket;
//    mAudioFormat.mReserved           = 0;
    
    //Obtain a RemoteIO unit instance
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &acd);
    CheckError(AudioComponentInstanceNew(inputComponent, &mAudioUnit), "Couldn't new AudioComponent instance");
    
    //The Remote I/O unit, by default, has output enabled and input disabled
    //Enable input scope of input bus for recording.
    UInt32 enable = 1;
    UInt32 disable=0;
    CheckError(AudioUnitSetProperty(mAudioUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,
                                    1,
                                    &disable,
                                    sizeof(disable)),
               "kAudioOutputUnitProperty_EnableIO::kAudioUnitScope_Input::kInputBus");
    
    CheckError(AudioUnitSetProperty(mAudioUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Output,
                                    0,
                                    &enable,
                                    sizeof(enable)),
               "kAudioUnitProperty_StreamFormat::kAudioUnitScope_Output::kInputBus");
    
    //Disable buffer allocation for recording(optional)
//    CheckError(AudioUnitSetProperty(mAudioUnit,
//                                    kAudioUnitProperty_ShouldAllocateBuffer,
//                                    kAudioUnitScope_Output,
//                                    1,
//                                    &disable,
//                                    sizeof(disable)),
//               "kAudioUnitProperty_ShouldAllocateBuffer::kAudioUnitScope_Output::kInputBus");
    
    //AudioUnitInitialize
    CheckError(AudioUnitInitialize(mAudioUnit), "AudioUnitInitialize");
}


+ (void)UninitAudioPhoneStatus
{
    curSoundCate = ESoundUninit;
}

+ (void)openAudioPhoneRecord
{
    if(curSoundCate == ELoundSpeakWithRecord)
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:YES withInputRecord:YES];
    }
    else if(curSoundCate == EReceiveSoundWithRecord)
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:NO withInputRecord:YES];
    }
    else if(curSoundCate == ELoundSpeakerSound)
    {
         [KDeviceInfoterface setSpeakerPhoneEnabled:YES withInputRecord:YES];
    }
    else
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:NO withInputRecord:YES];
    }
}

+ (void)setCurrentSoundCategory
{
    if(curSoundCate == ELoundSpeakerSound)
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:YES withInputRecord:NO];
    }
    else if(curSoundCate == EReceiveSound)
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:NO withInputRecord:NO];
    }
    else if(curSoundCate == EReceiveSoundWithRecord)
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:NO withInputRecord:YES];
    }
    else if(curSoundCate == ELoundSpeakWithRecord)
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:YES withInputRecord:YES];
    }
    else
    {
        [KDeviceInfoterface setSpeakerPhoneEnabled:NO withInputRecord:YES];
    }
}

+ (void)setSpeakerSoundEnable:(BOOL)speaker
{
    if(!speaker){
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    }  
}

+ (UInt32)getSpeakPhoneCurStatus
{
    return curSoundCate;
}

+ (void)setSoundCategory:(UInt32)category
{
    curSoundCate = category;
    [KDeviceInfoterface setCurrentSoundCategory];
}

+ (void)setSpeakerPhoneEnabled:(BOOL)enable withInputRecord:(BOOL)isRecord
{
    if(enable)
    {
        if(isRecord)
            curSoundCate = ELoundSpeakWithRecord;
        else
            curSoundCate = ELoundSpeakerSound;
    }
    else
    {
        if(isRecord)
        {
            curSoundCate = EReceiveSoundWithRecord;
        }
        else
        {
            curSoundCate = EReceiveSound;
        }
    }
    NSLog(@"========当前电话开启扬声器状态:[%d] 是否带录音状态:[%d]",enable,isRecord);
    if (isIOS6)
    {
        AVAudioSession* session = [AVAudioSession sharedInstance];
        BOOL success;
        NSError* error = nil;
        if (enable)
        {
            if(isRecord)
            {
                if(![session.category isEqualToString:AVAudioSessionCategoryPlayAndRecord] && session.categoryOptions != AVAudioSessionCategoryOptionDefaultToSpeaker)
                {
                    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
                    if (!success)  NSLog(@"AVAudioSession setCategory AVAudioSessionCategoryPlayAndRecord error:%@",error);
                }
             }
            else
            {
                 success = [session setCategory:AVAudioSessionCategoryPlayback  error:&error];
                 if (!success)  NSLog(@"AVAudioSession setCategory error:%@",error);
                //这行代码,是在手机锁屏和静音模式下,声音会被关闭
                if(![session.category isEqualToString:AVAudioSessionCategorySoloAmbient])
                {
                     success =[session setCategory:AVAudioSessionCategorySoloAmbient error:&error];
                     if(!success)  NSLog(@"AVAudioSession setCategory AVAudioSessionCategorySoloAmbient error:%@",error);
                }
            }
            success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
            if (!success)  NSLog(@"AVAudioSession overrideOutputAudioPort AVAudioSessionPortOverrideSpeaker error:%@",error);
        }
        else
        {
//           if(isRecord)
             {
                 if(NO == [session.category isEqualToString:AVAudioSessionCategoryPlayAndRecord])
                 {
                     success = [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
                     if(!success)  NSLog(@"set setCategory AVAudioSessionCategoryPlayAndRecord error = %@ ",error);
                 }
                 else
                 {
                     if(![session.category isEqualToString:AVAudioSessionCategoryPlayAndRecord] && session.categoryOptions != AVAudioSessionCategoryOptionAllowBluetooth)
                     {
                         success = [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
                         if(!success)  NSLog(@"set setCategory AVAudioSessionCategoryPlayAndRecord error = %@ ",error);
                     }
                 }
             }
            success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
            if (!success)  NSLog(@"AVAudioSession overrideOutputAudioPort AVAudioSessionPortOverrideNone error:%@",error);
        }
        
        //激活音频声音
//        BOOL status = [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
//        if(!status) KFLog_Normal(YES, @"AVAudio Sesstion SetActive error: %@",error);
        
        return ;
    }
    
    UInt32 status = -1;
    if(enable)
    {
        UInt32 category = kAudioSessionCategory_MediaPlayback;
        status = AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if(status != kAudioSessionNoError) NSLog(@"AudioSessionSetProperty return status = %d",(int)status);

        if(isRecord)
        {
            category = kAudioSessionCategory_PlayAndRecord;
            status = AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            if(status != kAudioSessionNoError)  NSLog( @"AudioSessionSetProperty return status = %d",(int)status);
        }
        else
        {
            category = kAudioSessionCategory_SoloAmbientSound;
            status = AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            if(status != kAudioSessionNoError) NSLog(@"AudioSessionSetProperty return status = %d",(int)status);
        }
        
        UInt32 doChangeDefaultRoute = 1;//
        status =  AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
        if(status != kAudioSessionNoError)  NSLog(@"AudioSessionSetProperty return status = %d",(int)status);
        
        UInt32 route;
        route = kAudioSessionOverrideAudioRoute_Speaker;
        status = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
        if(status != kAudioSessionNoError)  NSLog(@"AudioSessionSetProperty return status = %d",(int)status);
    }
    else{
        
        //设置类别
//        if(isRecord)
        {
            UInt32 category = kAudioSessionCategory_PlayAndRecord;
            status = AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            if(status != kAudioSessionNoError) NSLog( @"AudioSessionSetProperty return status = %d",(int)status);
        }
        
        //开启蓝牙设备
        UInt32 enableBlueTooth = 1;
        status = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryEnableBluetoothInput, sizeof(enableBlueTooth), &enableBlueTooth);
        if(status != kAudioSessionNoError)  NSLog(@"AudioSessionSetProperty return status = %d",(int)status);
        
        //蓝牙输入路由
        CFStringRef bluetoothSessionInput = kAudioSessionInputRoute_BluetoothHFP;
        status = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(bluetoothSessionInput), &bluetoothSessionInput);
        if(status != kAudioSessionNoError)
            NSLog( @"蓝牙输入路由失败:Retrurn error Code = %d",(int)status);
        
        //蓝牙输出路由
        CFStringRef bluetoothSessionOutput = kAudioSessionOutputRoute_BluetoothHFP;
        status = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(bluetoothSessionOutput), &bluetoothSessionOutput);
        if(status != kAudioSessionNoError)
            NSLog( @"蓝牙输出路由失败:Retrurn error Code = %d",(int)status);
        
        UInt32 route;
        route = kAudioSessionOverrideAudioRoute_None;
        status = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
        if(status != kAudioSessionNoError)  NSLog(@"AudioSessionSetProperty return status = %d",(int)status);
    }
    
    status = AudioSessionSetActiveWithFlags(YES, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
    if(status != kAudioSessionNoError)  NSLog(@"AudioSessionSetActiveWithFlags Faild return status = %d",(int)status);
    
/**********************
    // add by suruochang @2013.10.11
    UInt32 size = sizeof(CFStringRef);
    CFStringRef route0=NULL;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &route0);
    
    //routeStr = @"SpeakerAndMicrophone"
    NSString *routeStr = (NSString *)route0;
    if ([routeStr isEqualToString:@"SpeakerAndMicrophone"] && enable) {
        return;
    }
    
    UInt32 route;
    route = (enable ? kAudioSessionOverrideAudioRoute_Speaker :
             kAudioSessionOverrideAudioRoute_None);
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof(route), &route);
 *****************/
}

 //强迫中止其它后台声音会话
+(BOOL)forceInterruptOtherAudioSession
{
    if(isIOS6)
    {
        NSError *infoErr = nil;
        BOOL status = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&infoErr];//AVAudioSessionCategoryPlayback
        if(!status) NSLog(@"error = %@",infoErr);
        
        //不加这一行代码，音频直接外放杨声器
//      [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeVoiceChat error:nil];
        
        status = [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&infoErr];
        if(!status) NSLog(@"error information = %@",infoErr);
        
        status = [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&infoErr];
        if(!status) NSLog( @"error = %@",infoErr);
        
        return status;
    }
    else
    {
        OSStatus status;
        
        UInt32  audioCategory = kAudioSessionCategory_MediaPlayback;
        status = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
        if(!status) NSLog(@"AudioSessionSetProperty return Status=%d",(int)status);
        
        UInt32 routeType = kAudioSessionOverrideAudioRoute_Speaker;
        status = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(routeType), &routeType);
        if(!status) NSLog(@"AudioSessionSetProperty return Status=%d",(int)status);
        
        status = AudioSessionSetActiveWithFlags(YES, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
        if(!status) NSLog(@"AudioSessionSetActiveWithFlags return Status=%d",(int)status);
        
        return status == kAudioSessionNoError;
    }
}

//恢复中止的其它后台音频会话
+(BOOL)resumInterruptOtherAudioSession;
{
    return  YES;
}
 
//音频中断处理通知
-(void)AVAudioSessionInterruptNotify:(NSNotification*)notify
{
    NSDictionary *usrInfo = notify.userInfo;
    if(usrInfo != nil)
    {
        int curInterruptType = [[usrInfo objectForKey:AVAudioSessionInterruptionOptionKey] intValue];
        if(curInterruptType == AVAudioSessionInterruptionOptionShouldResume)
        {
            NSLog( @"当前音频中断可以恢复");
        }
        else
        {
            NSLog( @"========当前音频中断不可以恢复==========");
        }
        NSNumber *interrupStatus = [usrInfo objectForKey:AVAudioSessionInterruptionTypeKey];
        if(interrupStatus)
        {
            int status = [interrupStatus intValue];
            if(status == AVAudioSessionInterruptionTypeBegan)
            {//中断开始
                NSLog( @"......音频会话中断开始.......");
                [[NSNotificationCenter defaultCenter] postNotificationName:kAVAudioSessionInterruptionNotification object:nil];
            }
            else if(status == AVAudioSessionInterruptionTypeEnded)
            {//中断结束
                [[NSNotificationCenter defaultCenter] postNotificationName:kAVAudioSessionInterruptionNotification_End object:nil];
                NSLog( @"音频会话中断结束,重新激活音频会话");
                NSError *error = nil;
                
                BOOL status = [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
                if(!status) NSLog(@"音频会话激活失败>>ErrorInfo = %@",error);
                
                status = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
                if(!status) NSLog(@"=====音频会话类别失败>>ErrorInfo = %@",error);

                status = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
                if(!status) NSLog( @"=====音频会话类别失败>>ErrorInfo = %@",error);
            }
        }
    }
    
}

//音频中断监听器
void AVAudioSessionInterrupListener(void * inClientData, UInt32  inInterruptionState)
{
//    KDeviceInfoterface *ptrSelf = (KDeviceInfoterface*)inClientData;
    
    UInt32 curInterruptType = 0;
    UInt32 typeSize = sizeof(curInterruptType);
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_InterruptionType, &typeSize, &curInterruptType);
    if(status == kAudioSessionNoError)
    {
        if(curInterruptType == kAudioSessionInterruptionType_ShouldResume)
        {//当前中断可以恢复
            
        }
        else if(curInterruptType == kAudioSessionInterruptionType_ShouldNotResume)
        {//当前中断不能恢复
           
        }
    }

    if(inInterruptionState == kAudioSessionBeginInterruption)
    {//音频会话中断开始
        NSLog(@"......音频会话中断开始.......");
        [[NSNotificationCenter defaultCenter] postNotificationName:kAVAudioSessionInterruptionNotification object:nil];
    }
    else if(inInterruptionState == kAudioSessionEndInterruption)
    {//音频会话中断结束,重新激活音频会话
        NSLog(@"音频会话中断结束,重新激活音频会话");
        [[NSNotificationCenter defaultCenter] postNotificationName:kAVAudioSessionInterruptionNotification_End object:nil];
        OSStatus activeCode = AudioSessionSetActiveWithFlags(YES, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
        if(activeCode != kAudioSessionNoError)
        {
            NSLog(@"重新激活音频会话失败");
        }
        
        UInt32  category = kAudioSessionCategory_MediaPlayback;
        OSStatus statusCode = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if(statusCode != kAudioSessionNoError)
            NSLog(@"设置音频类别失败>>Error return Code = %d",(int)statusCode);
        
        category = kAudioSessionCategory_PlayAndRecord;
        statusCode = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if(statusCode != kAudioSessionNoError)
            NSLog(@"设置音频类别失败>>Error return Code = %d",(int)statusCode);
 
    }
}

/**=============AVAudioSessionPortDescription PortType 相对就的常量字符串值=================
AVAudioSessionPortLineIn = "LineIn"
AVAudioSessionPortBuiltInMic="MicrophoneBuiltIn" //内置麦克风
AVAudioSessionPortHeadsetMic="MicrophoneWired" //有线麦克风
AVAudioSessionPortLineOut="LineOut"
AVAudioSessionPortHeadphones="Headphones"//耳机
AVAudioSessionPortBluetoothA2DP="BluetoothA2DPOutput"
AVAudioSessionPortBuiltInReceiver = "Receiver" //内置接收器
AVAudioSessionPortBuiltInSpeaker = "Speaker"//内置扬声器
AVAudioSessionPortHDMI = "HDMIOutput"//HDMI输出
AVAudioSessionPortAirPlay="AirPlay"
AVAudioSessionPortBluetoothLE="BluetoothLE"//蓝牙LE
AVAudioSessionPortBluetoothHFP = "BluetoothHFP"//蓝牙HFP
===========================================================================================****/

//主要通过 这个 AVAudioSessionPortDescription 中Type 的属性值
//来表现，当前手机是处于内置麦克风，有线麦克风,还是杨声器，还是处于蓝牙开关
//AVAudioSessionPortDescription 输入源
//type 值有 [MicrophoneBuiltIn(耳麦),BluetoothHFP(蓝牙)]
//AVAudioSessionPortDescription 输出源
//type 值有 [Speaker(杨声器),Receiver]
/******可以通过打印出找出你想的 跟蓝牙有关的音频路由****/

-(void)AVAudioSessionRouteChangeNotify:(NSNotification*)notify
{
    id obj = notify.object;
    NSDictionary *infoDic = [notify userInfo];
    NSLog(@"Notifycation.object = %@",obj);
    NSLog(@"Notifycation.userInfo = %@\n",infoDic);
    
    if(nil != infoDic)
    {
        AVAudioSessionRouteChangeReason catValue = [[infoDic objectForKey:AVAudioSessionRouteChangeReasonKey] intValue];
        if(catValue == AVAudioSessionRouteChangeReasonCategoryChange)
        {//音频路由改变
            NSLog(@"=========音频路由改变=========");
        }
        else if(catValue == AVAudioSessionRouteChangeReasonOverride)
        {//音频路由被覆盖
             NSLog( @"=========音频路由被覆盖=========");
        }
        else if(catValue == AVAudioSessionRouteChangeReasonWakeFromSleep)
        {//音频路由从休眠中被唤醒
            NSLog( @"=========音频路由从休眠中被唤醒=========");
        }
        else if(catValue == AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory)
        {//未找到适合当前类别的
            NSLog( @"=========未找到适合当前类别的=========");
        }
        else if(catValue == AVAudioSessionRouteChangeReasonNewDeviceAvailable)
        {//路由改变新设备无效
            NSLog( @"=========路由改变新设备无效=========");
        }
        else if(catValue == AVAudioSessionRouteChangeReasonOldDeviceUnavailable)
        {//路由改变老设备无效
            NSLog( @"=========路由改变老设备无效=========");
        }
        else if(catValue == AVAudioSessionRouteChangeReasonUnknown)
        {
            NSLog(@"=========未知原因=========");
        }
    }
    
    if(obj && [obj isKindOfClass:[AVAudioSession class]])
    {
        AVAudioSession *curSession = (AVAudioSession*)obj;
        //取得当前处于的音频路由
        AVAudioSessionRouteDescription *sessionDes = [curSession currentRoute];
        NSLog(@"current  AVAudioSessionRouteDescription Category = %@,categoryOptions = %d",[curSession category],(int)[curSession categoryOptions]);
        NSLog(@"current AVAudioSessionRouteDescription inputs= %@~~\r\n output = %@", sessionDes.inputs,sessionDes.outputs);
        
        AVAudioSessionCategoryOptions catOption = [curSession categoryOptions];
        if(catOption == AVAudioSessionCategoryOptionAllowBluetooth)
        {//显示蓝牙button
            AVAudioSessionRouteDescription *sessionRoute = [curSession currentRoute];
            if(sessionRoute.inputs != nil)
            {
                AVAudioSessionPortDescription *inPort = [sessionRoute inputs][0];
                NSLog( @"当前音频会话输入端口类别:%@",[inPort portType]);
                if(inPort && [inPort portType] == AVAudioSessionPortBluetoothHFP)
                {
//                     [[NSNotificationCenter defaultCenter] postNotificationName:kEnableBlueTooth object:nil];
                }
                else if(inPort && isIOS7 && [inPort portType] == AVAudioSessionPortBluetoothLE)
                {
//                     [[NSNotificationCenter defaultCenter] postNotificationName:kEnableBlueTooth object:nil];
                }
            }
            else if(sessionRoute.outputs != nil)
            {
                AVAudioSessionPortDescription *outPort = [sessionRoute outputs][0];
                NSLog(@"====当前音频会话输出端口类别:%@",[outPort portType]);
                if(outPort && [outPort portType] == AVAudioSessionPortBluetoothHFP)
                {
//                     [[NSNotificationCenter defaultCenter] postNotificationName:kEnableBlueTooth object:nil];
                }
                else if(outPort && isIOS7 && [outPort portType] == AVAudioSessionPortBluetoothLE)
                {
//                     [[NSNotificationCenter defaultCenter] postNotificationName:kEnableBlueTooth object:nil];
                }
            }
        }
        else
        {
//             [[NSNotificationCenter defaultCenter] postNotificationName:kDisableBlueTooth object:nil];
        }
  }
}

static void  AudioSessionRouteChangeListener(void *inClientData, AudioSessionPropertyID	inID, UInt32   inDataSize, const void *inData)
{
 
    CFDictionaryRef curRoute = NULL;
    UInt32 properySize = 0;
    AudioSessionGetPropertySize(kAudioSessionProperty_AudioRouteDescription, &properySize);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &properySize, &curRoute);
    if(curRoute != NULL)
    {
//        KDeviceInfoterface  *device = (KDeviceInfoterface*)inClientData;
        //kAudioSession_AudioRouteKey_Inputs = "RouteDetailedDescription_Inputs"
        CFStringRef inRoutKey = kAudioSession_AudioRouteKey_Inputs;
        //kAudioSession_AudioRouteKey_Outputs="RouteDetailedDescription_Outputs"
        CFStringRef ouRoutKey = kAudioSession_AudioRouteKey_Outputs;
        
        CFArrayRef inRoutArray = (CFArrayRef)CFDictionaryGetValue(curRoute,inRoutKey);
        CFArrayRef ouRoutArray = (CFArrayRef)CFDictionaryGetValue(curRoute,ouRoutKey);
        
        if(NULL != inRoutArray)
        {
            CFDictionaryRef firstDic = (CFDictionaryRef)CFArrayGetValueAtIndex(inRoutArray,0);
            if(firstDic != NULL)
            {
                //kAudioSession_AudioRouteKey_Type = "RouteDetailedDescription_PortType"
                CFStringRef key = kAudioSession_AudioRouteKey_Type;
                CFStringRef portType = CFDictionaryGetValue(firstDic, key);
                //kAudioSessionInputRoute_BluetoothHFP = "MicrophoneBluetooth"
                if(CFEqual(portType,kAudioSessionInputRoute_BluetoothHFP))
                {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kEnableBlueTooth object:nil];
                }
            }
        }
        else if(ouRoutArray != nil)
        {
            CFDictionaryRef firstDic = (CFDictionaryRef)CFArrayGetValueAtIndex(ouRoutArray,0);
            if(firstDic != NULL)
            {
                //kAudioSession_AudioRouteKey_Type = "RouteDetailedDescription_PortType"
                CFStringRef key = kAudioSession_AudioRouteKey_Type;
                CFStringRef portType = CFDictionaryGetValue(firstDic, key);
                //kAudioSessionOutputRoute_BluetoothHFP = "BluetoothHFPOutput"
                if(CFEqual(portType,kAudioSessionOutputRoute_BluetoothHFP))
                {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kEnableBlueTooth object:nil];
                }
            }
        }
        
//        if(device->m_allowBlueTooth == NO)
//        {//蓝牙没有连接
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBlueTooth" object:nil];
//        }
        
     }
}

+(void)setActiveAudioSession:(BOOL)active
{
    if(isIOS6)
    {
        NSError *error = nil;
        BOOL status = [[AVAudioSession sharedInstance] setActive:active withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if(!status) NSLog(@"AVAudioSession setActive Faild>error:%@",error);
    }
    else
    {
        OSStatus status = AudioSessionSetActiveWithFlags(active, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
        if(status != kAudioSessionNoError) NSLog( @"AudioSessionSetActiveWithFlags faild!~~~~~:Reason=%d",(int)status);
    }
}


+(BOOL)blueToothIsConnected
{
    UInt32 nsize = sizeof(CFStringRef);
    CFStringRef route = NULL;
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &nsize, &route);
    NSLog(@"==========当前蓝牙名字===========:%@",route);
    NSString  *blueToothName =  (__bridge NSString*)route;   //"HeadsetBT"
    if(status == kAudioSessionNoError && ([blueToothName isEqualToString:@"HeadsetBT"]))
    {
        return YES;
    }
    return NO;
}


/******让手机震动****/
+(void)vibrateDevice
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


+(BOOL)otherSoundPlaying
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
       AVAudioSession *session = [AVAudioSession sharedInstance];
//       NSLog(@"other sound is playing:%d",(int)session.otherAudioPlaying);
       return  session.otherAudioPlaying;
    }
    UInt32  isPlaying = 0;
    UInt32 nsize = sizeof(isPlaying);
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &nsize, &isPlaying);
    if(status == kAudioSessionNoError && isPlaying)
        return YES;
    else
        return NO;
}

@end
