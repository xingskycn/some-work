//
//  APMap.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APMap.h"

#import "APChar.h"
#import "APMapField.h"
#import "APMapDict.h"

@implementation APMap

@synthesize mapWidth;
@synthesize mapHeight;
@synthesize mapCharacteristics;
@synthesize mapID;
@synthesize gravity;
@synthesize waterGravity;

+ (APMap *)mapForMapID:(NSString *)aMapID
{
	NSDictionary* info = [[APMapDict single] getMapInformationForMapID:aMapID];
	UIImage* animage;
	char* mc;
	if ([aMapID hasPrefix:@"r"]) {
		int mapCount = [[info objectForKey:@"map_count"] intValue];
		int randomNr = rand()*0.999/RAND_MAX * (mapCount-1);
		
		NSString* imageID = [NSString stringWithFormat:@"%@_%02d",aMapID,randomNr];
		[[APMapDict single] getMapCharacteristicsForMapID:imageID toField:&mc];
		animage = [[APMapDict single] imageForMapID:imageID];
	}else {
		animage = [[APMapDict single] imageForMapID:aMapID];
		[[APMapDict single] getMapCharacteristicsForMapID:aMapID toField:&mc];
	}

	int width = [[info objectForKey:@"width"] intValue];
	int height = [[info objectForKey:@"height"] intValue];
	
	
	APMap* map = [[APMap alloc] initWithImage:animage width:width height:height matrix:mc];
	
	map.mapID = aMapID;
	
	map.gravity = CGPointMake([info objectForKey:@"gravity_x"]?[[info objectForKey:@"gravity_x"] floatValue]:0, 
							  [info objectForKey:@"gravity_y"]?[[info objectForKey:@"gravity_y"] floatValue]:1);
	
	map.waterGravity = CGPointMake([info objectForKey:@"water_gravity_x"]?[[info objectForKey:@"water_gravity_x"] floatValue]:0, 
								   [info objectForKey:@"water_gravity_y"]?[[info objectForKey:@"water_gravity_y"] floatValue]:-2);
	
	return [map autorelease];
}



//
// anImage is the background_image of the Map
// width is the width of the matrix
// height is the height of the matrix, width*height = initMatrix.size
// matrix is the table of map contents ( stone, water, air... )
//
- (id)initWithImage:(UIImage *)anImage width:(int)width height:(int)height matrix:(char *)initMatrix
{
	if (self = [super initWithImage:anImage]) {
		self.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2);
		mapWidth = width;
		mapHeight = height;
		
		mapCharacteristics = malloc(width*height*sizeof(char));
		for (int y=0; y<height; y++) {
			for (int x=0; x<width; x++) {
				mapCharacteristics[x+y*width] = initMatrix[x+ y*width];
			}
		}
		
	}else {
		NSLog(@"Cant initialize APMap");
	}
	return self;
}

- (int)X:(int)x Y:(int)y
{
	return mapCharacteristics[x+ y*mapWidth];
}

- (void)calculateMapInteractionForChar:(APChar *)chr activeUserInput:(BOOL)activeUserInput
{
	APMapField* field = [APMapField new];
	int fieldNrX = ((int)chr.position.x-self.frame.origin.x)/field.size.width;
	int fieldNrY = ((int)chr.position.y-self.frame.origin.y)/field.size.height;
	
	NSMutableArray* mapFields = [NSMutableArray array];
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			if (fieldNrX-1+i>=0 && fieldNrX-1+i<mapWidth && fieldNrY-1+j>= 0 && fieldNrY-1+j<mapHeight) {
				APMapField* field = [APMapField new];
				[mapFields addObject:field];
				CGPoint fieldPos = CGPointMake((fieldNrX-1+i)*field.size.width+self.frame.origin.x,(fieldNrY-1+j)*field.size.height);
				[field resetWithPos:fieldPos type:[self X:fieldNrX-1+i Y:fieldNrY-1+j]];
				field.relativeChr = chr;
				[field release];
			}
		}
	}
	[mapFields sortUsingSelector:@selector(compareDistanceWithField:)];
	
	for (int i = 0; i < [mapFields count]; i++) {
		APMapField* field = [mapFields objectAtIndex:i];
		chr.speed = [field getNewSpeedForChar:chr];
	}
	[field release];
}

