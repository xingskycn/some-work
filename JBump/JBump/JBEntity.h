//
//  JBEntity.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JBMapItem.h"

@interface JBEntity : JBMapItem

@property (assign)CGPoint position;
@property (assign)CGSize size;
@property (assign)float density;
@property (nonatomic, retain) NSString* shape;
@property (nonatomic, retain) NSString* bodyType;

- (id)initWithEntityDictionary:(NSDictionary*)entityDict;

@end
