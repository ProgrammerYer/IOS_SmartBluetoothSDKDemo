//
//  SceneDataMgr.m
//  LedBLEv2
//
//  Created by zhou mingchang on 8/25/15.
//  Copyright (c) 2015 luoke365. All rights reserved.
//

#import "SceneDataMgr.h"
#import "SMBData.h"
#import "SMBData+Context.h"
#import "UIColor-Expanded.h"
#import "CDScene.h"
#import "CDSceneItem.h"
#import "CDScene+CoreDataProperties.h"
#import "CDSceneItem+CoreDataProperties.h"
//#import "FlagItem.h"
#import "AppConfig.h"
#import "Scene.h"


@implementation SceneDataMgr


+(NSArray*)getSceneListByDeviceUniIDs:(NSArray*)dviceUniIDs
{
    NSManagedObjectContext *context = [SMBData sharedDataContext];
    
    NSArray *items = [context getAllRowsInTable:@"CDScene"];
    NSMutableArray *newItems = [NSMutableArray array];
//    for (CDScene *itm in items) {
//        
//        Scene *obj = [self convertToSceneByCDScene:itm];
//        NSLog(@"CDScene: %@",obj);
//    }
//    
//    items = [context getAllRowsInTable:@"CDSceneItem"];
//    for (CDSceneItem *itm in items) {
//        
//        FlagItem *obj = [self convertToFlagItemByCDSceneItem:itm];
//        NSLog(@"CDSceneItem: %@",obj);
//    }
    for (CDScene *obj in items) {
        if (obj != nil) {
            [newItems addObject:[self convertToSceneByCDScene:obj]];
        }
    }

//    NSMutableArray *uniIDs = [NSMutableArray array];
//    for (NSString* uniID in dviceUniIDs)
//    {
//        //NSLog(@"all scene: %@",[context getRowsInTable:@"CDSceneItem" whereWithFormat:@"deviceUniID = %@",uniID]);
//        
//        
//        NSArray* distinctObjs = [context getDistinctRowsInTable:@"CDSceneItem" fieldName:@"sceneUniID" whereWithFormat:@"deviceUniID = %@",uniID];
//        //NSLog(@"getSceneListByDeviceUniIDs: %@",sceneUniIDs);
//        
//        for (id obj in distinctObjs)
//        {
//            NSString *uniID = obj[@"sceneUniID"];
//            if (![uniIDs containsObject:uniID])
//            {
//                [uniIDs addObject:uniID];
//            }
//        }
//    }
//    
//    NSMutableArray *r_items = [NSMutableArray array];
//    for (NSString *uniID in uniIDs) {
//        
//        CDScene *obj =[context getOneRowInTable:@"CDScene" byKey:@"uniID" withValue:uniID andEnsureOnlyOne:YES];
//        if (obj!=nil)
//        {
//            [r_items addObject:[self convertToSceneByCDScene:obj]];
//        }
//    }
    
    
    return newItems;
}

+(FlagItem*)getFlagItemByDeviceUniID:(NSString*)deviceUniID sceneUniID:(NSString*)sceneUniID
{
    NSManagedObjectContext *context = [SMBData sharedDataContext];
    NSArray *items =  [context getRowsInTable:@"CDSceneItem" whereWithFormat:@"sceneUniID=%@ AND deviceUniID =%@",sceneUniID,deviceUniID];
    if (items.count>0)
    {
        return [self convertToFlagItemByCDSceneItem:items.firstObject];
    }
    else
    {
        return nil;
    }
}

//+(Scene*)getScenByUniID:(NSString*)uniID
//{
//    NSManagedObjectContext *context = [SMBData sharedDataContext];
//    return [context getOneRowInTable:@"CDScene" byKey:@"uniID" withValue:uniID andEnsureOnlyOne:YES];
//}

