//
//  BrightnessInfoReciveCMD.m
//  LedWifi
//
//  Created by luoke on 12-12-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RGBDeviceCMDMgr.h"
#import "RGBDeviceStateInfo.h"
#import "UIColor-Expanded.h"
#import "RGB_WDeviceStateInfo.h"
#import "DeviceStateInfoBase.h"
#import "TimerDetailItem.h"
#import "CustomMode.h"

@implementation RGBDeviceCMDMgr

//【0X66】+【8bit设备名(0x03)】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit红色数据】＋【8bit绿色数据】＋【8bit蓝色数据】+【0X00】+【0X00】＋【0X99】
+(RGBDeviceStateInfo*)getRGBDeviceStateInfoByData:(NSData*)data
{
    RGBDeviceStateInfo *dev = nil;
    
    Byte *buff = (Byte*)[data bytes];
    if (buff[0] == 0x66 && buff[11]==0x99
        //&&(buff[1] == 0x02 || buff[1] == 0x03)
        )
    {
        dev = [[RGBDeviceStateInfo alloc] init];
        if (buff[2]==0x23) {
            [dev setIsOpen:YES];
        }
        else {
            [dev setIsOpen:NO];
        }
        
        //【8bit模式值】定義：
        [dev setModeValue:buff[3]];
        
        
        if (buff[4]==0x21) {
            [dev setIsRunning:YES];
        }
        else {
            [dev setIsRunning:NO];
        }
        
        //【8bit速度值】定義：0x01--0x1F   (0~31)
        [dev setSpeed:32-buff[5]];
        
        //【8bit灰度数据】定義：(就是亮度)   0x00--0xFF  (0~256)
        //[dev setLightValue:buff[6]];
        
        int red = buff[6];
        int green = buff[7];
        int blue = buff[8];
        
        [dev setColor:[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1]];
        
        
    }
    return dev;
}



//【0X66】+【8bit设备名(0xF1)】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit红色数据】＋【8bit绿色数据】＋【8bit蓝色数据】+【8bit暖白数据】+【0X00】＋【0X99】
//【8bit模式值】  为1--20/MANUAL和NONE(定义为0x41)   
+(RGB_WDeviceStateInfo*)getRGBWDeviceStateInfoByData:(NSData*)data
{
    RGB_WDeviceStateInfo *dev = nil;
    
    Byte *buff = (Byte*)[data bytes];
    if (buff[0] == 0x66 && buff[11]==0x99
        //&&(buff[1] == 0x02 || buff[1] == 0x03)
        ) 
    {
        dev = [[RGB_WDeviceStateInfo alloc] init] ;
        if (buff[2]==0x23) {
            [dev setIsOpen:YES];
        }
        else {
            [dev setIsOpen:NO];
        }
        
        //【8bit模式值】定義：
        [dev setModeValue:buff[3]];
        
        
        if (buff[4]==0x21) {
            [dev setIsRunning:YES];
        }
        else {
            [dev setIsRunning:NO];
        }
        
        //【8bit速度值】定義：0x01--0x1F   (10~31)
        Byte speed = buff[5];
        [dev setSpeed:32-speed];

        //【8bit灰度数据】定義：(就是亮度)   0x00--0xFF  (0~256)
        //[dev setLightValue:buff[6]];
        
        int red = buff[6];
        int green = buff[7];
        int blue = buff[8];
        
        [dev setColor:[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1]];
        
        //【8bit暖白数据】
        [dev setWarmWhite:buff[9]];
    }
    return dev;
}

