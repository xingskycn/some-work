//
//  JBMapStore.m
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/5/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import "JBMapStore.h"

@implementation JBMapStore

- (NSArray *)getCategories
{
    NSLog(@"Class Method %@ not implemented by subclass", NSStringFromSelector(_cmd));
    return nil;
}

- (NSArray *)getMapsForCategory:(NSUInteger)categoryNr
{
    NSLog(@"Class Method %@ not implemented by subclass", NSStringFromSelector(_cmd));
    return nil;
}

- (NSDictionary *)getMapInformationForMapID:(NSString *)mapID
{
    NSLog(@"Class Method %@ not implemented by subclass", NSStringFromSelector(_cmd));
    return nil;
}

- (UIImage *)imageForMapID:(NSString *)aMapID
{
    NSLog(@"Class Method %@ not implemented by subclass", NSStringFromSelector(_cmd));
    return nil;
}

- (void)getMapCharacteristicsFor:(int *)category 
                           mapID:(NSString *)mapID
                        delegate:(id<JBMapStoreGetDelegate>)delegate
{
    NSLog(@"Class Method %@ not implemented by subclass", NSStringFromSelector(_cmd));
}

- (void)getImageType:(int)type
        fromCategory:(int)categoryNr
            forMapID:(NSString *)mapID 
            delegate:(id<JBMapStoreGetDelegate>)delegate
{
     NSLog(@"Class Method %@ not implemented by subclass", NSStringFromSelector(_cmd));
}

@end
