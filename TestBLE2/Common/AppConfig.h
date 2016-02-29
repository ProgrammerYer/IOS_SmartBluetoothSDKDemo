//
//  AppConfig.h
//  MyKcal
//
//  Created by  mac on 11-8-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMBData.h"
#import "NSDate+Helper.h"
#import "AppDelegate.h"
#import "UIView+Helper.h"
#import "NSStringWrapper.h"
#import "UIColor-Expanded.h"


//debug
#define CustomErrorDomain @"zengge.com"
#define DebugLog(log, ...)  NSLog(log, ## __VA_ARGS__)
//#define DebugLog(log, ...)
#define DebugLogT(log, ...) NSLog(log, ## __VA_ARGS__) 

//#define SERVER_UPD_PORT  48899
#define NotificationLEDControlsVCtrBasePowerChanged   @"NotificationLEDControlsVCtrBasePowerChanged"

#define MAX_Connection  5

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


#ifdef VER_ChiChin
    #define AppForChiChin YES
#else
    #define AppForChiChin NO
#endif

#define APP_WEB_ADDR @"http://magichue.net/webble/Service/ZJ001.ashx"
#define APP_WEB_ShareURL @"http://magichue.net/webble/a/"

#ifdef VER_BluetoothLigthDark

    //内容
    #define AppGroupIdentifier @"group.com.Zhengji.BluetoothLigthDark"
    #define AppForFlux YES
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES    //BLE 4.5W 自定义功能效果不好会屏蔽掉

#elif defined(VER_BLEVividliteDark)

    #define AppGroupIdentifier @"group.com.vividlite.BLEVividliteDark"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_Flux)

    #define AppGroupIdentifier @"group.com.flux.LEDBLEv2Flux" //待处理
    #define AppForFlux YES
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_SmartFx)

    #define AppGroupIdentifier @"group.com.Zengge.LEDBLESmartFx"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_Novaldo)

    #define AppGroupIdentifier @"group.com.Novaldo.LedBLEv2"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_LumiskyLEDV2)

    #define AppGroupIdentifier @"group.BATIMEX.LumiskyLEDV2"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES


#elif defined(VER_ChiChin)

    #define AppGroupIdentifier @"group.chichin.LedBLEChichin"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_SuperLegend)

    #define AppGroupIdentifier @"group.SuperLegend.SuperBluetoothBulb"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_GVeseel)

    #define AppGroupIdentifier @"group.com.veseel.LEDBLEv2FluxGV"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_Myoung)

    #define AppGroupIdentifier @"group.com.myoung.LEDBLEv2"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE YES

#elif defined(VER_Rayn)

    #define AppGroupIdentifier @"group.com.Ryan.LEDBLEv2"
    #define AppForFlux NO
    #define AppForRyanSchultze YES
    #define NeedHideCustomFunForBLE YES


#else

    //内容
    #define AppGroupIdentifier @"group.com.Zhengji.LedBLEv2"
    #define AppForFlux NO
    #define AppForRyanSchultze NO
    #define NeedHideCustomFunForBLE NO

#endif