+(DeviceStateInfoBase*)getDeviceStateInfoBaseByData:(NSData*)data
{
    DeviceStateInfoBase *dev = nil;
    
    Byte *buff = (Byte*)[data bytes];
    if (buff[0] == 0x66 )
    {
        dev = [[DeviceStateInfoBase alloc] init] ;
        if (buff[2]==0x23) {
            [dev setIsOpen:YES];
        }
        else {
            [dev setIsOpen:NO];
        }

        if (buff[4]==0x21) {
            [dev setIsRunning:YES];
        }
        else {
            [dev setIsRunning:NO];
        }
        
        if (Style_IsBlackDark) {
            
            //黑色版本只能控制RGBW灯泡,新版的
            if (buff[1]==0x15 || buff[1]==0x16)
            {  [dev setDeviceType:LED_RGB_Bulb_New];  }
            else if(buff[1]==0x03) //RGB 正式03
            {
                [dev setDeviceType:LED_RGB];
            }
            else if (buff[1]==0x04)  //RGBW 04   ,大灯泡，已经不用了
            {
                [dev setDeviceType:LED_RGB];
            }
            else if (buff[1]==0x34)
            {
                [dev setDeviceType:LED_RGB_Bulb_WithSunn];
            }
            else if (buff[1]==0x44)
            {
                [dev setDeviceType:LED_RGBW_UFO];
            }
            else if (buff[1]==0x13)
            {
                [dev setDeviceType:LED_RGB_HighVoltage];
            }
            else
            { [dev setDeviceType:LED_Undown]; }
        }
        else
        {
            if (buff[1]==0x03) //RGB 正式03
            {
                [dev setDeviceType:LED_RGB];
            }
            else if (buff[1]==0x04)  //RGBW 04   ,大灯泡，已经不用了
            {
                [dev setDeviceType:LED_RGB_W];
            }
            else if (buff[1]==0x14 )  //RGBW 04
            {
                [dev setDeviceType:LED_RGB_W2];
            }
            else if (buff[1]==0x01 || buff[1]==0x11 || buff[1]==0x21 || buff[1]==0x31)  //旧版控制器-吸顶灯(01)、单色吸顶灯-灯泡(冷色11、暖色21)
            {
                [dev setDeviceType:LED_Brightness];
            }
            else if (buff[1]==0x02 || buff[1]==0x12)  //02旧版吸顶灯  12新版吸顶灯  （可以同时亮）
            {
                [dev setDeviceType:LED_Color_temperature_CCT];
            }
            else if (buff[1]==0x22)  //02
            {
                [dev setDeviceType:LED_Color_temperature_Bulb];
            }
            else if (buff[1]==0x32)  //02
            {
                [dev setDeviceType:LED_Color_temperature_Bulb_New];
            }
            else if (buff[1]==0x15 || buff[1]==0x16)
            {
                [dev setDeviceType:LED_RGB_Bulb_New];
            }
            else if (buff[1]==0x34)
            {
                [dev setDeviceType:LED_RGB_Bulb_WithSunn];
            }
            else if (buff[1]==0x44)
            {
                [dev setDeviceType:LED_RGBW_UFO];
            }
            else if (buff[1]==0x13)
            {
                [dev setDeviceType:LED_RGB_HighVoltage];
            }
            else
            {
                [dev setDeviceType:LED_Undown];
            }

        }
 
        dev.versionNum = buff[10];
    }
    return dev;
}

+(CustomMode*)getCustomModeForShareByData:(NSData*)data
{
    CustomMode *obj = nil;
    
    Byte *buff = (Byte*)[data bytes];
    if (data.length >=53 && buff[0] == 0x99 )
    {
        obj = [[CustomMode alloc] init];
        [obj setUniID:[AppConfig createUUID]];
        
        obj.speed = buff[49];
        //速度特殊处理, 云端过来的是1~100,  需要变为1~31
        obj.speed = round([AppConfig countValueFromRangeMin:1 maxFrom:100 minTo:1 maxTo:31 withOgrValue:obj.speed]);
        
        if (buff[50] == 0x3A) {
            obj.runModeType = LEDRunMode_gradual;
        }
        else if (buff[50] == 0x3B)
        {
            obj.runModeType = LEDRunMode_jump;
        }
        else if (buff[50] == 0x3C)
        {
            obj.runModeType = LEDRunMode_FLASH;
        }
        else
        {
            obj.runModeType = LEDRunMode_gradual;
        }
        
        int index = 1;
        int itemNo = 1;
        for (int i =0; i<16; i++) {
            
            int r = buff[index++];
            int g = buff[index++];
            int b = buff[index++];
            
            if (r!=1 && g!=2 && b!=3) {
                
                ColorItem *itm = [[ColorItem alloc] init] ;
                [itm setColor:[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]];
                [itm setItemNo:[NSNumber numberWithInt:itemNo]];
                
                [obj.colorItems addObject:itm];
            }
            itemNo++;
        }

    }
    return obj;
}


