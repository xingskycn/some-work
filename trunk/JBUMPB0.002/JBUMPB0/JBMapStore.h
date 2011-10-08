//
//  JBMapStore.h
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/5/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JBMapStoreGetDelegate <NSObject>

- (void)finishedLoadingImage:(UIImage *)image
                     forType:(int)type
                  categoryNr:(int)categoryNr
                       mapID:(NSString *)mapID;

- (void)failedLoadingImageForType:(int)type
                       categoryNr:(int)categoryNr
                            mapID:(NSString *)mapID;

@end


@interface JBMapStore : NSObject

- (NSArray *)getCategories;
- (NSArray *)getMapsForCategory:(NSUInteger)categoryNr;
- (NSDictionary *)getMapInformationForMapID:(NSString *)mapID;
- (void)getMapCharacteristicsFor:(int *)category 
                           mapID:(NSString *)mapID
                        delegate:(id<JBMapStoreGetDelegate>)delegate;

- (void)getImageType:(int)type
        fromCategory:(int)categoryNr
            forMapID:(NSString *)mapID 
            delegate:(id<JBMapStoreGetDelegate>)delegate;

@end


// http://haqu.net