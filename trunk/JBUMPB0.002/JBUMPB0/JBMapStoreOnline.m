//
//  JBMapStoreOnline.m
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/6/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import "JBMapStoreOnline.h"

@implementation JBMapStoreOnline

- (void)downloadImageType:(int)type
             fromCategory:(int)categoryNr
                 forMapID:(NSString *)mapID 
                 delegate:(id<JBMapStoreGetDelegate>)delegate
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:delegate forKey:@"delegate"];
    [dict setObject:mapID forKey:@"mapID"];
    [dict setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dict setObject:[NSNumber numberWithInt:categoryNr] forKey:@"category"];
    
    [self performSelectorInBackground:@selector(downloadImageWithDict:) withObject:dict];
}

- (void)downloadImageWithDict:(NSDictionary *)dict
{
    id<JBMapStoreGetDelegate> delegate = [dict objectForKey:@"delegate"];
    int type = [[dict objectForKey:@"type"] intValue];
    int categoryNr = [[dict objectForKey:@"category"] intValue];
    NSString* mapID = [dict objectForKey:@"mapID"];
    
    NSString* tail;
    NSString* baseURL = @"http://home.in.tum.de/~ziehn/test";
    switch (type) {
        case 0:
            tail = @"i";
            break;
        case 1:
            tail = @"o";
            break;
        case 2:
            tail = @"b";
            break;
        case 3:
            tail = @"t";
            break;
            
        default:
            break;
    }
    NSString* urlStr = [NSString stringWithFormat:@"%@_%d_%@_%@",baseURL,categoryNr,mapID,tail];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    [delegate finishedLoadingImage:img forType:type categoryNr:categoryNr mapID:mapID];
}

@end