+(NSDate*)getTimeByData:(NSData*)data
{
    NSDate *r_date = nil;
    Byte *buff = (Byte*)[data bytes];
    int count = 11;
    Byte checkSum = 0x31;
    if (data.length>=count && buff[0] == 0x13 && buff[count-1] == checkSum)
    {
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit
                                | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
        
        ps.year = buff[2] + 2000;
        ps.month = buff[3];
        ps.day = buff[4];
        ps.hour = buff[5];
        ps.minute = buff[6];
        ps.second = buff[7];
        
        r_date = [gregorian dateFromComponents:ps];
    }
    
    return r_date;
}

+(NSDate*)getTimeByDataForTimerBugV5:(NSData*)data
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *ps = [gregorian components:NSMonthCalendarUnit fromDate:[NSDate date]];
    int currentMonth = (int)ps.month;
    
    NSDate *r_date = nil;
    Byte *buff = (Byte*)[data bytes];
    int count = 11;
    Byte checkSum = 0x31;
    if (data.length>=count && buff[0] == 0x13 && buff[count-1] == checkSum)
    {
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit
                                | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
        
        ps.year = buff[2] + 2000;
        ps.month = buff[3];
        ps.day = buff[4];
        ps.hour = buff[5];
        ps.minute = buff[6];
        ps.second = buff[7];
        
        if (ps.month==1 && currentMonth==12) {
            ps.month =12;
        }
        
        r_date = [gregorian dateFromComponents:ps];
    }
    
    return r_date;
}



+(NSData*)getCommondDataForQuery
{
    //【0XEF】+【0X01】+【0X77】
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(3);
    bytes[0] = 0xEF;
    bytes[1] = 0X01;
    bytes[2] = 0X77;
    
    [data appendBytes:bytes length:3];

    free(bytes);
    
    return data;
}


//【0XCC】＋【8bit键值】＋【0X33】
+(NSData*)getCommondDataForSwithOpen:(BOOL)open
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(3);
    bytes[0] = 0xCC;
    bytes[1] = (open)? 0x23 : 0x24 ;
    bytes[2] = 0X33;
    
    [data appendBytes:bytes length:3];
    
    free(bytes);
    
    return data;
}

//【0XCC】＋【8bit键值】＋【0X33】
+(NSData*)getCommondDataForSwithRunning:(BOOL)running
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(3);
    bytes[0] = 0xCC;
    bytes[1] = (running)? 0x21 : 0x20 ;
    bytes[2] = 0X33;
    
    [data appendBytes:bytes length:3];
    
    free(bytes);
    
    return data;
}

//【0XCC】＋【8bit键值】＋【0X33】
+(NSData*)getCommondDataForOpenTimer
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(4);
    bytes[0] = 0xBB;
    bytes[1] = 0x44;
    bytes[2] = 0x00;
    bytes[3] = 0X44;
    
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}
+(NSData*)getCommondDataForCloseTimer
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(3);
    bytes[0] = 0xCC;
    bytes[1] = 0x45;
    bytes[2] = 0X33;
    
    [data appendBytes:bytes length:3];
    
    free(bytes);
    
    return data;
}
/**
 * 发送单色设备亮度  【0X56】＋【8bit灰度数据】+【0XAA】
 */
+(NSData*)getCommondDataForLight:(int16_t)value
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(3);
    bytes[0] = 0x56;
    bytes[1] = value;
    bytes[2] = 0XAA;
    
    [data appendBytes:bytes length:3];
    
    free(bytes);
    
    return data;
}

