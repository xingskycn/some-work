//
//  APPregameViewPlayerCell.m
//  AP
//
//  Created by Ziehn Nils on 6/22/11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import "APPregameViewPlayerCell.h"


@implementation APPregameViewPlayerCell

@synthesize mainView,container;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.container = [[UIView alloc] initWithFrame:CGRectMake(4, 2, self.frame.size.width-8, self.frame.size.height-4)];
		[self addSubview:self.container];
		[self.container release];
		
		self.mainView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, self.frame.size.width-16, self.frame.size.height-12)];
		[self addSubview:self.mainView];
		[self.mainView release];
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
