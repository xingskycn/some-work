//
//  JBMapManager.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBMapManager.h"
#import "JBMap.h"

static NSString *filePath = @"maps";

@implementation JBMapManager

+ (void)storeNewMapWithID:(NSString*)mapID
                  mapName:(NSString *)mapName
               arenaImage:(UIImage *)arenaImage
                 settings:(NSMutableArray *)settings
             curveHistory:(NSMutableArray *)curves
            entityHistory:(NSMutableArray*)entities

{
    
    
    NSString *folderName = mapID;
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    NSMutableDictionary* mapDict =
    [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:mapID]stringByAppendingPathComponent:@"mapInfo"]];
    
    if (!mapDict) {
        mapDict = [NSMutableDictionary dictionary];
    }
    
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
    [UIImagePNGRepresentation(arenaImage) writeToFile:[path stringByAppendingPathComponent:@"arenaImage"] atomically:YES];
    [mapDict setObject:[path stringByAppendingPathComponent:@"arenaImage"] forKey:@"arenaImageLocal"];
    if (curves) {
        [mapDict setObject:curves forKey:@"curves"];
    }else{
        
    }
    if (entities) {
        [mapDict setObject:entities forKey:@"mapEntities"];
    }
    if (settings) {
        [mapDict setObject:settings forKey:@"settings"];
    }
    
    [mapDict writeToFile:[path stringByAppendingPathComponent:@"mapInfo"] atomically:YES];
}


+ (void)storeNewMapWithID:(NSString*)mapID
                  mapName:(NSString *)mapName
               mapFurther:(NSString *)mapFurther 
       arenaImageLocation:(NSString *)arenaImageLocation 
  backgroundImageLocation:(NSString *)backgroundImageLocation 
     overlayImageLocation:(NSString *)overlayImageLocation
        thumbnailLocation:(NSString *)thumbnailLocation
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
    
    if (thumbnailLocation !=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:thumbnailLocation]) writeToFile:[path stringByAppendingPathComponent:@"thumbnail"] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:@"thumbnail"] forKey:@"thumbnailLocal"];
    }else {
        NSLog(@"Received no ThumbnailLocation");
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
    NSMutableArray *allMaps = [NSMutableArray array];
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

+ (NSMutableArray *)getAllMapDescriptions {
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    NSArray* mapIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *allDescriptions = [NSMutableArray array];
    for (NSString *aMapID in mapIDs) {
        NSMutableDictionary* dict = 
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:aMapID]stringByAppendingPathComponent:@"mapInfo"]];
        UIImage* thumbnail = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapID] stringByAppendingPathComponent:@"thumbnail"]];
        
        if (dict && thumbnail) {
            [dict setObject:thumbnail forKey:@"thumbnail"];
        }
        if (dict) {
            [allDescriptions addObject:dict];
        }
        
    }
    return allDescriptions;
}

+ (void)refreshDataForMapIDWithDict:(NSDictionary *)dict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    NSString* mapID = [dict objectForKey:@"mapID"];
    NSMutableDictionary* mapDict =
    [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:mapID]stringByAppendingPathComponent:@"mapInfo"]];
    
    for (NSString* key in [dict allKeys]) {
        [mapDict setObject:[dict objectForKey:key] forKey:key];
    }
    [mapDict writeToFile:[[path stringByAppendingPathComponent:mapID] stringByAppendingPathComponent:@"mapInfo"] atomically:YES];
}