- (void)dealloc {
	free(mapCharacteristics);
    [super dealloc];
}

- (BOOL)canPass:(int)type
{
	if (type == 0) {
		return TRUE;
	}
	else {
		return FALSE;
	}

}

- (void)generatePaths
{
	struct Path** paths;
	
	for (int i = 0; i < mapWidth; i++) {
		for (int j = 0; j < mapWidth; j++) {
			int type = [self X:i Y:j];
			
			if ([self canPass:type]) {
				struct Path* root = malloc(sizeof(struct Path));
				paths[i+j*mapWidth] = root;	
				root->x = i;
				root->y = j;
				struct Path* variable;
				
				if (i-1>=0 && i-1<mapWidth) {
					int otype = [self X:i-1 Y:j];
					if ([self canPass:otype]) {
						root->deeper = malloc(sizeof(struct Path));
						root->deeper->x = i-1;
						root->deeper->y = j;
						root->deeper->weight = 1;
						variable = root->deeper;
					}
				}
				
				if (i>=0 && i<mapWidth && j-1>=0) {
					int otype = [self X:i Y:j-1];
					if ([self canPass:otype]) {
						root->deeper = malloc(sizeof(struct Path));
						root->deeper->x = i;
						root->deeper->y = j-1;
						root->deeper->weight = 1;
						root->deeper->parent = root;
						root->deeper->sameDepth = variable;
						variable = root->deeper;
						[self getPathForNode:variable height:2];
					}
				}
				
				if (i+1>=0 && i+1<mapWidth) {
					int otype = [self X:i+1 Y:j];
					if ([self canPass:otype]) {
						root->deeper = malloc(sizeof(struct Path));
						root->deeper->x = i+1;
						root->deeper->y = j;
						root->deeper->parent = root;
						root->deeper->weight = 1;
						root->deeper->sameDepth = variable;
					}
				}
				
				
			}else {
				paths[i+j*mapWidth] = NULL;
			}
		}
	}
}

- (void)getPathForNode:(struct Path*)node height:(int)heightDiff
{
	struct Path* variable = node;
	if (node->x-1>=0 && node->x-1<mapWidth) {
		int otype = [self X:node->x-1 Y:node->y];
		if ([self canPass:otype]) {
			node->deeper = malloc(sizeof(struct Path));
			node->deeper->x = node->x-1;
			node->deeper->y = node->y;
			node->deeper->parent = node;
			node->deeper->weight = node->weight+1;
			variable = node->deeper;
		}
	}
	
	if (heightDiff-->0 && node->x>=0 && node->x<mapWidth && node->y-1>=0) {
		int otype = [self X:node->x Y:node->y];
		if ([self canPass:otype]) {
			node->deeper = malloc(sizeof(struct Path));
			node->deeper->x = node->x;
			node->deeper->y = node->y;
			node->deeper->weight = node->weight+1;
			node->deeper->parent = node;
			node->deeper->sameDepth = variable;
			variable = node->deeper;
			[self getPathForNode:variable height:heightDiff];
		}
	}
	
	if (node->x+1>=0 && node->x+1<mapWidth) {
		int otype = [self X:node->x+1 Y:node->y];
		if ([self canPass:otype]) {
			node->deeper = malloc(sizeof(struct Path));
			node->deeper->x = node->x-1;
			node->deeper->y = node->y;
			node->deeper->parent = node;
			node->deeper->weight = node->weight+1;
			node->deeper->sameDepth = variable;
		}
	}
}

@end
