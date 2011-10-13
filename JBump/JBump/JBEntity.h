//
//  JBEntity.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JBMapItem.h"
#import "Box2D.h"
@interface JBEntity : JBMapItem

@property (assign)CGPoint position;
@property (assign)CGSize size;
@property (assign)float density;
@property (nonatomic, retain) NSString* shape;
@property (nonatomic, retain) NSString* bodyType;
@property (assign)b2Body *body;
@property (assign) BOOL shootable;
@property (assign) double shottime;
@property (assign) BOOL needsSend;

- (id)initWithEntityDictionary:(NSDictionary*)entityDict;

@end
