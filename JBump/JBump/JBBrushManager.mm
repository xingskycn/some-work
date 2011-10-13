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
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:brushID] stringByAppendingPathComponent:jbINFO]];
		
		NSString *thumbnailPath = [path stringByAppendingPathComponent:brushID];
		UIImage* brushThumbnail = [UIImage imageWithContentsOfFile:[thumbnailPath stringByAppendingPathComponent:jbTHUMBNAIL]];
        
		if (dict && brushThumbnail) {
			[dict setObject:brushThumbnail forKey:jbTHUMBNAIL];
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
    NSString *folderName = [brushDict valueForKey:jbID];
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
        [brushDict setValue:[path stringByAppendingPathComponent:jbTHUMBNAIL] forKey:jbTHUMBNAILLOCATION];
        [brushDict removeObjectForKey:jbTHUMBNAIL];
    }
    
    [brushDict writeToFile:[path stringByAppendingPathComponent:jbINFO] atomically:YES];
    
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
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:jbINFO]];
    UIImage* thumbnail = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:jbTHUMBNAIL]];
    
    if (dict && thumbnail) {
        [dict setObject:thumbnail forKey:jbTHUMBNAIL];
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
    
    UIImage *brushImage = [UIImage imageNamed:@"brush_1.png"];
    [brush setValue:jBBRUSH_GOALLINE_TEAM1 forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"goal line" forKey:jbNAME];
    [brush setValue:@"team 1" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
    
    brushImage = [UIImage imageNamed:@"brush_2.png"];
    [brush setValue:jbBRUSH_PLATFORM forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"platform" forKey:jbNAME];
    [brush setValue:@"passable from bottom" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
    
    brushImage = [UIImage imageNamed:@"brush_3.png"];
    [brush setValue:jBBRUSH_GOALLINE_TEAM2 forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"goal line" forKey:jbNAME];
    [brush setValue:@"team 2" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];

    /*
    brushImage = [UIImage imageNamed:@"brush_4.png"];
    [brush setValue:jbBRUSH_DEATH forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"death" forKey:jbNAME];
    [brush setValue:@"DIE ON CONTACT!" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:.5f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
 */
    /*
    brushImage = [UIImage imageNamed:@"brush_5.png"];
    [brush setValue:jbBRUSH_DOORLEFT forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"exit only" forKey:jbNAME];
    [brush setValue:@"heros can pass from left" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
    */
    
    
    brushImage = [UIImage imageNamed:@"brush_6.png"];
    [brush setValue:jbBRUSH_HORIZONTAL_PLATFORM forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"platform" forKey:jbNAME];
    [brush setValue:@"horizontal platform" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:0.5f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
    /*
    brushImage = [UIImage imageNamed:@"brush_7.png"];
    [brush setValue:jbBRUSH_ASSEMBLYLEFT forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"assembly line" forKey:jbNAME];
    [brush setValue:@"rolling to left" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
    */
    
    /*
    brushImage = [UIImage imageNamed:@"brush_8.png"];
    [brush setValue:jbBRUSH_ASSEMBLYRIGHT forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"assembly line" forKey:jbNAME];
    [brush setValue:@"rolling to right" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:.5f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
    */
    
    brushImage = [UIImage imageNamed:@"brush_9.png"];
    [brush setValue:jbBRUSH_SOLID forKey:jbID];
    [brush setValue:brushImage forKey:jbTHUMBNAIL];
    [brush setValue:@"solid" forKey:jbNAME];
    [brush setValue:@"concrete" forKey:jbFURTHER];
    [brush setValue:[NSNumber numberWithFloat:0.4f] forKey:jbFRICTION];
    [brush setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [brush setValue:[NSNumber numberWithFloat:.8f] forKey:jbRED];
    [brush setValue:[NSNumber numberWithFloat:0.f] forKey:jbGREEN];
    [brush setValue:[NSNumber numberWithFloat:.8f] forKey:jbBLUE];
    [brush setValue:[NSNumber numberWithFloat:1.f] forKey:jbALPHA];
    [JBBrushManager saveNewBrush:brush thumbnail:brushImage];
}

@end