//按 色環
//【0X56】＋【8bit红色数据】＋【8bit绿色数据】＋【8bit蓝色数据】＋【8bit暖白数据】＋【0XAA】
+(NSData*)getCommandDataForRGBWColor:(UIColor*)color warmWhile:(Byte)warmWhile
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(6);
    bytes[0] = 0x56;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = warmWhile;
    bytes[5] = 0XAA;
    
    [data appendBytes:bytes length:6];
    
    free(bytes);
    
    return data;
}
//+(NSData*)getCommandDataForRGBW2ByColor:(UIColor*)color warmWhile:(Byte)warmWhile
//{
//    Byte red = color.red * 255;
//    Byte green = color.green * 255;
//    Byte blue = color.blue * 255;
//    
//    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
//    
//    Byte *bytes = malloc(7);
//    bytes[0] = 0x56;
//    bytes[1] = red;
//    bytes[2] = green;
//    bytes[3] = blue;
//    bytes[4] = 0x00;
//    bytes[5] = 0XF0;
//    bytes[6] = 0XAA;
//    
//    [data appendBytes:bytes length:7];
//    
//    free(bytes);
//    
//    return data;
//}
//按 音乐协议
+(NSData*)getCommandDataForMusicColorRGBW2:(UIColor*)color
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(7);
    bytes[0] = 0x78;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = 0x00;
    bytes[5] = 0xF0;
    bytes[6] = 0XEE;
    
    [data appendBytes:bytes length:7];
    
    free(bytes);
    
    return data;
}

//按 音乐协议
+(NSData*)getCommandDataForMusicColorRGB:(UIColor*)color
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(6);
    bytes[0] = 0x78;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = 0x00;
    bytes[5] = 0XEE;
    
    [data appendBytes:bytes length:6];
    
    free(bytes);
    
    return data;
}


+(NSData*)getCommandDataForRGBWUFOByColor:(UIColor*)color
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(7);
    bytes[0] = 0x56;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = 0x00;
    bytes[5] = 0XF0;
    bytes[6] = 0XAA;
    
    [data appendBytes:bytes length:7];
    
    free(bytes);
    
    return data;
}
+(NSData*)getCommandDataForRGBWUFOByWarmWhile:(Byte)warmWhile
{
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(7);
    bytes[0] = 0x56;
    bytes[1] = 0x00;
    bytes[2] = 0x00;
    bytes[3] = 0x00;
    bytes[4] = warmWhile;
    bytes[5] = 0X0F;
    bytes[6] = 0XAA;
    
    [data appendBytes:bytes length:7];
    
    free(bytes);
    
    return data;
}

//+(NSData*)getCommandDataForMusicRGBWUFO:(UIColor*)color warmWhile:(Byte)warmWhile
//{
//    Byte red = color.red * 255;
//    Byte green = color.green * 255;
//    Byte blue = color.blue * 255;
//    
//    NSMutableData *data = [[NSMutableData alloc] init] ;
//    
//    Byte *bytes = malloc(7);
//    bytes[0] = 0x78;
//    bytes[1] = red;
//    bytes[2] = green;
//    bytes[3] = blue;
//    bytes[4] = warmWhile;
//    bytes[5] = 0x5A;
//    bytes[6] = 0XEE;
//    
//    [data appendBytes:bytes length:7];
//    
//    free(bytes);
//    
//    return data;
//}
+(NSData*)getCommandDataForMusicRGBWUFOByColor:(UIColor*)color
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(7);
    bytes[0] = 0x78;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = 0x00;
    bytes[5] = 0xF0;
    bytes[6] = 0XEE;
    
    [data appendBytes:bytes length:7];
    
    free(bytes);
    
    return data;
}


+(NSData*)getCommandDataForRGBW2ByColor:(UIColor*)color warmWhile:(Byte)warmWhile
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(7);
    bytes[0] = 0x56;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = warmWhile;
    bytes[5] = 0XF0;
    bytes[6] = 0XAA;
    
    [data appendBytes:bytes length:7];
    
    free(bytes);
    
    return data;
}
+(NSData*)getCommandDataForRGBW2ByWarmWhile:(Byte)warmWhile color:(UIColor*)color
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(7);
    bytes[0] = 0x56;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = warmWhile;
    bytes[5] = 0X0F;
    bytes[6] = 0XAA;
    [data appendBytes:bytes length:7];
    
    free(bytes);
    
    return data;
}

