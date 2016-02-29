//
//  NSData+Helper.h
//  LEDWiFiLibs
//
//  Created by zhou mingchang on 15/12/11.
//  Copyright © 2015年 Zhengji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(SMB)

//- (NSString*) serializeToDeviceTokenString;
//- (NSString*) serializeToHexString;

- (NSString*)hexString;
+ (NSData*)dataForHexString:(NSString*)hexString;

//取32位整型
-(int)intValueWithStartIndex:(int)startIndex;
//取64位长整形
-(long long)doublelongValueWithStartIndex:(int)startIndex;
//取日期64位(8个bit)
-(NSDate*)dateValueFrom8BitWithStartIndex:(int)startIndex;

//内容字符串
-(NSString*)stringContentWithStartIndex:(int)startIndex  length:(int)length;
-(NSData*)dataContentWithStartIndex:(int)startIndex  length:(int)length;
@end
