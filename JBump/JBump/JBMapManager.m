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

+ (void)storeNewMapWithID:(NSString *)mapID
                 infoData:(NSData *)infoData
           arenaImageData:(NSData *)arenaImageData
       thumbnailImageData:(NSData *)thumbnailImageData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [[[paths objectAtIndex:0] stringByAppendingPathComponent:filePath] 
                      stringByAppendingPathComponent:mapID];
    
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
    
    [infoData writeToFile:[path stringByAppendingPathComponent:jbINFO] atomically:YES];
    [arenaImageData writeToFile:[path stringByAppendingPathComponent:jbARENAIMAGE] atomically:YES];
    [thumbnailImageData writeToFile:[path stringByAppendingPathComponent:jbTHUMBNAIL] atomically:YES];
}

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
    [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:mapID]stringByAppendingPathComponent:jbINFO]];
    
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
    [mapDict setObject:mapID forKey:jbID];
    [mapDict setObject:mapName forKey:jbNAME];
    [UIImagePNGRepresentation(arenaImage) writeToFile:[path stringByAppendingPathComponent:jbARENAIMAGE] atomically:YES];
    
    float thumbHeight = 180 * arenaImage.size.height /arenaImage.size.width;
    CGRect thumbRect = CGRectIntegral(CGRectMake(0, 0, 180, thumbHeight));
    CGImageRef imageRef = arenaImage.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                thumbRect.size.width,
                                                thumbRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    CGContextSetInterpolationQuality(bitmap, 1.);
    CGContextDrawImage(bitmap, thumbRect, imageRef);
    CGImageRef thumbnailRef = CGBitmapContextCreateImage(bitmap);
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailRef];
    CGContextRelease(bitmap);
    CGImageRelease(thumbnailRef);
    [UIImagePNGRepresentation(thumbnail) writeToFile:[path stringByAppendingPathComponent:jbTHUMBNAIL] atomically:YES];
    
    [mapDict setObject:[path stringByAppendingPathComponent:jbARENAIMAGE] forKey:jbARENAIMAGELOCATION];
    [mapDict setObject:[path stringByAppendingPathComponent:jbTHUMBNAIL] forKey:jbTHUMBNAILLOCATION];
    if (curves) {
        [mapDict setObject:curves forKey:jbCURVES];
    }
    
    if (entities) {
        [mapDict setObject:entities forKey:jbENTITIES];
    }
    if (settings) {
        [mapDict setObject:settings forKey:jbSETTINGS];
    }
    [mapDict setObject:[path stringByAppendingPathComponent:jbINFO] forKey:jbINFOLOCATION];
    [mapDict writeToFile:[path stringByAppendingPathComponent:jbINFO] atomically:YES];
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

    
    [mapDict setObject:mapID forKey:jbID];
    [mapDict setObject:mapName forKey:jbNAME];
    [mapDict setObject:mapFurther forKey:jbFURTHER];
    
    if (arenaImageLocation!=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:arenaImageLocation]) writeToFile:[path stringByAppendingPathComponent:jbARENAIMAGE] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:jbARENAIMAGE] forKey:jbARENAIMAGELOCATION];
    } else {
        NSLog(@"Received no ArenaImageLocation");
    }
    
    if (backgroundImageLocation!=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:backgroundImageLocation]) writeToFile:[path stringByAppendingPathComponent:jbBACKGROUNDIMAGE] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:jbBACKGROUNDIMAGE] forKey:jbBACKGROUNDIMAGELOCATION];
    }else {
        NSLog(@"Received no BackgroundImageLocation");
    }
    
    if (overlayImageLocation!=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:overlayImageLocation]) writeToFile:[path stringByAppendingPathComponent:jbOVERLAYIMAGE] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:jbOVERLAYIMAGE] forKey:jbOVERLAYIMAGELOCATION];
    }else {
        NSLog(@"Received no OverlayImageLocation");
    }
    
    if (thumbnailLocation !=nil) {
        [UIImagePNGRepresentation([UIImage imageWithContentsOfFile:thumbnailLocation]) writeToFile:[path stringByAppendingPathComponent:jbTHUMBNAIL] atomically:YES];
        [mapDict setObject:[path stringByAppendingPathComponent:jbTHUMBNAIL] forKey:jbTHUMBNAILLOCATION];
    }else {
        NSLog(@"Received no ThumbnailLocation");
    }
    
    [mapDict setObject:curves forKey:jbCURVES];
    [mapDict setObject:entities forKey:jbENTITIES];
    
    [mapDict setObject:[path stringByAppendingPathComponent:jbINFO] forKey:jbINFOLOCATION];
    [mapDict writeToFile:[path stringByAppendingPathComponent:jbINFO] atomically:YES];
}