//按 色環
//【0X56】＋【8bit红色数据】＋【8bit绿色数据】＋【8bit蓝色数据】＋【0X00】＋【0XAA】
+(NSData*)getCommandDataForRGBColor:(UIColor*)color
{
    Byte red = color.red * 255;
    Byte green = color.green * 255;
    Byte blue = color.blue * 255;
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(6);
    bytes[0] = 0x56;
    bytes[1] = red;
    bytes[2] = green;
    bytes[3] = blue;
    bytes[4] = 0x00;
    bytes[5] = 0XAA;
    
    [data appendBytes:bytes length:6];
    
    free(bytes);
    
    return data;
}

//发送RGB设备自定义模式
//【0X99】＋【第1点24bit色度值】＋【第2点24bit色度值】＋【第3点24bit色度值】＋
//【第4点24bit色度值】＋【第5点24bit色度值】＋【第6点24bit色度值】＋
//【第7点24bit色度值】＋【第8点24bit色度值】＋【第9点24bit色度值】＋
//【第10点24bit色度值】＋【第11点24bit色度值】＋【第12点24bit色度值】＋
//【第13点24bit色度值】＋【第14点24bit色度值】＋【第15点24bit色度值】＋
//【第16点24bit色度值】＋【8bit速度值】＋【8bit CHANGING模式值】＋
//【0XFF】＋【0X66】
// 1+ 48 + 【8bit速度值】(50)＋【8bit CHANGING模式值】(51)＋【0XFF】(52)＋【0X66】(53)
//中间有黑白会有问题，具体原因再看看

+(NSData*)getCommondDataForCustomModeByColors:(CustomMode*)csmode
                                        speed:(int)Speed   
                                     runModel:(LEDRunModeType)runModel
{
    Speed = 32 - Speed;//显示数字左边1，但发31给我，右边显示31，但发1给我。
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(53);
    bytes[0] = 0x99;
    
    
    int index = 1;
    for (int i=1; i<=16; i++) {
        
        ColorItem *itm = [csmode findColorItemByItemNo:i];
        if (itm!=nil && itm.color!=nil && itm.color.alpha !=0)
        {
            Byte red = itm.color.red * 255;
            Byte green = itm.color.green * 255;
            Byte blue = itm.color.blue * 255;
            
//            if (red ==0 && green ==0 && blue ==0)
//            {
//                red = 1;
//                green = 2;
//                blue = 3;
//            }
            
            bytes[index++] = red;
            bytes[index++] = green;
            bytes[index++] = blue;
        }
        else {
//            bytes[index++] = 0x00;
//            bytes[index++] = 0x00;
//            bytes[index++] = 0x00;
            bytes[index++] = 0x01;
            bytes[index++] = 0x02;
            bytes[index++] = 0x03;
            
            //（R=1，G=2，B=3） 代表 不循环
        }
    }

    
    //【8bit速度值
    bytes[49] = Speed;
    
    //【8bit CHANGING模式值】
    if (runModel == LEDRunMode_gradual) {
         bytes[50] = 0x3A;
    }
    else if (runModel == LEDRunMode_jump)
    {
        bytes[50] = 0x3B;
    }
    else if (runModel == LEDRunMode_FLASH)
    {
        bytes[50] = 0x3C;
    }
    else {
        bytes[50] = 0x3A;
    }
    
    bytes[51] = 0XFF;
    bytes[52] = 0X66;
    
    [data appendBytes:bytes length:53];
    
    free(bytes);
    
    return data;
}
//用于分享命令, speed 值1~100
+(NSData*)getCommondDataForCustomModeForShareByColors:(CustomMode*)csmode
                                        speedPerent:(float)speedPerent
                                     runModel:(LEDRunModeType)runModel
{
    Byte speed = [AppConfig countValueFromRangeMin:0.0f maxFrom:1.0f minTo:1 maxTo:100 withOgrValue:speedPerent];
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(53);
    bytes[0] = 0x99;
    
    
    int index = 1;
    for (int i=1; i<=16; i++) {
        
        ColorItem *itm = [csmode findColorItemByItemNo:i];
        if (itm!=nil && itm.color!=nil && itm.color.alpha !=0)
        {
            Byte red = itm.color.red * 255;
            Byte green = itm.color.green * 255;
            Byte blue = itm.color.blue * 255;
            
            bytes[index++] = red;
            bytes[index++] = green;
            bytes[index++] = blue;
        }
        else {
            bytes[index++] = 0x01;
            bytes[index++] = 0x02;
            bytes[index++] = 0x03;
            
        }
    }
    
    
    //【8bit速度值
    bytes[49] = speed;
    
    //【8bit CHANGING模式值】
    if (runModel == LEDRunMode_gradual) {
        bytes[50] = 0x3A;
    }
    else if (runModel == LEDRunMode_jump)
    {
        bytes[50] = 0x3B;
    }
    else if (runModel == LEDRunMode_FLASH)
    {
        bytes[50] = 0x3C;
    }
    else {
        bytes[50] = 0x3A;
    }
    
    bytes[51] = 0XFF;
    bytes[52] = 0X66;
    
    [data appendBytes:bytes length:53];
    
    free(bytes);
    
    return data;
}

