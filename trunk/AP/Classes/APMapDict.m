//
//  APMapDict.m
//  AP
//
//  Created by Ziehn Nils on 6/22/11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import "APMapDict.h"

@implementation APMapDict


static APMapDict* single;

#pragma mark *PREPARATION

+ (APMapDict *)single
{
	if (!single) {
		single = [APMapDict new];
	}
	return single;
}

- (id)init
{
	if (self = [super init]) {
		
		/*char smc[] = {
		 1,1,1,1,	1,1,1,1,	1,1,1,1,	1,1,1,1,	1,1,1,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,5,1,
		 1,1,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,5,1,
		 1,1,1,0,	0,0,0,0,	3,0,0,0,	0,0,1,1,	1,1,5,1,
		 1,0,0,0,	0,0,1,1,	3,1,1,0,	0,0,0,0,	0,0,5,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,5,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,5,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,5,1,
		 1,0,0,0,	0,0,1,1,	3,1,1,1,	0,0,1,1,	1,1,1,1,
		 1,1,0,0,	0,0,0,0,	3,1,1,1,	1,1,1,1,	1,1,1,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,0,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,0,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,0,1,
		 1,0,0,0,	0,0,0,0,	3,0,0,0,	0,0,0,0,	0,0,0,1,
		 1,1,1,1,	1,1,1,1,	1,1,1,1,	1,1,1,1,	1,1,1,1};
		
		[self saveMapCharacteristics:smc legth:300 LoadedForID:@"s00005"];*/
		
		
		
		
		
		
		NSArray* stdMaps = [NSArray arrayWithObjects:[UIImage imageNamed:@"map1_mosaik_dark.png"],
						  [UIImage imageNamed:@"map1_mosaik.png"],
						  [UIImage imageNamed:@"map_1.png"],
						  [UIImage imageNamed:@"trees.png"],
						  [UIImage imageNamed:@"island.jpg"],
						  [UIImage imageNamed:@"fab.jpg"],nil];
		
		for (UIImage* image in stdMaps) {
			NSMutableDictionary* dict = [NSMutableDictionary dictionary];
			[dict setObject:image forKey:@"image"];
			[dict setObject:[NSString stringWithFormat:@"s%05d",[stdMaps indexOfObject:image]] forKey:@"map_ID"];
			[dict setObject:[NSString stringWithFormat:@"name%d",[stdMaps indexOfObject:image]] forKey:@"map_name"];
			[dict setObject:@"20" forKey:@"width"];
			if ([stdMaps indexOfObject:image]==3) {
				[dict setObject:@"10" forKey:@"height"];
			}else if ([stdMaps indexOfObject:image]==4) {
				[dict setObject:@"12" forKey:@"height"];
				[dict setObject:@"0" forKey:@"gravity_x"];
				[dict setObject:@"1" forKey:@"gravity_y"];
				[dict setObject:@"0" forKey:@"water_gravity_x"];
				[dict setObject:@"-.15" forKey:@"water_gravity_y"];
			}else if ([stdMaps indexOfObject:image]==5) {
				[dict setObject:@"15" forKey:@"height"];
				[dict setObject:@"0" forKey:@"gravity_x"];
				[dict setObject:@"1" forKey:@"gravity_y"];
				[dict setObject:@"0" forKey:@"water_gravity_x"];
				[dict setObject:@"-2" forKey:@"water_gravity_y"];
			
			}else
			{
				[dict setObject:@"8" forKey:@"height"];
			}

			
			[self newMapLoaded:dict];
			
			NSString* fileName = [NSString stringWithFormat:@"%@/s%05d",[[NSBundle mainBundle] resourcePath],[stdMaps indexOfObject:image]];
			
			NSArray* array = [NSArray arrayWithContentsOfFile:fileName];
			char* mc = malloc([array count]*sizeof(char));
			for (int i = 0; i < [array count]; i++) {
				mc[i] = [[array objectAtIndex:i] charValue];
			}
			
			[self saveMapCharacteristics:mc legth:[array count] LoadedForID:[NSString stringWithFormat:@"s%05d",[stdMaps indexOfObject:image]]];
		}
		
		NSArray * run = [NSArray arrayWithObjects:[UIImage imageNamed:@"run1_tile0.jpg"],
						 [UIImage imageNamed:@"run1_tile1.jpg"],
						 [UIImage imageNamed:@"run1_tile2.jpg"],
						 [UIImage imageNamed:@"run1_tile3.jpg"],
						 [UIImage imageNamed:@"run1_tile4.jpg"],nil];
		
		NSMutableDictionary* dict = [NSMutableDictionary dictionary];
		[dict setObject:[NSString stringWithFormat:@"r00000"] forKey:@"map_ID"];
		[dict setObject:[NSString stringWithFormat:@"run1"] forKey:@"map_name"];
		[dict setObject:[NSString stringWithFormat:@"5"] forKey:@"map_count"];
		[dict setObject:@"15" forKey:@"width"];
		[dict setObject:@"10" forKey:@"height"];
		[dict setObject:run forKey:@"images"];
		[self newMapLoaded:dict];
		
		for (UIImage* image in run) {
			NSString* fileName = [NSString stringWithFormat:@"%@/r00000_%02d",[[NSBundle mainBundle] resourcePath],[run indexOfObject:image]];
			
			NSArray* array = [NSArray arrayWithContentsOfFile:fileName];
			char* mc = malloc([array count]*sizeof(char));
			for (int i = 0; i < [array count]; i++) {
				mc[i] = [[array objectAtIndex:i] charValue];
			}
			
			[self saveMapCharacteristics:mc legth:[array count] LoadedForID:[NSString stringWithFormat:@"r00000_%02d",[run indexOfObject:image]]];
		}
	}
	return self;
}


