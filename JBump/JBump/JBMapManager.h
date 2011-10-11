//
//  JBMapManager.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBMap;

@interface JBMapManager : NSObject

+ (void)storeNewMapWithID:(NSString*)mapID
                  mapName:(NSString *)mapName
               arenaImage:(UIImage *)arenaImage
                 settings:(NSMutableArray *)settings
             curveHistory:(NSMutableArray *)curves
            entityHistory:(NSMutableArray*)entities;

+ (void)storeNewMapWithID:(NSString*)mapID
                  mapName:(NSString *)mapName
               mapFurther:(NSString *)mapFurther 
       arenaImageLocation:(NSString *)arenaImageLocation 
  backgroundImageLocation:(NSString *)backgroundImageLocation 
     overlayImageLocation:(NSString *)overlayImageLocation
        thumbnailLocation:(NSString *)thumbnail
             curveHistory:(NSMutableArray *)curves
            entityHistory:(NSMutableArray*)entities;

+ (JBMap*)getMapWithID:(NSString*)aMapID;
+ (NSArray*)getAllMapIDs;
+ (NSMutableArray *)getAllPredefinedSettings;
+ (NSMutableArray *)getAllMapDescriptions;
+ (void)refreshDataForMapIDWithDict:(NSDictionary *)dict;
@end
