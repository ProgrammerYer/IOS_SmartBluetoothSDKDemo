//
//  SceneDataMgr.h
//  LedBLEv2
//
//  Created by zhou mingchang on 8/25/15.
//  Copyright (c) 2015 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scene;
@class FlagItem;

@interface SceneDataMgr : NSObject

+(FlagItem*)getFlagItemByDeviceUniID:(NSString*)deviceUniID sceneUniID:(NSString*)sceneUniID;

//+(Scene*)getScenByUniID:(NSString*)uniID;
+(void)saveScene:(Scene*)obj  flagItems:(NSArray*)flagItems;
+(void)SaveSceneByUniID:(NSString*)uniID newSceneName:(NSString*)newSceneName;
+(void)deleteSceneByUniID:(NSString*)uniID;

+(NSArray*)getSceneListByDeviceUniIDs:(NSArray*)dviceUniIDs;
@end
