//
//  JBMap.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBMap : NSObject

@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *ID;
@property (nonatomic, retain)NSString *further;

@property (nonatomic, retain)UIImage *backgroundImage;
@property (nonatomic, retain)NSString *backgroundImageLocal;
@property (nonatomic, retain)NSString *backgroundImageURL;

@property (nonatomic, retain)UIImage *arenaImage;
@property (nonatomic, retain)NSString *arenaImageLocal;
@property (nonatomic, retain)NSString *arenaImageURL;

@property (nonatomic, retain)UIImage *overlayImage;
@property (nonatomic, retain)NSString *overlayImageLocal;
@property (nonatomic, retain)NSString *overlayImageURL;

@property (nonatomic, retain)UIImage* thumbnail;
@property (nonatomic, retain)NSString* thumbnailLocal;
@property (nonatomic, retain)NSString* thumbnailURL;

//only a Dictionary with position and entityID
@property (nonatomic, retain)NSMutableArray *mapEntities;
@property (nonatomic, retain)NSMutableArray *curves;

@property (nonatomic, retain)NSMutableArray* settings;

- (id)initWithDictionary:(NSDictionary*)mapDict;

@end
