//
//  APSkinDict.m
//  AP
//
//  Created by Nils Ziehn on 18.06.11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import "APSkinDict.h"


@implementation APSkinDict

static APSkinDict* single;

+ (APSkinDict *)single
{
	if (!single) {
		single = [APSkinDict new];
	}
	return single;
}

- (id)init
{
	if (self = [super init]) {
		NSArray* array = [NSArray arrayWithObjects:[UIImage imageNamed:@"bird_1.png"],
						  [UIImage imageNamed:@"bunny_1.png"],
						  [UIImage imageNamed:@"bunny_2.png"],
						  [UIImage imageNamed:@"scel_1.png"],
						  [UIImage imageNamed:@"scel_2.png"],
						  [UIImage imageNamed:@"bull_1.png"],nil];
		
		
		for (UIImage* image in array) {
			NSMutableDictionary* dict = [NSMutableDictionary dictionary];
			[dict setObject:image forKey:@"image"];
			[dict setObject:[NSString stringWithFormat:@"%d",[array indexOfObject:image]] forKey:@"skin_ID"];
			[dict setObject:[NSString stringWithFormat:@"name%d",[array indexOfObject:image]] forKey:@"skin_name"];
			[self skinLoaded:dict];
		}
		
		NSLog(@"listSkins: %@",[self listSkins]);
		
	}
	return self;
}


- (BOOL)skinLoadedForID:(NSString *)skinID
{
	NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [NSString stringWithFormat:@"%@/skins/info/%@",[paths objectAtIndex:0],skinID];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (void)loadSkinForID:(NSString *)skinID
{
	
}

- (void)skinLoaded:(NSMutableDictionary *)dict
{
	UIImage* image = [dict objectForKey:@"image"];
	[dict removeObjectForKey:@"image"];
	
	NSString* basename = [dict objectForKey:@"skin_ID"];
	
	
	NSError* error;
	NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"skins"];
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

	
	if (![self skinLoadedForID:basename]) {
		[dict writeToFile:[infoPath stringByAppendingPathComponent:basename] atomically:YES];
		[UIImagePNGRepresentation(image) writeToFile:[imagePath stringByAppendingPathComponent:basename] atomically:YES];
	}
}

- (NSArray *)listSkins
{
	NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"skins/info/"];
	NSArray* skinIDs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	
	NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"skins/image/"];
	
	NSMutableArray* skins = [NSMutableArray array];
	for (NSString* skinID in skinIDs) {
		NSMutableDictionary* dict = 
			[NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:skinID]];
		
		
		UIImage* skinImage = [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:skinID]];
		
		if (dict && skinImage) {
			[dict setObject:skinImage forKey:@"image"];
			[skins addObject:dict];
		}
		
	}
	
    return skins;
}

- (UIImage *)imageForSkinID:(NSString *)skinID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"skins/image/"];
	
	return [UIImage imageWithContentsOfFile:[imagePath stringByAppendingPathComponent:skinID]];
}

- (NSString *)nameForSkinID:(NSString *)skinID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *infoPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"skins/info/"];
	
	return [[NSDictionary dictionaryWithContentsOfFile:[infoPath stringByAppendingPathComponent:skinID]] objectForKey:@"skin_name"];
}

@end
