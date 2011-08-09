//
//  DCTTableViewCell.m
//  Issues
//
//  Created by Daniel Tull on 9.07.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTTableViewCell.h"
#import "UINib+DCTExtensions.h"

@implementation DCTTableViewCell

+ (NSString *)reuseIdentifier {
	return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIdentifier];
}

+ (NSString *)nibName {
	
	NSString *nibName = NSStringFromClass(self);
	
	if ([UINib dct_nibExistsWithNibName:nibName bundle:nil])
		return nibName;
	
	return nil;	
}

- (void)configureWithObject:(id)object {}

@end


@implementation UITableView (DCTTableViewCell)

- (void)dct_registerDCTTableViewCellSubclass:(Class)tableViewCellClass {
	
	if (![tableViewCellClass isSubclassOfClass:[DCTTableViewCell class]]) return;
	
	UINib *nib = [UINib nibWithNibName:[tableViewCellClass nibName] bundle:nil];
	NSString *reuseIdentifier = [tableViewCellClass reuseIdentifier];
	
	[self registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

@end
