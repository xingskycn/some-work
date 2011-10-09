//
//  JBEntity.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBEntity : NSObject

@property (nonatomic, retain)NSString *entityID;
@property (nonatomic, retain)UIImage *entityImage;
@property (nonatomic, retain)NSString *localImage;
@property (nonatomic, retain)NSString *imageURL;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *further;
@property (assign)float friction;
@property (assign)float restitution;
@property (assign)CGPoint position;
@property (assign)CGSize size;

@end
