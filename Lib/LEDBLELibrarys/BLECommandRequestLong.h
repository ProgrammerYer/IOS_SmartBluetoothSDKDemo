//
//  BLECommandRequest.h
//  LedBLEv2
//
//  Created by luoke365 on 12/30/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLEPeripheral;

@interface BLECommandRequestLong : NSObject


-(id)initWithBLEPeripheral:(BLEPeripheral*)blePeripheral;


-(NSData*)startRequest:(NSData*)cmdData  reponseCount:(int)reponseCount   error:(NSError**)error;
-(NSData*)startRequest:(NSData*)cmdData timeout:(int)timeOut reponseCount:(int)reponseCount  error:(NSError**)error;
@end
