//
//  JBProgressView.h
//  JBump
//
//  Created by Nils Ziehn on 10/12/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JBProgressDelegate

- (void)transferWithID:(NSString*)transferID updatedProgress:(float)progress;

@end

@interface JBProgressView : UIProgressView<JBProgressDelegate>

@end
