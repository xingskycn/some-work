//
//  JBMapStoreDevice.m
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/5/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import "JBMapStoreDevice.h"


@implementation JBMapStoreDevice

- (NSArray *)getCategories
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/categories/"];
	NSArray* categoryIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	
	NSMutableArray* categories = [NSMutableArray array];
	for (NSString* categoryID in categoryIDs) {
		NSString* info = [path stringByAppendingPathComponent:categoryID];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:categoryID];
		
		UIImage* mapImage = [UIImage imageWithContentsOfFile:[info stringByAppendingFormat:@"image"]];
		
		if (dict && mapImage) {
			[dict setObject:mapImage forKey:@"image"];
			[categories addObject:dict];
		}
	}
	
    return categories;
}

- (NSArray *)getMapsForCategory:(NSUInteger)categoryNr
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/categories/"];
    NSString* categoryNrStr = [NSString stringWithFormat:@"%d",categoryNr];
    path = [path stringByAppendingPathComponent:categoryNrStr];
    NSArray* mapIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];


    
	NSMutableArray* maps = [NSMutableArray array];
	for (NSString* mapID in mapIDs) {
		NSString* info = [path stringByAppendingPathComponent:mapID];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:mapID];
		
		UIImage* mapThumb = [UIImage imageWithContentsOfFile:[info stringByAppendingFormat:@"thumbnailas"]];
		
		if (dict && mapThumb) {
			[dict setObject:mapThumb forKey:@"image"];
			[maps addObject:dict];
		}
	}
    
    return maps;
}

- (void)addMapIntoCategory:(int)categoryNr mapID:(NSString *)mapID info:(NSDictionary *)dict
{
    NSMutableDictionary* mdict = [dict mutableCopy];
    
    UIImage* image = [mdict objectForKey:@"image"];
    [mdict removeObjectForKey:@"image"];
    NSString* mapIDi = [NSString stringWithFormat:@"%@i",mapID];
    
    UIImage* overlay = [mdict objectForKey:@"overlay"];
    [mdict removeObjectForKey:@"overlay"];
    NSString* mapIDo = [NSString stringWithFormat:@"%@o",mapID];
    
    UIImage* background = [mdict objectForKey:@"background"];
    [mdict removeObjectForKey:@"background"];
    NSString* mapIDb = [NSString stringWithFormat:@"%@b",mapID];
    
    UIImage* thumbnail = [mdict objectForKey:@"thumbnail"];
    [mdict removeObjectForKey:@"thumbnail"];
    NSString* mapIDt = [NSString stringWithFormat:@"%@b",mapID];
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps"];
    NSError* error;
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
    
    NSString* categoriesPath = [path stringByAppendingPathComponent:@"categories"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:categoriesPath])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:categoriesPath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
    NSString* categoryPath = [categoriesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",categoryNr]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:categoryPath])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:categoryPath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
        
    }
    
    [mdict writeToFile:[categoryPath stringByAppendingPathComponent:mapID] atomically:YES];
    if (image) {
        [UIImagePNGRepresentation(image) writeToFile:[categoryPath stringByAppendingPathComponent:mapIDi]
                                          atomically:YES];
    }
    
    if (overlay) {
        [UIImagePNGRepresentation(overlay) writeToFile:[categoryPath stringByAppendingPathComponent:mapIDo]
                                            atomically:YES];
    }
    
    if (background) {
        [UIImageJPEGRepresentation(background,1.0) writeToFile:[categoryPath stringByAppendingPathComponent:mapIDb] 
                                                    atomically:YES];
    }
    
    if (thumbnail) {
        [UIImageJPEGRepresentation(thumbnail,1.0) writeToFile:[categoryPath stringByAppendingPathComponent:mapIDt] 
                                                   atomically:YES];
    }
}



@end
