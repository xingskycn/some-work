//
//  JBProgressView.m
//  JBump
//
//  Created by Nils Ziehn on 10/12/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBProgressView.h"

@implementation JBProgressView

- (void)transferWithID:(NSString*)transferID updatedProgress:(float)progress
{
    self.progress = progress;
}

@end
