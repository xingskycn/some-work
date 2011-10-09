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

+ (NSMutableArray*)getAllEnteties {
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
    NSMutableArray *allEnteties = [NSMutableArray array];
    for (NSMutableDictionary *entityDict in entities) {
        JBEntity *aEntity = [[JBEntity alloc] initWithEntityDictionary:entityDict];
        [allEnteties addObject:aEntity];
        [aEntity release];
    }
    
    return allEnteties;
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

@end