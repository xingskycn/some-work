//
//  JBMap.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBMap : NSObject

@property (nonatomic, retain)NSString *mapName;
@property (nonatomic, retain)NSString *mapID;
@property (nonatomic, retain)NSString *mapFurther;

@property (nonatomic, retain)UIImage *backgroundImage;
@property (nonatomic, retain)NSString *backgroundImageLocal;
@property (nonatomic, retain)NSString *backgroundImageURL;

@property (nonatomic, retain)UIImage *arenaImage;
@property (nonatomic, retain)NSString *arenaImageLocal;
@property (nonatomic, retain)NSString *arenaImageURL;

@property (nonatomic, retain)UIImage *overlayImage;
@property (nonatomic, retain)NSString *overlayImageLocal;
@property (nonatomic, retain)NSString *overlayImageURL;

//only a Dictionary with position and entityID
@property (nonatomic, retain)NSMutableArray *mapEntities;
@property (nonatomic, retain)NSMutableArray *curves;

- (id)initWithDictionary:(NSDictionary*)mapDict;

@end
