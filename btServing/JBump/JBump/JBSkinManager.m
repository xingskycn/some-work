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
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:skinID] stringByAppendingPathComponent:jbINFO]];
		
		NSString *imagePath = [path stringByAppendingPathComponent:skinID];
		UIImage* skinImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:jbIMAGE]];
		
        NSString *thumbPath = [path stringByAppendingPathComponent:skinID];
        UIImage* thumbImage = [UIImage imageWithContentsOfFile:[thumbPath stringByAppendingPathComponent:jbTHUMBNAIL]];
        
		if (dict && skinImage && thumbImage) {
			[dict setObject:skinImage forKey:jbIMAGE];
			[dict setObject:thumbImage forKey:jbTHUMBNAIL];
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
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:jbINFO]];
    UIImage* skinImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:jbIMAGE]];
    UIImage* thumbImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:jbTHUMBNAIL]];
    if (dict && skinImage) {
        [dict setObject:skinImage forKey:jbIMAGE];
    }
    
    if (dict && thumbImage) {
        [dict setObject:thumbImage forKey:jbTHUMBNAIL];
    }
    
    JBSkin *skin = [[[JBSkin alloc] initWithDictionary:dict] autorelease];
    
    return skin;
}


+ (bool)saveNewSkin:(NSMutableDictionary*)skinDict withThumbnail:(UIImage*)thumbnail andSkin:(UIImage*)skin andBlue:(UIImage *)blue andRed:(UIImage *)red{
    NSString *folderName = [skinDict valueForKey:jbID];
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
        [UIImagePNGRepresentation(thumbnail) writeToFile:[path stringByAppendingPathComponent:jbTHUMBNAIL] atomically:YES];
        [skinDict setValue:[path stringByAppendingPathComponent:jbTHUMBNAIL] forKey:jbTHUMBNAILLOCATION];
        [skinDict removeObjectForKey:jbTHUMBNAIL];
    }
    if (skin){
        [UIImagePNGRepresentation(skin) writeToFile:[path stringByAppendingPathComponent:jbIMAGE] atomically:YES];
        [skinDict setValue:[path stringByAppendingPathComponent:jbIMAGE] forKey:jbIMAGELOCATION];
        [skinDict removeObjectForKey:jbIMAGE];
    }
    if (blue){
        [UIImagePNGRepresentation(blue) writeToFile:[[path stringByAppendingPathComponent:jbIMAGE] stringByAppendingString:@"_blue"] atomically:YES];
    }
    if (red){
        [UIImagePNGRepresentation(red) writeToFile:[[path stringByAppendingPathComponent:jbIMAGE] stringByAppendingString:@"_red"] atomically:YES];
    }
    
    [skinDict writeToFile:[path stringByAppendingPathComponent:jbINFO] atomically:YES];
    
    if (error!=nil)
        return NO;
    return YES;
}

+(NSArray *)getAllSkinIDs {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
	NSArray* skinIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    return skinIDs;
}

+ (void)saveRessourceSkins {
    NSMutableDictionary *skin = [NSMutableDictionary dictionary];
    
    UIImage *skinImage = [UIImage imageNamed:@"bull_1.png"];
    UIImage *thumb = [UIImage imageNamed:@"bull_1.png"];
    UIImage * blue = [UIImage imageNamed:@"bull_1_blue.png"];
    UIImage * red = [UIImage imageNamed:@"bull_1_red.png"];
    
    [skin setValue:@"bull1" forKey:jbID];
    [skin setValue:@"bull1" forKey:jbNAME];
    [skin setValue:thumb forKey:jbTHUMBNAIL];
    [skin setValue:skinImage forKey:jbIMAGE];
    [skin setValue:@"LocalImage_Bull1" forKey:jbFURTHER];
    
    [JBSkinManager saveNewSkin:skin withThumbnail:thumb andSkin:skinImage andBlue:blue andRed:red];

    blue = [UIImage imageNamed:@"bunny_2_blue.png"];
    red = [UIImage imageNamed:@"bunny_2_red.png"];
    skinImage = [UIImage imageNamed:@"bunny_2.png"];
    thumb = [UIImage imageNamed:@"bunny_2.png"];
    
    [skin setValue:@"bunny2" forKey:jbID];
    [skin setValue:@"bunny2" forKey:jbNAME];
    [skin setValue:thumb forKey:jbTHUMBNAIL];
    [skin setValue:skin forKey:jbIMAGE];
    [skin setValue:@"LocalImage_bunny2" forKey:jbFURTHER];
    
    [JBSkinManager saveNewSkin:skin withThumbnail:thumb andSkin:skinImage andBlue:blue andRed:red];
    
    blue = [UIImage imageNamed:@"scel2_blue.png"];
    red = [UIImage imageNamed:@"scel2_red.png"];
    skinImage = [UIImage imageNamed:@"scel_2.png"];
    thumb = [UIImage imageNamed:@"scel_2.png"];
    
    [skin setValue:@"scel2" forKey:jbID];
    [skin setValue:@"scel2" forKey:jbNAME];
    [skin setValue:thumb forKey:jbTHUMBNAIL];
    [skin setValue:skinImage forKey:jbIMAGE];
    [skin setValue:@"LocalImage_scel2" forKey:jbFURTHER];
    
    [JBSkinManager saveNewSkin:skin withThumbnail:thumb andSkin:skinImage andBlue:blue andRed:red];
}


@end
