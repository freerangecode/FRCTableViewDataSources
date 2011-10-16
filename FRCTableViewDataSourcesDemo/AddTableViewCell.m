//
//  AddTableViewCell.m
//  FRCTableViewDataSources
//
//  Created by Daniel Tull on 16.10.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "AddTableViewCell.h"

@implementation AddTableViewCell
@synthesize label;

- (void)configureWithObject:(NSString *)text {
	label.text = text;
}

@end
