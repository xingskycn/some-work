//
//  JBSkinManager.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBSkinManager.h"
#import "JBSkin.h"

@implementation JBSkinManager

static NSString *filePath = @"skins";

+ (NSMutableArray*)getAllSkins {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
	NSArray* skinIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	
    NSMutableArray* skins = [NSMutableArray array];
	for (NSString* skinID in skinIDs) {
		NSMutableDictionary* dict = 
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:skinID] stringByAppendingPathComponent:@"info"]];
		
		NSString *imagePath = [path stringByAppendingPathComponent:skinID];
		UIImage* skinImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:@"image"]];
		
        NSString *thumbPath = [path stringByAppendingPathComponent:skinID];
        UIImage* thumbImage = [UIImage imageWithContentsOfFile:[thumbPath stringByAppendingPathComponent:@"thumb"]];
        
		if (dict && skinImage && thumbImage) {
			[dict setObject:skinImage forKey:@"image"];
			[dict setObject:thumbImage forKey:@"thumbnail"];
            [skins addObject:dict];
		}
		
	}
    NSMutableArray *allSkins = [NSMutableArray array];
    for (NSMutableDictionary *skinDict in skins) {
        JBSkin *aSkin = [[JBSkin alloc] initWithDictionary:skinDict];
        [allSkins addObject:aSkin];
        [aSkin release];
    }
    
    return allSkins;
}

+ (JBSkin*)getSkinWithID:(NSString*)skinID {
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    path = [path stringByAppendingPathComponent:skinID];
    
    NSMutableDictionary* dict = 
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"info"]];
    UIImage* skinImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"image"]];
    UIImage* thumbImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"thumb"]];
    
    if (dict && skinImage) {
        [dict setObject:skinImage forKey:@"image"];
    }
    
    if (dict && thumbImage) {
        [dict setObject:thumbImage forKey:@"thumbnail"];
    }
    
    JBSkin *skin = [[JBSkin alloc] initWithDictionary:dict];
    
    return skin;
}


+ (bool)saveNewSkin:(NSMutableDictionary*)skinDict withThumbnail:(UIImage*)thumbnail andSkin:(UIImage*)skin {
    NSString *folderName = [skinDict valueForKey:@"skinID"];
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
    
    if (thumbnail){
        [UIImagePNGRepresentation(thumbnail) writeToFile:[path stringByAppendingPathComponent:@"thumb"] atomically:YES];
        [skinDict setValue:[path stringByAppendingPathComponent:@"thumb"] forKey:@"thumbnailLocation"];
        [skinDict removeObjectForKey:@"thumbnail"];
    }
    if (skin){
        [UIImagePNGRepresentation(skin) writeToFile:[path stringByAppendingPathComponent:@"image"] atomically:YES];
        [skinDict setValue:[path stringByAppendingPathComponent:@"image"] forKey:@"imageLocation"];
        [skinDict removeObjectForKey:@"image"];
    }
    
    [skinDict writeToFile:[path stringByAppendingPathComponent:@"info"] atomically:YES];
    
    if (error!=nil)
        return NO;
    return YES;
}

@end
