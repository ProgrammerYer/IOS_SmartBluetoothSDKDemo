//
//  SMBData.h
//  SMBData
//
//  Created by lupom on 2011/10/19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


//该类使用固定的模型 Models
@interface SMBData : NSObject {


}

typedef enum 
{
    SMBDataSortingNone = 0,
    SMBDataSortingASC  = 1,
    SMBDataSortingDESC = 2,
   
}SMBDataSortingType;

+(NSManagedObjectContext*)sharedDataContext;
+(NSManagedObjectContext*)createManagedObjectContext;


@end

