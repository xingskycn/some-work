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
        [NSMutableDictionary dictionaryWithContentsOfFile:[[path stringByAppendingPathComponent:entityID] stringByAppendingPathComponent:@"entityInfo"]];
		
		NSString *imagePath = [path stringByAppendingPathComponent:entityID];
		UIImage* entityImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:@"entityImage"]];
        
		if (dict && entityImage) {
			[dict setObject:entityImage forKey:@"entityImage"];
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
    [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"entityInfo"]];
    UIImage* entityImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"entityImage"]];
    
    if (dict && entityImage) {
        [dict setObject:entityImage forKey:@"entityImage"];
    }

    JBEntity *entity = [[[JBEntity alloc] initWithEntityDictionary:dict] autorelease];
    NSLog(@"entity shale?%@",entity.shape);
    return entity;
}

+ (bool)saveNewEntity:(NSMutableDictionary *)entityDict entityImage:(UIImage *)image {
    NSString *folderName = [entityDict valueForKey:@"entityID"];
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
        [UIImagePNGRepresentation(image) writeToFile:[path stringByAppendingPathComponent:@"entityImage"] atomically:YES];
        [entityDict setValue:[path stringByAppendingPathComponent:@"entityImage"] forKey:@"imageLocation"];
        [entityDict removeObjectForKey:@"entityImage"];
    }
    
    [entityDict writeToFile:[path stringByAppendingPathComponent:@"entityInfo"] atomically:YES];
    
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
    
    [entity setValue:@"entity_1" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"hero spawn" forKey:@"name"];
    [entity setValue:@"hero spawn here" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.8f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.7f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.0f, 40.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.0f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"bottle_1.png"];
    [entity setValue:@"bottle_1" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Beer Bottle" forKey:@"name"];
    [entity setValue:@"Cheers!" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(15.0f, 60.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"bottle_2.png"];
    [entity setValue:@"bottle_2" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Water Bottle" forKey:@"name"];
    [entity setValue:@"Take a sip!" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(16.0f, 60.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_01.png"];
    [entity setValue:@"box_01" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Mini Box" forKey:@"name"];
    [entity setValue:@"Diagonal" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.f, 40.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_02.png"];
    [entity setValue:@"box_02" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Big Box!" forKey:@"name"];
    [entity setValue:@"Diagonal" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(80.0f, 80.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_03.png"];
    [entity setValue:@"box_03" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Medium Box" forKey:@"name"];
    [entity setValue:@"Diagonal" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 60.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_04.png"];
    [entity setValue:@"box_04" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Big Box!" forKey:@"name"];
    [entity setValue:@"Parallel" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(80.0f, 80.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"box_05.png"];
    [entity setValue:@"box_05" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Medium Box" forKey:@"name"];
    [entity setValue:@"Parallel" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 60.0f)) forKey:@"size"];
    [entity setValue:@"box" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_01.png"];
    [entity setValue:@"ball_01" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Golf" forKey:@"name"];
    [entity setValue:@"EAGLE" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(20.0f, 20.0f)) forKey:@"size"];
    [entity setValue:@"circle" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_02.png"];
    [entity setValue:@"ball_02" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Golf" forKey:@"name"];
    [entity setValue:@"birdie" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.0f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.0f, 40.0f)) forKey:@"size"];
    [entity setValue:@"circle" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_03.png"];
    [entity setValue:@"ball_03" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Soccer" forKey:@"name"];
    [entity setValue:@"Size 1" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40, 40.0f)) forKey:@"size"];
    [entity setValue:@"circle" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_04.png"];
    [entity setValue:@"ball_04" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Soccer" forKey:@"name"];
    [entity setValue:@"Size 4" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 60.0f)) forKey:@"size"];
    [entity setValue:@"circle" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_05.png"];
    [entity setValue:@"ball_05" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Ball" forKey:@"name"];
    [entity setValue:@"small fun" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.4f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(40.0f, 39.0f)) forKey:@"size"];
    [entity setValue:@"circle" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
    
    entity = [NSMutableDictionary dictionary];
    entityImage = [UIImage imageNamed:@"ball_06.png"];
    [entity setValue:@"ball_06" forKey:@"entityID"];
    [entity setValue:entityImage forKey:@"entityImage"];
    [entity setValue:@"Ball" forKey:@"name"];
    [entity setValue:@"BIG FUN!" forKey:@"further"];
    [entity setValue:[NSNumber numberWithFloat:0.3f] forKey:@"friction"];
    [entity setValue:[NSNumber numberWithFloat:0.4f] forKey:@"restitution"];
    [entity setValue:NSStringFromCGSize(CGSizeMake(60.0f, 59.f
                                                   
                                                   )) forKey:@"size"];
    [entity setValue:@"circle" forKey:@"shape"];
    [entity setValue:[NSNumber numberWithFloat:.3f] forKey:@"density"];
    [JBEntityManager saveNewEntity:entity entityImage:entityImage];
}

@end
