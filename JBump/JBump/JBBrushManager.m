//
//  JBBrushManager.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBBrushManager.h"
#import "JBBrush.h"

@implementation JBBrushManager

static NSString *filePath = @"brushes";

+ (NSMutableArray*)getAllBrushes {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
	NSArray* brushIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	
    NSMutableArray* brushes = [NSMutableArray array];
	for (NSString* brushID in brushIDs) {
		NSMutableDictionary* dict = 
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:brushID] stringByAppendingPathComponent:@"brushInfo"]];
		
		NSString *thumbnailPath = [path stringByAppendingPathComponent:brushID];
		UIImage* brushThumbnail = [UIImage imageWithContentsOfFile:[thumbnailPath stringByAppendingPathComponent:@"thumbnail"]];
        
		if (dict && brushThumbnail) {
			[dict setObject:brushThumbnail forKey:@"thumbnail"];
            [brushes addObject:dict];
		}
		
	}
    NSMutableArray *allBrushes = [NSMutableArray array];
    for (NSMutableDictionary *brushDict in brushes) {
        JBBrush *aBrush = [[JBBrush alloc] initWithBrushDict:brushDict];
        [allBrushes addObject:aBrush];
        [aBrush release];
    }
    
    return allBrushes;
}

+ (bool)saveNewBrush:(NSMutableDictionary *)brushDict thumbnail:(UIImage *)thumbnail {
    NSString *folderName = [brushDict valueForKey:@"brushID"];
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
        [UIImagePNGRepresentation(thumbnail) writeToFile:[path stringByAppendingPathComponent:@"thumbnail"] atomically:YES];
        [brushDict setValue:[path stringByAppendingPathComponent:@"thumbnail"] forKey:@"thumbnailLocation"];
        [brushDict removeObjectForKey:@"thumbnail"];
    }
    
    [brushDict writeToFile:[path stringByAppendingPathComponent:@"brushInfo"] atomically:YES];
    
    if (error!=nil)
        return NO;
    return YES;

}

+ (JBBrush*)getBrushForID:(NSString*)brushID {
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    path = [path stringByAppendingPathComponent:brushID];
    
    NSMutableDictionary* dict = 
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"brushInfo"]];
    UIImage* thumbnail = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"thumbnail"]];
    
    if (dict && thumbnail) {
        [dict setObject:thumbnail forKey:@"thumbnail"];
    }
    
    JBBrush *entity = [[[JBBrush alloc] initWithBrushDict:dict] autorelease];
    
    return entity;
}

+(NSArray *)getAllBrushIDs {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
	NSArray* brushIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    return brushIDs;
}

+ (void)saveRessourceBrushes {
    NSMutableDictionary *brush = [NSMutableDictionary dictionary];
    UIImage *brushImage = [UIImage imageNamed:@"redbrush.png"];
    
    [brush setValue:@"solid" forKey:@"brushID"];
    [brush setValue:brushImage forKey:@"thumbnail"];
    [brush setValue:@"concrete" forKey:@"brushName"];
    [brush setValue:@"stops move" forKey:@"further"];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:@"friction"];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:@"red"];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:@"green"];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:@"blue"];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:@"alpha"];
    
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
    
    [brush setValue:@"platform" forKey:@"brushID"];
    [brush setValue:brushImage forKey:@"thumbnail"];
    [brush setValue:@"platform" forKey:@"brushName"];
    [brush setValue:@"passable from bottom" forKey:@"further"];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:@"friction"];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:@"red"];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:@"green"];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:@"blue"];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:@"alpha"];
    
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
}

@end