//iOS开发之主题皮肤 http://blog.csdn.net/yanghua_kobe/article/details/9555575
//暂时不用,以后参考
#ifdef VER_Style_BlackDark

    //内容
    #define ContentBgColor [UIColor colorWithHexStringAndroid:@"FF2f2f2f"]
    #define ContentListBgColor [UIColor colorWithHexStringAndroid:@"FF2f2f2f"]
    #define ContentListRowBgColor [UIColor colorWithHexStringAndroid:@"FF262626"]   //比上面加一个层次

    #define ContentFontColor [UIColor colorWithHexStringAndroid:@"ffcccccc"]
    #define ContentFontDarkColor [UIColor colorWithHexStringAndroid:@"ffdddddd"]
    #define ContentDetailColor [UIColor colorWithHexStringAndroid:@"ffaaaaaa"]
    #define ContentFontLightColor [UIColor colorWithHexStringAndroid:@"ff5BBD2B"]
    #define ContentShadowColor [UIColor colorWithHexStringAndroid:@"FF000000"]

    //<!-- 头部 -->
    #define HeaderBg [UIColor colorWithHexStringAndroid:@"ff141414"]  //Android=050505
    #define HeaderFontColor [UIColor colorWithHexStringAndroid:@"ffcccccc"]
    #define HeaderFontDarkColor [UIColor colorWithHexStringAndroid:@"FFdddddd"]
    #define HearderShadowColor [UIColor colorWithHexStringAndroid:@"FF000000"]


    //底部 -->
    #define BottomBgColor [UIColor colorWithHexStringAndroid :@"ff141414"]  //Android=050505
    #define BottomFontColor [UIColor colorWithHexStringAndroid:@"ffcccccc"]   //
    #define BottomShadowColor [UIColor colorWithHexStringAndroid:@"FF000000"]

    #define BottomFontDarkColor [UIColor colorWithHexStringAndroid:@"ffdddddd"]
    #define BottomFontTab [UIColor colorWithHexStringAndroid:@"ffcccccc"]


    //<!-- 分割线 -->
    #define LineDivider [UIColor colorWithHexStringAndroid:@"FF686868"]
    #define LineDividerTabHost [UIColor colorWithHexStringAndroid:@"ff545353"]
    #define LineLightDivider [UIColor colorWithHexStringAndroid:@"ff5BBD2B"]   //亮色的


    //button
    #define ButtonBg [UIColor colorWithHexStringAndroid:@"ff686868"]
    #define ButtonFontColor [UIColor colorWithHexStringAndroid:@"ffcccccc"]
    #define ButtonFontLightColor [UIColor colorWithHexStringAndroid:@"ff5BBD2B"]

    //pupo弹出框样式
    #define PopupMaskBg [UIColor colorWithHexStringAndroid:@"B2000000"]
    #define PopupBorder [UIColor colorWithHexStringAndroid:@"FF808080"]
    #define PopupContentBg [UIColor colorWithHexStringAndroid:@"FF2f2f2f"]

    //其他样式
    #define WeekFontOnColor [UIColor colorWithHexStringAndroid:@"ffdddddd"]    //ff000000
    #define WeekFontOFFColor [UIColor colorWithHexStringAndroid:@"ff525252"]   //ff6c6c6c
    #define Style_DatePickerBg [UIColor colorWithHexStringAndroid:@"FFb1b1b1"] 

    #define Style_ShowBgImageForCustomColor NO
    #define Style_IsBlackDark YES
    //注意勾选图片文件加编译包含的内容

