//
//  EventTableViewCell.m
//  FRCTableViewDataSources
//
//  Created by Daniel Tull on 16.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Event.h"

static NSDateFormatter *dateFormatter = nil;

@implementation EventTableViewCell

@synthesize label;

- (void)configureWithObject:(Event *)event {
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.timeStyle = NSDateFormatterMediumStyle;
		dateFormatter.dateStyle = NSDateFormatterShortStyle;
	});
	
	self.label.text = [dateFormatter stringFromDate:event.timeStamp];
}

@end
