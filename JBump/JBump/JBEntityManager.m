//
//  JBEntityManager.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBEntityManager.h"
#import "JBEntity.h"

static NSString *filePath = @"entities";

@implementation JBEntityManager

+ (NSMutableArray*)getAllEntities {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
	NSArray* entityIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	
    NSMutableArray* entities = [NSMutableArray array];
	for (NSString* entityID in entityIDs) {
		NSMutableDictionary* dict = 
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:entityID] stringByAppendingPathComponent:jbINFO]];
		
		NSString *imagePath = [path stringByAppendingPathComponent:entityID];
		UIImage* entityImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:jbIMAGE]];
        
		if (dict && entityImage) {
			[dict setObject:entityImage forKey:jbIMAGE];
            [entities addObject:dict];
		}
		
	}
    NSMutableArray *allEntities = [NSMutableArray array];
    for (NSMutableDictionary *entityDict in entities) {
        JBEntity *aEntity = [[JBEntity alloc] initWithEntityDictionary:entityDict];
        [allEntities addObject:aEntity];
        [aEntity release];
    }
    
    return allEntities;
}

+ (JBEntity *)getEntityWithID:(NSString *)entityID {
    NSString *path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    path = [path stringByAppendingPathComponent:entityID];
    
    NSMutableDictionary* dict = 
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:jbINFO]];
    UIImage* entityImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:jbIMAGE]];
    
    if (dict && entityImage) {
        [dict setObject:entityImage forKey:jbIMAGE];
    }

    JBEntity *entity = [[[JBEntity alloc] initWithEntityDictionary:dict] autorelease];
    return entity;
}

+ (bool)saveNewEntity:(NSMutableDictionary *)entityDict entityImage:(UIImage *)image {
    NSString *folderName = [entityDict valueForKey:jbID];
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
    
    if (image){
        [UIImagePNGRepresentation(image) writeToFile:[path stringByAppendingPathComponent:jbIMAGE] atomically:YES];
        [entityDict setValue:[path stringByAppendingPathComponent:jbIMAGE] forKey:jbIMAGELOCATION];
        [entityDict removeObjectForKey:jbIMAGE];
    }
    
    [entityDict writeToFile:[path stringByAppendingPathComponent:jbINFO] atomically:YES];
    
    if (error!=nil)
        return NO;
    return YES;
}

+ (NSArray*)getAllEntityIDs {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
	NSArray* entityIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    return entityIDs;
}

+ (void)saveRessourceEntities {
    NSMutableDictionary *entity = [NSMutableDictionary dictionary];
    UIImage *entityImage = [UIImage imageNamed:@"entity_1.png"];
    
    [entity setValue:@"spawnpoint" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"hero spawn" forKey:jbNAME];
    [entity setValue:@"hero spawn here" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.8f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.7f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.0f, 40.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.0f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_GHOST forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"bottle_1.png"];
    [entity setValue:@"bottle_1" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Beer Bottle" forKey:jbNAME];
    [entity setValue:@"Cheers!" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(15.0f, 60.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"bottle_2.png"];
    [entity setValue:@"bottle_2" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Water Bottle" forKey:jbNAME];
    [entity setValue:@"Take a sip!" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(16.0f, 60.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_01.png"];
    [entity setValue:@"box_01" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Mini Box" forKey:jbNAME];
    [entity setValue:@"Diagonal" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.f, 40.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_02.png"];
    [entity setValue:@"box_02" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Big Box!" forKey:jbNAME];
    [entity setValue:@"Diagonal" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(80.0f, 80.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_03.png"];
    [entity setValue:@"box_03" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Medium Box" forKey:jbNAME];
    [entity setValue:@"Diagonal" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 60.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_04.png"];
    [entity setValue:@"box_04" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Big Box!" forKey:jbNAME];
    [entity setValue:@"Parallel" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(80.0f, 80.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_05.png"];
    [entity setValue:@"box_05" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Medium Box" forKey:jbNAME];
    [entity setValue:@"Parallel" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 60.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_BOX forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_01.png"];
    [entity setValue:@"ball_01" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Golf" forKey:jbNAME];
    [entity setValue:@"EAGLE" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(20.0f, 20.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_CIRCLE forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_02.png"];
    [entity setValue:@"ball_02" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Golf" forKey:jbNAME];
    [entity setValue:@"birdie" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.0f, 40.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_CIRCLE forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_03.png"];
    [entity setValue:@"ball_03" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Soccer" forKey:jbNAME];
    [entity setValue:@"Size 1" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40, 40.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_CIRCLE forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_04.png"];
    [entity setValue:@"ball_04" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Soccer" forKey:jbNAME];
    [entity setValue:@"Size 4" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 60.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_CIRCLE forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_05.png"];
    [entity setValue:@"ball_05" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Ball" forKey:jbNAME];
    [entity setValue:@"small fun" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.4f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.0f, 39.0f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_CIRCLE forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_06.png"];
    [entity setValue:@"ball_06" forKey:jbID];
    [entity setValue:entityImage forKey:jbIMAGE];
    [entity setValue:@"Ball" forKey:jbNAME];
    [entity setValue:@"BIG FUN!" forKey:jbFURTHER];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:jbFRICTION];
    [entity setValue:[NSNumber numberWithFloat:0.4f] forKey:jbRESTITUTION];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 59.f)) forKey:jbSIZE];
    [entity setValue:jbENTITY_SHAPE_CIRCLE forKey:jbSHAPE];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:jbDENSITY];
    [entity setValue:jbENTITY_BODYTYPE_DENSE forKey:jbBODYTYPE];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
}

@end
