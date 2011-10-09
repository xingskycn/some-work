//
//  JBSettingsViewTableViewCell.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBSettingsViewTableViewCell.h"

@implementation JBSettingsViewTableViewCell

@synthesize mainView,container;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(4, 2, self.frame.size.width-8, self.frame.size.height-4)];
		[self addSubview:cView];
		self.container = cView;
        [cView release];
		
		UIImageView *mView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, self.frame.size.width-16, self.frame.size.height-12)];
		[self addSubview:mView];
        self.mainView=mView;
		[mView release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	self.mainView = nil;
	self.container = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.container.frame = CGRectMake(4, 2, self.frame.size.width-8, self.frame.size.height-4);
	self.mainView.frame = CGRectMake(8, 6, self.frame.size.width-16, self.frame.size.height-12);
}


@end