+ (JBMap*)getMapWithID:(NSString*)aMapID {
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    path = [path stringByAppendingPathComponent:aMapID];
    
    NSMutableDictionary* dict = 
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:jbINFO]];
    UIImage* arenaImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:jbARENAIMAGE]];
    UIImage* backgroundImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:jbBACKGROUNDIMAGE]];
    UIImage* overlayImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:jbOVERLAYIMAGE]];
    
    if (dict && arenaImage) {
        [dict setObject:arenaImage forKey:jbARENAIMAGE];
    }
    if (dict && backgroundImage) {
        [dict setObject:backgroundImage forKey:jbBACKGROUNDIMAGE];
    }
    if (dict && overlayImage) {
        [dict setObject:arenaImage forKey:jbOVERLAYIMAGE];
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
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId]stringByAppendingPathComponent:jbINFO]];
        UIImage* arenaImage = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId] stringByAppendingPathComponent:jbARENAIMAGE]];
        UIImage* backgroundImage = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId] stringByAppendingPathComponent:jbBACKGROUNDIMAGE]];
        UIImage* overlayImage = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId] stringByAppendingPathComponent:jbOVERLAYIMAGE]];
        
        UIImage* thumbnail = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapId] stringByAppendingPathComponent:jbTHUMBNAIL]];
        
        if (dict && arenaImage) {
            [dict setObject:arenaImage forKey:jbARENAIMAGE];
        }
        if (dict && backgroundImage) {
            [dict setObject:backgroundImage forKey:jbBACKGROUNDIMAGE];
        }
        if (dict && overlayImage) {
            [dict setObject:arenaImage forKey:jbOVERLAYIMAGE];
        }
        
        if (dict && thumbnail) {
            [dict setObject:thumbnail forKey:jbTHUMBNAIL];
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
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:aMapID]stringByAppendingPathComponent:jbINFO]];
        UIImage* thumbnail = [UIImage imageWithContentsOfFile:[[path stringByAppendingPathComponent:aMapID] stringByAppendingPathComponent:jbTHUMBNAIL]];
        
        if (dict && thumbnail) {
            [dict setObject:thumbnail forKey:jbTHUMBNAIL];
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
    NSString* mapID = [dict objectForKey:jbID];
    NSMutableDictionary* mapDict =
    [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:mapID]stringByAppendingPathComponent:jbINFO]];
    
    for (NSString* key in [dict allKeys]) {
        [mapDict setObject:[dict objectForKey:key] forKey:key];
    }
    
    [mapDict setObject:[[path stringByAppendingPathComponent:mapID] stringByAppendingPathComponent:jbINFO] forKey:jbINFOLOCATION];
    [mapDict writeToFile:[[path stringByAppendingPathComponent:mapID] stringByAppendingPathComponent:jbINFO] atomically:YES];
}

+ (NSMutableArray*)getAllMapsWithPrefix:(NSString *)prefix {
    NSMutableArray *allMaps = [self getAllMaps];
    NSMutableArray *filtered = [NSMutableArray array];
    
    for (JBMap *map in allMaps) {
        if ([map.ID hasPrefix:prefix]) {
            [filtered addObject:map];
        }
    }
    
    return filtered;
}

+ (NSMutableArray *)getMapTypes
{
    NSMutableArray* maptypes = [NSMutableArray array];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:jbMAPPREFIX_STANDARD forKey:jbID];
    [dict setObject:@"standard" forKey:jbNAME];
    [maptypes addObject:dict];
    
    dict = [NSMutableDictionary dictionary];
    [dict setObject:jbMAPPREFIX_TDM forKey:jbID];
    [dict setObject:@"team death match" forKey:jbNAME];
    [maptypes addObject:dict];
    
    dict = [NSMutableDictionary dictionary];
    [dict setObject:jbMAPPREFIX_CTF forKey:jbID];
    [dict setObject:@"capture the flag" forKey:jbNAME];
    [maptypes addObject:dict];
    
    dict = [NSMutableDictionary dictionary];
    [dict setObject:jbMAPPREFIX_SOCCER forKey:jbID];
    [dict setObject:@"soccer" forKey:jbNAME];
    [maptypes addObject:dict];
    
    dict = [NSMutableDictionary dictionary];
    [dict setObject:jbMAPPREFIX_CUSTOM forKey:jbID];
    [dict setObject:@"custom" forKey:jbNAME];
    [maptypes addObject:dict];
    
    return maptypes;
}