- (BOOL)isMapLoadedForID:(NSString *)mapID
{
	NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [NSString stringWithFormat:@"%@/maps/info/%@",[paths objectAtIndex:0],mapID];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (void)loadMapForID:(NSString *)mapID
{
	
}

- (void)newMapLoaded:(NSMutableDictionary *)dict
{
	UIImage* image = [dict objectForKey:@"image"];
	[dict removeObjectForKey:@"image"];
	
	NSArray* images =  [dict objectForKey:@"images"];
	[dict removeObjectForKey:@"images"];
	
	NSString* basename = [dict objectForKey:@"map_ID"];
	
	
	NSError* error;
	NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps"];
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
	
	NSString* infoPath = [path stringByAppendingPathComponent:@"info"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:infoPath])
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:infoPath
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Create directory error: %@", error);
		}
	}
	
	NSString* imagePath = [path stringByAppendingPathComponent:@"image"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:imagePath
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Create directory error: %@", error);
		}
		
	}
	
	
	if (![self isMapLoadedForID:basename]) {
		[dict writeToFile:[infoPath stringByAppendingPathComponent:basename] atomically:YES];
		[UIImageJPEGRepresentation(image,1.0) writeToFile:[imagePath stringByAppendingPathComponent:basename] atomically:YES];
		for (int i = 0; i < [images count]; i++) {
			UIImage* image = [images objectAtIndex:i];
			NSString* imgName = [NSString stringWithFormat:@"%@_%02d",basename,i];
			[UIImageJPEGRepresentation(image,1.0) writeToFile:[imagePath stringByAppendingPathComponent:imgName] atomically:YES];
		}
	}
}


#pragma mark *GET METHODS
- (void)saveMapCharacteristics:(char*)mc legth:(int)length LoadedForID:(NSString *)mapID
{
	NSError* error;
	NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps"];
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
	
	NSString* infoPath = [path stringByAppendingPathComponent:@"mc"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:infoPath])
	{
		if (![[NSFileManager defaultManager] createDirectoryAtPath:infoPath
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error])
		{
			NSLog(@"Create directory error: %@", error);
		}
	}
	
	NSString *mcPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/mc/"];
	mcPath = [mcPath stringByAppendingPathComponent:mapID];
	NSMutableArray* array = [NSMutableArray array];
	for (int i = 0; i < length; i++) {
		[array addObject:[NSNumber numberWithChar:mc[i]]];
	}
	[array writeToFile:mcPath atomically:YES];
	
}

- (NSArray *)listMaps
{
	NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/info/"];
	NSArray* mapIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	
	NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/image/"];
	
	NSMutableArray* maps = [NSMutableArray array];
	for (NSString* mapID in mapIDs) {
		NSMutableDictionary* dict = 
		[NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:mapID]];
		
		
		UIImage* mapImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:mapID]];
		
		if (dict && mapImage) {
			[dict setObject:mapImage forKey:@"image"];
			
		}
		[maps addObject:dict];
		
	}
	
    return maps;
}

- (UIImage *)imageForMapID:(NSString *)mapID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/image/"];
	
	return [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:mapID]];
}

- (void)getMapCharacteristicsForMapID:(NSString *)mapID toField:(char**)mapCharacteristics
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *mcPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/mc/"];
	mcPath = [mcPath stringByAppendingPathComponent:mapID];
	NSArray* array = [NSArray arrayWithContentsOfFile:mcPath];
	char* mc = malloc([array count]*sizeof(char));
	for (int i = 0; i < [array count]; i++) {
		mc[i] = [[array objectAtIndex:i] charValue];
	}
	*mapCharacteristics = mc;
}



- (NSString *)nameForMapID:(NSString *)mapID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *infoPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/info/"];
	
	return [[NSDictionary dictionaryWithContentsOfFile:[infoPath stringByAppendingPathComponent:mapID]] objectForKey:@"map_name"];
}

- (NSDictionary *)getMapInformationForMapID:(NSString *)mapID
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *infoPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps/info/"];
	infoPath = [infoPath stringByAppendingPathComponent:mapID];
	
	return [NSDictionary dictionaryWithContentsOfFile:infoPath];
}

@end
