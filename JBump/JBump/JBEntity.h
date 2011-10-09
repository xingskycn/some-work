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

- (id)initWithEntityDictionary:(NSDictionary*)entityDict;

@end