+ (NSMutableArray *)getAllPredefinedSettings
{
    // standard settings
    
    NSMutableArray* defines = [NSMutableArray new];
    NSMutableDictionary* define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"standard" forKey:@"ID"];
    [define setValue:@"standard" forKey:@"name"];
    NSMutableArray* settings = [NSMutableArray array];
    [define setValue:settings  forKey:@"settings"];
    
    NSMutableDictionary* setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"gravitation" forKey:@"ID"];
    [setting setValue:@"gravitation" forKey:@"name"];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"solid friction" forKey:@"ID"];
    [setting setValue:@"solid friction" forKey:@"name"];
    [setting setValue:@"0.4" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"teams" forKey:@"ID"];
    [setting setValue:@"teams" forKey:@"name"];
    [setting setValue:@"1" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero restitution" forKey:@"ID"];
    [setting setValue:@"hero restitution" forKey:@"name"];
    [setting setValue:@"0.05" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero acceleration" forKey:@"ID"];
    [setting setValue:@"hero acceleration" forKey:@"name"];
    [setting setValue:@"10" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero maximum speed" forKey:@"ID"];
    [setting setValue:@"hero maximum speed" forKey:@"name"];
    [setting setValue:@"5" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"ctf" forKey:@"ID"];
    [setting setValue:@"capture the flag" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"soccer" forKey:@"ID"];
    [setting setValue:@"soccer" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];
    
    // moon settings
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"moon" forKey:@"ID"];
    [define setValue:@"moon" forKey:@"name"];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:@"settings"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"gravitation" forKey:@"ID"];
    [setting setValue:@"gravitation" forKey:@"name"];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -5)) forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"solid friction" forKey:@"ID"];
    [setting setValue:@"solid friction" forKey:@"name"];
    [setting setValue:@"0.4" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"teams" forKey:@"ID"];
    [setting setValue:@"teams" forKey:@"name"];
    [setting setValue:@"1" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero restitution" forKey:@"ID"];
    [setting setValue:@"hero restitution" forKey:@"name"];
    [setting setValue:@"0.15" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero acceleration" forKey:@"ID"];
    [setting setValue:@"hero acceleration" forKey:@"name"];
    [setting setValue:@"10" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero maximum speed" forKey:@"ID"];
    [setting setValue:@"hero maximum speed" forKey:@"name"];
    [setting setValue:@"5" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"ctf" forKey:@"ID"];
    [setting setValue:@"capture the flag" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"soccer" forKey:@"ID"];
    [setting setValue:@"soccer" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];

    
    // standard team deathmatch settings
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"team death match" forKey:@"ID"];
    [define setValue:@"team death match" forKey:@"name"];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:@"settings"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"gravitation" forKey:@"ID"];
    [setting setValue:@"gravitation" forKey:@"name"];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"solid friction" forKey:@"ID"];
    [setting setValue:@"solid friction" forKey:@"name"];
    [setting setValue:@"0.4" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"teams" forKey:@"ID"];
    [setting setValue:@"teams" forKey:@"name"];
    [setting setValue:@"2" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero restitution" forKey:@"ID"];
    [setting setValue:@"hero restitution" forKey:@"name"];
    [setting setValue:@"0.05" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero acceleration" forKey:@"ID"];
    [setting setValue:@"hero acceleration" forKey:@"name"];
    [setting setValue:@"10" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero maximum speed" forKey:@"ID"];
    [setting setValue:@"hero maximum speed" forKey:@"name"];
    [setting setValue:@"5" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"ctf" forKey:@"ID"];
    [setting setValue:@"capture the flag" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"soccer" forKey:@"ID"];
    [setting setValue:@"soccer" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];

    
    // standard capture the flag
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"team capture the flag" forKey:@"ID"];
    [define setValue:@"team capture the flag" forKey:@"name"];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:@"settings"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"gravitation" forKey:@"ID"];
    [setting setValue:@"gravitation" forKey:@"name"];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"solid friction" forKey:@"ID"];
    [setting setValue:@"solid friction" forKey:@"name"];
    [setting setValue:@"0.4" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"teams" forKey:@"ID"];
    [setting setValue:@"teams" forKey:@"name"];
    [setting setValue:@"2" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero restitution" forKey:@"ID"];
    [setting setValue:@"hero restitution" forKey:@"name"];
    [setting setValue:@"0.05" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero acceleration" forKey:@"ID"];
    [setting setValue:@"hero acceleration" forKey:@"name"];
    [setting setValue:@"10" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero maximum speed" forKey:@"ID"];
    [setting setValue:@"hero maximum speed" forKey:@"name"];
    [setting setValue:@"5" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"ctf" forKey:@"ID"];
    [setting setValue:@"capture the flag" forKey:@"name"];
    [setting setValue:@"YES" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"soccer" forKey:@"ID"];
    [setting setValue:@"soccer" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];
    
    // standard soccer
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"soccer" forKey:@"ID"];
    [define setValue:@"soccer" forKey:@"name"];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:@"settings"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"gravitation" forKey:@"ID"];
    [setting setValue:@"gravitation" forKey:@"name"];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"solid friction" forKey:@"ID"];
    [setting setValue:@"solid friction" forKey:@"name"];
    [setting setValue:@"0.4" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"teams" forKey:@"ID"];
    [setting setValue:@"teams" forKey:@"name"];
    [setting setValue:@"2" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero restitution" forKey:@"ID"];
    [setting setValue:@"hero restitution" forKey:@"name"];
    [setting setValue:@"0.05" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero acceleration" forKey:@"ID"];
    [setting setValue:@"hero acceleration" forKey:@"name"];
    [setting setValue:@"10" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"hero maximum speed" forKey:@"ID"];
    [setting setValue:@"hero maximum speed" forKey:@"name"];
    [setting setValue:@"5" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"ctf" forKey:@"ID"];
    [setting setValue:@"capture the flag" forKey:@"name"];
    [setting setValue:@"NO" forKey:@"data"];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:@"soccer" forKey:@"ID"];
    [setting setValue:@"soccer" forKey:@"name"];
    [setting setValue:@"YES" forKey:@"data"];
    
    return [defines autorelease];
}
@end