//发送RGB设备模式和速度 (按 + - 模式、速度的Bar)
//传入速度范围 0~29
+(NSData*)getCommondDataForModeBuiltIn:(int8_t)modeBuiltin  speed:(int8_t)speed
{
    speed = 31 - speed;  //协议速度 2~31
    
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(4);
    bytes[0] = 0xBB;
    bytes[1] = modeBuiltin;   //模式 1 的话，就是0x25
    bytes[2] = speed;
    bytes[3] = 0X44;
    
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}



+(NSData*)getCommandDataForWarmWhileForCCT_Bulb:(Byte)warmWhile
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(4);
    bytes[0] = 0x56;
    bytes[1] = warmWhile;
    bytes[2] = 0x00;
    bytes[3] = 0XAA;
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}
+(NSData*)getCommandDataForCoolWhileForCCT_Bulb:(Byte)coolWhite
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(4);
    bytes[0] = 0x56;
    bytes[1] = 0x00;
    bytes[2] = coolWhite;
    bytes[3] = 0XAA;
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}


/**
 * 发送 暖冷色 【0X56】＋【8bit暖色数据】＋【8bit冷色数据】+【0XAA】
 */
+(NSData*)getCommondDataForWarmValue:(int16_t)warmValue coolValue:(int16_t)coolValue
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    Byte *bytes = malloc(4);
    bytes[0] = 0x56;
    bytes[1] = warmValue;
    bytes[2] = coolValue;
    bytes[3] = 0XAA;
    
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}


//----------------------新版协议定时
+(NSData*)getCommondDataForQuerySettingTimes
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    int count = 4;
    Byte *bytes = malloc(count);
    bytes[0] = 0x24;
    bytes[1] = 0x2A;
    bytes[2] = 0x2B;
    bytes[3] = 0x42;
    [data appendBytes:bytes length:count];
    
    free(bytes);
    
    return data;
}