+ (NSMutableArray *)getAllPredefinedSettings
{
    // standard settings
    
    NSMutableArray* defines = [NSMutableArray new];
    NSMutableDictionary* define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"standard" forKey:jbID];
    [define setValue:@"standard" forKey:jbNAME];
    NSMutableArray* settings = [NSMutableArray array];
    [define setValue:settings  forKey:jbMAPSETTINGS_SETTINGS];
    
    NSMutableDictionary* setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbID];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbNAME];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbNAME];
    [setting setValue:@"0.4" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbID];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbNAME];
    [setting setValue:@"1" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbNAME];
    [setting setValue:@"0.05" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbNAME];
    [setting setValue:@"10" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbNAME];
    [setting setValue:@"5" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbID];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];
    
    // moon settings
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"moon" forKey:jbID];
    [define setValue:@"moon" forKey:jbNAME];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:jbMAPSETTINGS_SETTINGS];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbID];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbNAME];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -5)) forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbNAME];
    [setting setValue:@"0.4" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbID];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbNAME];
    [setting setValue:@"1" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbNAME];
    [setting setValue:@"0.15" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbNAME];
    [setting setValue:@"10" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbNAME];
    [setting setValue:@"5" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbID];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];

    
    // standard team deathmatch settings
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"team death match" forKey:jbID];
    [define setValue:@"team death match" forKey:jbNAME];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:jbMAPSETTINGS_SETTINGS];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbID];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbNAME];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbNAME];
    [setting setValue:@"0.4" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbID];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbNAME];
    [setting setValue:@"2" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbNAME];
    [setting setValue:@"0.05" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbNAME];
    [setting setValue:@"10" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbNAME];
    [setting setValue:@"5" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbID];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];

    
    // standard capture the flag
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"team capture the flag" forKey:jbID];
    [define setValue:@"team capture the flag" forKey:jbNAME];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:jbMAPSETTINGS_SETTINGS];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbID];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbNAME];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbNAME];
    [setting setValue:@"0.4" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbID];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbNAME];
    [setting setValue:@"2" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbNAME];
    [setting setValue:@"0.05" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbNAME];
    [setting setValue:@"10" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbNAME];
    [setting setValue:@"5" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbID];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbNAME];
    [setting setValue:@"YES" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];
    
    // standard soccer
    
    define = [NSMutableDictionary dictionary];
    [defines addObject:define];
    [define setValue:@"soccer" forKey:jbID];
    [define setValue:@"soccer" forKey:jbNAME];
    settings = [NSMutableArray array];
    [define setValue:settings  forKey:jbMAPSETTINGS_SETTINGS];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbID];
    [setting setValue:jbMAPSETTINGS_DATA forKey:jbNAME];
    [setting setValue:NSStringFromCGPoint(CGPointMake(0, -10)) forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOLIDFRICTION forKey:jbNAME];
    [setting setValue:@"0.4" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbID];
    [setting setValue:jbMAPSETTINGS_TEAMS forKey:jbNAME];
    [setting setValue:@"2" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_RESTITUTION forKey:jbNAME];
    [setting setValue:@"0.05" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_ACCELERATION forKey:jbNAME];
    [setting setValue:@"10" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbID];
    [setting setValue:jbMAPSETTINGS_HERO_MAXIMUM_SPEED forKey:jbNAME];
    [setting setValue:@"5" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbID];
    [setting setValue:jbMAPSETTINGS_CAPTURE_THE_FLAG forKey:jbNAME];
    [setting setValue:@"NO" forKey:jbMAPSETTINGS_DATA];
    
    setting = [NSMutableDictionary dictionary];
    [settings addObject:setting];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbID];
    [setting setValue:jbMAPSETTINGS_SOCCER forKey:jbNAME];
    [setting setValue:@"YES" forKey:jbMAPSETTINGS_DATA];
    
    return [defines autorelease];
}
@end