+(void)saveScene:(Scene*)obj  flagItems:(NSArray*)flagItems
{
    
    NSManagedObjectContext *context = [SMBData sharedDataContext];
    
    NSString *sceneUniID = obj.uniID;
    
    CDScene *scene = [context getOneRowInTable:@"CDScene" byKey:@"uniID" withValue:sceneUniID andEnsureOnlyOne:YES];
    if (scene==nil) {
         scene = [context CreateRowForTable:@"CDScene"];
        [scene setUniID:sceneUniID];
        [scene setCreateDate:[NSDate date].timeIntervalSince1970];
    }
    [scene setSceneName:obj.sceneName];
    [scene setSceneImageName:obj.sceneImageName];
    [scene setDefColorString:obj.defColorString];
    //删除明细数据,然后重新保存
    NSArray *items = [context getRowsInTable:@"CDSceneItem" byKey:@"sceneUniID" withValue:sceneUniID];
    
    for (CDSceneItem *itm in items) {
        for (FlagItem *item in flagItems) {
            if ([itm.deviceUniID isEqualToString:item.deviceUniID]) {
                [context deleteObject:itm];
            }
        }
        
    }
    
    //插入新的定时数据
    for (FlagItem *itm in flagItems) {
        
        CDSceneItem *obj = [context CreateRowForTable:@"CDSceneItem"];
        [obj setUniID:[AppConfig createUUID]];
        [obj setSceneUniID:sceneUniID];
        
        obj.deviceUniID = itm.deviceUniID;
        obj.groupUniID = itm.groupUniID;
        obj.colorString = [itm.color hexStringFromColor];
        obj.warmBrightness = itm.warmBrightness;
        obj.coolBrightness = itm.coolBrightness;
        obj.colorPointX = itm.colorPoint.x;
        obj.colorPointY = itm.colorPoint.y;
        obj.colorType = itm.colorType;
    }
    
    [context SumbitContext];
}

+(void)SaveSceneByUniID:(NSString*)uniID newSceneName:(NSString*)newSceneName
{
    NSManagedObjectContext *context = [SMBData sharedDataContext];
    CDScene *obj = [context getOneRowInTable:@"CDScene" byKey:@"uniID" withValue:uniID andEnsureOnlyOne:NO];
    if (obj!=nil) {
        [obj setSceneName:newSceneName];
    }
    [context SumbitContext];
}


+(void)deleteSceneByUniID:(NSString*)uniID
{
    NSManagedObjectContext *context = [SMBData sharedDataContext];
    CDScene *obj = [context getOneRowInTable:@"CDScene" byKey:@"uniID" withValue:uniID andEnsureOnlyOne:NO];
    if (obj!=nil) {
        [context deleteObject:obj];
    }
    
    //删除明细数据,然后重新保存
    NSArray *items = [context getRowsInTable:@"CDSceneItem" byKey:@"sceneUniID" withValue:uniID];
    for (CDSceneItem *itm in items) {
        [context deleteObject:itm];
    }
    
    [context SumbitContext];
}

+(FlagItem*)convertToFlagItemByCDSceneItem:(CDSceneItem*)itm
{
    FlagItem *obj = [[FlagItem alloc] init];
    
    obj.groupUniID = itm.groupUniID;
    obj.deviceUniID = itm.deviceUniID;
    obj.color = [UIColor colorWithHexString:itm.colorString];
    obj.warmBrightness = itm.warmBrightness;
    obj.coolBrightness = itm.coolBrightness;
    obj.colorPoint = CGPointMake(itm.colorPointX, itm.colorPointY);
    obj.colorType = itm.colorType;
    
    return obj;
}

+(Scene*)convertToSceneByCDScene:(CDScene*)itm
{
    Scene *obj = [[Scene alloc] init];
    
    obj.uniID = itm.uniID;
    obj.sceneName = itm.sceneName;
    obj.sceneImageName = itm.sceneImageName;
    obj.defColorString = itm.defColorString;
    obj.createDate = [NSDate dateWithTimeIntervalSince1970:itm.createDate];
    
    return obj;
}

@end