+(NSArray*)getTimerDetailItemsByData:(NSData*)data
{
    NSMutableArray *r_lst = [[NSMutableArray alloc] init];
    Byte *buff = (Byte*)[data bytes];
    int count = 87;
    Byte checkSum = 0x52;
    if (data.length>=count && buff[0] == 0x25 && buff[count-1] == checkSum)
    {
        int index = 1;
        for (int i=0; i<6; i++) {
            
            TimerDetailItem *itm = [[TimerDetailItem alloc] init];
            itm.enableTimer = (buff[index]==0xF0)?YES:NO;index++;
            itm.yearFrom2000 = buff[index] ; index++;
            itm.month = buff[index]; index++;
            itm.day  = buff[index]; index++;
            itm.hour = buff[index]; index++;
            itm.mintue  = buff[index] ; index++;
            itm.sec  = buff[index]; index++;
            itm.week =  buff[index]; index++;
            itm.modeValue  = buff[index] ; index++;
            itm.value1  = buff[index]; index++;
            itm.value2  = buff[index]; index++;
            itm.value3  = buff[index]; index++;
            itm.value4  = buff[index]; index++;
            itm.powerON = (buff[index]==0xF0)?true:false; index++;
            
            //255年后，灯泡肯定不能用了(过滤初始数据问题)
            if (itm.yearFrom2000==255) {
                itm.yearFrom2000 = 0;
                itm.week = 0x00;
                itm.month = 0;
                itm.day  = 0;
                itm.hour = 0;
                itm.mintue  = 0;
                itm.sec  = 0;
            }
            else if (itm.enableTimer==false
                     && itm.hour == 13
                     && itm.mintue == 1
                     && itm.modeValue == 0x41
                     && itm.yearFrom2000 == 0
                     && itm.month ==0
                     && itm.day ==0
                     && itm.sec ==30                   //秒基本上不会出现30的情况
                     && itm.value1 == 0xFF
                     && itm.value2 == 0x00
                     && itm.value3 == 0x80
                     && itm.value4 == 0x00
                     && itm.week == 0x7E)
            {
                //解决王工灯泡有一条不可用初始数据问题,替换为过滤掉的日期
                itm.yearFrom2000 = 0;
                itm.week = 0x00;
                itm.month = 0;
                itm.day  = 0;
                itm.hour = 0;
                itm.mintue  = 0;
                itm.sec  = 0;
                
            }
            if ([itm isCheckEffective]) {
                [r_lst addObject:itm];
            }
        }
        
        return r_lst;
    }
    else
    {
        return nil;
    }

}
+(NSArray*)getTimerDetailItemsByDataForTimerBugV5:(NSData*)data
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *ps = [gregorian components:NSMonthCalendarUnit fromDate:[NSDate date]];
    int currentMonth = (int)ps.month;
    
    NSMutableArray *r_lst = [[NSMutableArray alloc] init];
    Byte *buff = (Byte*)[data bytes];
    int count = 87;
    Byte checkSum = 0x52;
    if (data.length>=count && buff[0] == 0x25 && buff[count-1] == checkSum)
    {
        int index = 1;
        for (int i=0; i<6; i++) {
            
            TimerDetailItem *itm = [[TimerDetailItem alloc] init];
            itm.enableTimer = (buff[index]==0xF0)?YES:NO;index++;
            itm.yearFrom2000 = buff[index] ; index++;
            itm.month = buff[index]; index++;
            if (itm.month==1 && currentMonth==12) {
                itm.month = 12;
            }
            itm.day  = buff[index]; index++;
            itm.hour = buff[index]; index++;
            itm.mintue  = buff[index] ; index++;
            itm.sec  = buff[index]; index++;
            itm.week =  buff[index]; index++;
            itm.modeValue  = buff[index] ; index++;
            itm.value1  = buff[index]; index++;
            itm.value2  = buff[index]; index++;
            itm.value3  = buff[index]; index++;
            itm.value4  = buff[index]; index++;
            itm.powerON = (buff[index]==0xF0)?true:false; index++;
            
            if ([itm isCheckEffective]) {
                [r_lst addObject:itm];
            }
        }
        
        return r_lst;
    }
    else
    {
        return nil;
    }
    
}

+(NSData*)getCommondDataForQueryCurrentDataTime
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    int count = 4;
    Byte *bytes = malloc(count);
    bytes[0] = 0x12;
    bytes[1] = 0x1A;
    bytes[2] = 0x1B;
    bytes[3] = 0x21;
    [data appendBytes:bytes length:count];
    
    free(bytes);
    
    return data;
}

