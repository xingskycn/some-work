//
//  JBTavern.h
//  JBump
//
//  Created by Nils Ziehn on 10/7/11.
//  Copyright (c) 2011 TU München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBHero;


@interface JBTavern : NSObject

@property (nonatomic, strong) JBHero* player;
@property (nonatomic, strong) NSMutableArray* array;

@end
