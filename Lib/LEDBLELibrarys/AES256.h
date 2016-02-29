//
//  AES256.h
//  BinderIpad
//
//  Created by xingruyu on 13-7-2.
//
//

#import <Foundation/Foundation.h>

@interface AES256 : NSObject
+(int)DecryptionWithSourceFile:(NSString*) sourceFile toFile:(NSString*)tofile;
@end
