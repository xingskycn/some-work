//
//  JBMapManager.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBMapManager.h"
#import "JBMap.h"

static NSString *filePath = @"maps";

@implementation JBMapManager

+ (void)storeNewMapWithID:(NSString*)mapID
                  mapName:(NSString *)mapName
               mapFurther:(NSString *)mapFurther 
       arenaImageLocation:(NSString *)arenaImageLocation 
  backgroundImageLocation:(NSString *)backgroundImageLocation 
     overlayImageLocation:(NSString *)overlayImageLocation
             curveHistory:(NSMutableArray *)curves
            entityHistory:(NSMutableArray*)entities
{
    
    NSMutableDictionary *mapDict = [NSMutableDictionary dictionary];
    
    if (mapID==nil) {
        srandom([NSDate timeIntervalSinceReferenceDate]);
        mapID=[NSString stringWithFormat:@"%i",(rand()%1000000)];
    }
    
    NSString *folderName = mapID;
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
        
    }
    
    path = [path stringByAppendingPathComponent:folderName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }

    
    [mapDict setObject:mapID forKey:@"mapID"];
    [mapDict setObject:mapName forKey:@"mapName"];
    [mapDict setObject:mapFurther forKey:@"mapFurther"];
    
    if (arenaImageLocation!=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:arenaImageLocation]) writeToFile:[path stringByAppendingPathComponent:@"arenaImage"] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:@"arenaImage"] forKey:@"arenaImageLocal"];
    } else {
        NSLog(@"Received no ArenaImageLocation");
    }
    
    if (backgroundImageLocation!=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:backgroundImageLocation]) writeToFile:[path stringByAppendingPathComponent:@"backgroundImage"] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:@"backgroundImage"] forKey:@"backgroundImageLocal"];
    }else {
        NSLog(@"Received no BackgroundImageLocation");
    }
    
    if (overlayImageLocation!=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:overlayImageLocation]) writeToFile:[path stringByAppendingPathComponent:@"overlayImage"] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:@"overlayImage"] forKey:@"overlayImageLocal"];
    }else {
        NSLog(@"Received no OverlayImageLocation");
    }
    [mapDict setObject:curves forKey:@"curves"];
    [mapDict setObject:entities forKey:@"mapEntities"];
    
    [mapDict writeToFile:[path stringByAppendingPathComponent:@"mapInfo"] atomically:YES];
}

+ (JBMap*)getMapWithID:(NSString*)aMapID {
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    path = [path stringByAppendingPathComponent:aMapID];
    
    NSMutableDictionary* dict = 
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"mapInfo"]];
    UIImage* arenaImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"arenaImage"]];
    UIImage* backgroundImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"arenaImage"]];
    UIImage* overlayImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"overlayImage"]];
    
    if (dict && arenaImage) {
        [dict setObject:arenaImage forKey:@"arenaImage"];
    }
    if (dict && backgroundImage) {
        [dict setObject:backgroundImage forKey:@"backgroundImage"];
    }
    if (dict && overlayImage) {
        [dict setObject:arenaImage forKey:@"overlayImage"];
    }
    
    JBMap *map = [[[JBMap alloc] initWithDictionary:dict] autorelease];
    
    return map;
}

+ (NSMutableArray*)getAllMaps {
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    NSArray* mapIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *allMaps = [NSArray array];
    for (NSString *aMapId in mapIDs) {
        NSMutableDictionary* dict = 
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId]stringByAppendingPathComponent:@"mapInfo"]];
        UIImage* arenaImage = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId] stringByAppendingPathComponent:@"arenaImage"]];
        UIImage* backgroundImage = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId] stringByAppendingPathComponent:@"arenaImage"]];
        UIImage* overlayImage = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId] stringByAppendingPathComponent:@"overlayImage"]];
        
        if (dict && arenaImage) {
            [dict setObject:arenaImage forKey:@"arenaImage"];
        }
        if (dict && backgroundImage) {
            [dict setObject:backgroundImage forKey:@"backgroundImage"];
        }
        if (dict && overlayImage) {
            [dict setObject:arenaImage forKey:@"overlayImage"];
        }
        JBMap *map = [[JBMap alloc] initWithDictionary:dict];
        [allMaps addObject:map];
        [map release];
    }
    return allMaps;
}

+(NSArray *)getAllMapIDs {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
	NSArray* mapIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    return mapIDs;
}
@end
