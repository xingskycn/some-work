//
//  JBBrush.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBBrush.h"

@implementation JBBrush

@synthesize friction;
@synthesize restitution;

@synthesize red, green, blue, alpha;

- (id)initWithBrushDict:(NSDictionary *)brushDict {
    self = [super init];
    
    if (self) {
        self.ID = [brushDict objectForKey:jbID];
        self.name = [brushDict objectForKey:jbNAME];
        self.further = [brushDict objectForKey:jbFURTHER];
        
        self.image = [brushDict objectForKey:jbTHUMBNAIL];
        self.imageLocal = [brushDict objectForKey:jbTHUMBNAILLOCATION];
        self.imageURL = [brushDict objectForKey:jbTHUMBNAILURL];
        
        self.friction = [[brushDict objectForKey:jbFRICTION] floatValue];
        self.restitution = [[brushDict objectForKey:jbRESTITUTION] floatValue];
        
        self.red = [[brushDict objectForKey:jbRED] floatValue];
        self.green = [[brushDict objectForKey:jbGREEN] floatValue];
        self.blue = [[brushDict objectForKey:jbBLUE] floatValue];
        self.alpha = [[brushDict objectForKey:jbALPHA] floatValue];
    }
    
    return self;
}

@end