+(NSData*)getCommondDataForSetTimerItems:(NSArray*)items
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    int count = 87;
    Byte *bytes = malloc(count);
    bytes[0] = 0x23;
    int index = 1;
    for (TimerDetailItem *itm in items) {
        
        bytes[index]=itm.enableTimer? (Byte)0xF0: (Byte)0x0F; index++;
        bytes[index]=(Byte) itm.yearFrom2000;index++;
        bytes[index]=(Byte) itm.month;index++;
        bytes[index]=(Byte) itm.day;index++;
        bytes[index]=(Byte) itm.hour;index++;
        bytes[index]=(Byte) itm.mintue;index++;
        bytes[index]=(Byte) itm.sec;index++;
        bytes[index]=(Byte) itm.week;index++;
        bytes[index]=(Byte) itm.modeValue;index++;
        bytes[index]=(Byte) itm.value1;index++;
        bytes[index]=(Byte) itm.value2;index++;
        bytes[index]=(Byte) itm.value3;index++;
        bytes[index]=(Byte) itm.value4;index++;
        bytes[index]=itm.powerON? (Byte)0xF0: (Byte)0x0F; index++;
    }
    
    for (int i = (int)items.count+1; i <= 6; i++)
    {
        //, (byte)0x0F,(byte)0x00,(byte)0x00,(byte)0x00,(byte)0x00,0x00,0x00,(byte)0x06, (byte)0x00, (byte)0x00,  (byte)0x00, 0x00, (byte)0x00, (byte)0x00
        bytes[index]=0x0F;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
    }
    
    bytes[index] = 0x00;index++;
    bytes[index] = 0x32;
    [data appendBytes:bytes length:count];
    
    free(bytes);
    
    return data;
}

+(NSData*)getCommondDataForSetTimerItemsForTimerBugV5:(NSArray*)items
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    int count = 87;
    Byte *bytes = malloc(count);
    bytes[0] = 0x23;
    int index = 1;
    for (TimerDetailItem *itm in items) {
        
        bytes[index]=itm.enableTimer? (Byte)0xF0: (Byte)0x0F; index++;
        bytes[index]=(Byte) itm.yearFrom2000;index++;
        if (itm.month==12)
        {
            bytes[index]=0x01;index++;
        }
        else
        {
            bytes[index]=(Byte) itm.month;index++;
        }
        
        bytes[index]=(Byte) itm.day;index++;
        bytes[index]=(Byte) itm.hour;index++;
        bytes[index]=(Byte) itm.mintue;index++;
        bytes[index]=(Byte) itm.sec;index++;
        bytes[index]=(Byte) itm.week;index++;
        bytes[index]=(Byte) itm.modeValue;index++;
        bytes[index]=(Byte) itm.value1;index++;
        bytes[index]=(Byte) itm.value2;index++;
        bytes[index]=(Byte) itm.value3;index++;
        bytes[index]=(Byte) itm.value4;index++;
        bytes[index]=itm.powerON? (Byte)0xF0: (Byte)0x0F; index++;
    }
    
    for (int i = (int)items.count+1; i <= 6; i++)
    {
        //, (byte)0x0F,(byte)0x00,(byte)0x00,(byte)0x00,(byte)0x00,0x00,0x00,(byte)0x06, (byte)0x00, (byte)0x00,  (byte)0x00, 0x00, (byte)0x00, (byte)0x00
        bytes[index]=0x0F;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
        bytes[index]=0x00;index++;
    }
    
    bytes[index] = 0x00;index++;
    bytes[index] = 0x32;
    [data appendBytes:bytes length:count];
    
    free(bytes);
    
    return data;
}



+(NSData*)getCommondDataForSetTimeByyearFrom2000:(int)yearFrom2000 month:(int)month day:(int)day hour:(int)hour  minute:(int)minute sec:(int)sec week:(int)week
{
    NSMutableData *data = [[NSMutableData alloc] init] ;
    
    int count = 11;
    Byte *bytes = malloc(count);
    bytes[0] = 0x10;
    bytes[1] = 0x14;
    bytes[2] = yearFrom2000;
    bytes[3] = month;
    bytes[4] = day;
    bytes[5] = hour;
    bytes[6] = minute;
    bytes[7] = sec;
    bytes[8] = week;
    bytes[9] = 0x00;
    bytes[10] = 0x01;
    [data appendBytes:bytes length:count];
    
    free(bytes);
    
    return data;
}


@end