#else

    //内容
    #define ContentBgColor [UIColor colorWithHexStringAndroid:@"FFffffff"]       //Android=FFffffff
    #define ContentListBgColor [UIColor colorWithHexStringAndroid:@"FFefeff4"]      //列表背景颜色(Timer用到)
    #define ContentListRowBgColor [UIColor colorWithHexStringAndroid:@"FFffffff"]   //比上面加一个层次

    #define ContentFontColor [UIColor colorWithHexStringAndroid:@"ff363636"]
    #define ContentFontDarkColor [UIColor colorWithHexStringAndroid:@"ff000000"]
    #define ContentDetailColor [UIColor colorWithHexStringAndroid:@"ff7a7a7a"]
    #define ContentFontLightColor [UIColor colorWithHexStringAndroid:@"ff23a1ee"]     //亮色的
    #define ContentShadowColor [UIColor colorWithHexStringAndroid:@"FFffffff"]

    //<!-- 头部 -->
    #define HeaderBg [UIColor colorWithHexStringAndroid:@"FFF2F5FA"]  //Android=FFf7f8fb
    #define HeaderFontColor [UIColor colorWithHexStringAndroid:@"FF363636"]
    #define HeaderFontDarkColor [UIColor colorWithHexStringAndroid:@"FF000000"]
    #define HearderShadowColor [UIColor colorWithHexStringAndroid:@"FFFFFFFF"]


    //底部 -->
    #define BottomBgColor [UIColor colorWithHexStringAndroid :@"ffF7F8FB"]  //Android=FFf7f8fb
    #define BottomFontColor [UIColor colorWithHexStringAndroid:@"ff363636"]   //
    #define BottomShadowColor [UIColor colorWithHexStringAndroid:@"FFffffff"]

    #define BottomFontDarkColor [UIColor colorWithHexStringAndroid:@"ff000000"]
    #define BottomFontTab [UIColor colorWithHexStringAndroid:@"ff7a7a7a"]


    //<!-- 分割线 -->
    #define LineDivider [UIColor colorWithHexStringAndroid:@"FFd9dce3"]
    #define LineDividerTabHost [UIColor colorWithHexStringAndroid:@"FFefeff4"]
    #define LineLightDivider [UIColor colorWithHexStringAndroid:@"FF23a1ee"]   //亮色的


    //button
    #define ButtonBg [UIColor colorWithHexStringAndroid:@"ffE4E6E8"]
    #define ButtonFontColor [UIColor colorWithHexStringAndroid:@"FF363636"]
    #define ButtonFontLightColor [UIColor colorWithHexStringAndroid:@"FF23a1ee"]  //亮色的

    //pupo弹出框样式
    #define PopupMaskBg [UIColor colorWithHexStringAndroid:@"B2000000"]
    #define PopupBorder [UIColor colorWithHexStringAndroid:@"FF808080"]
    #define PopupContentBg [UIColor colorWithHexStringAndroid:@"FFffffff"]

    //其他样式
    #define WeekFontOnColor [UIColor colorWithHexStringAndroid:@"FF000000"]    //ff000000
    #define WeekFontOFFColor [UIColor colorWithHexStringAndroid:@"FFc3c3c3"]   //ff6c6c6c
    #define Style_DatePickerBg [UIColor colorWithHexStringAndroid:@"FFffffff"]

    #define Style_ShowBgImageForCustomColor YES
    #define Style_IsBlackDark NO
    //注意勾选图片文件加编译包含的内容

#endif



typedef NS_ENUM(NSInteger, LEDDeviceType) {
    LED_Undown = 0,
    LED_RGB = 3,
    LED_Brightness = 1,    //单色  01旧版单色、（11、21新版单色）
    LED_RGB_W =4,
    LED_Color_temperature_CCT = 12,  //双色,   设备号02、12 可以同时亮
    LED_Color_temperature_Bulb = 22,  //双色,不全亮
    LED_RGB_W2 =14,    //不全亮,灯泡
    LED_RGB_Bulb_New =15,    //不全亮,灯泡
    LED_Color_temperature_Bulb_New = 32,  //双色,不全亮
    LED_RGB_Bulb_WithSunn =34,    //setDeviceType:LED_RGB_Bulb_WithSunn   buff[1]==0x34
    LED_RGBW_UFO =44,    //setDeviceType:LED_RGB_Bulb_WithSunn   buff[1]==0x34
    LED_RGB_HighVoltage = 13
};

typedef enum  {
    LEDRunMode_gradual = 0,   //漸變
    LEDRunMode_FLASH = 1,     //頻閃
    LEDRunMode_NONE = 2,
    LEDRunMode_jump = 3       //跳變
} LEDRunModeType;


typedef enum  {
    LEDColorTempMode_warm_gradual = 0,
    LEDColorTempMode_cool_gradual = 1,
    LEDColorTempMode_warm_flash = 2,
    LEDColorTempMode_cool_flash = 3,
    LEDColorTempMode_NONE = -1
} LEDColorTempModeType;



@interface AppConfig : NSObject {
    
}

//判断是否有网络
+(BOOL)connectedToNetWork;

+(NSString *)createUUID;


+(float)getIOSVersion;

+(BOOL)checkIsConSmartModleName:(NSString*)name;

+(NSString*)getAppDisplayName;
+(NSString*)getAppVersionString;
+(NSString*)getBuildVersionString;
+(BOOL)checkIsBLEModleByName:(NSString*)name;

+(float)countValueFromRangeMin:(float)minFrom  maxFrom:(float)maxFrom
                         minTo:(float)minTo maxTo:(float)maxTo
                  withOgrValue:(float)orgValue;

+(int)getRandomNumber:(int)from to:(int)to;
@end
