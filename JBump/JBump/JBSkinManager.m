//
//  JBSkinManager.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBSkinManager.h"

@implementation JBSkinManager

static NSString *filePath = @"skins";

+ (NSArray*)getAllSkins {
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
    return skins;
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
    
    return NO;
}

@end
