//
//  DCTTableViewCell.m
//  Issues
//
//  Created by Daniel Tull on 9.07.2011.
//  Copyright 2011 Daniel Tull. All rights reserved.
//

#import "DCTTableViewCell.h"

@interface DCTTableViewCell ()
+ (BOOL)dctInternal_nibExistsWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;
@end

@implementation DCTTableViewCell

@synthesize cellConfigurer;

#pragma mark - NSObject

- (id)init {
	
	if (!(self = [super init])) return nil;
	
	self.cellConfigurer = ^(UITableViewCell *cell, id object) {
		cell.textLabel.text = [object description];
	};
	
    return self;
}

- (void)awakeFromNib {
	self.cellConfigurer = ^(UITableViewCell *cell, id object) {
		cell.textLabel.text = [object description];
	};
}

#pragma mark - DCTTableViewCell

+ (NSString *)reuseIdentifier {
	return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIdentifier];
}

+ (NSString *)nibName {
	
	NSString *nibName = NSStringFromClass(self);
	
	if ([self dctInternal_nibExistsWithNibName:nibName bundle:nil])
		return nibName;
	
	return nil;	
}

- (void)configureWithObject:(id)object {

	if (self.cellConfigurer) 
		self.cellConfigurer(self, object);
}

#pragma mark - Internal

+ (BOOL)dctInternal_nibExistsWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	
	if (nibName == nil) return NO;
	
	if (bundle == nil) bundle = [NSBundle mainBundle];
	
	NSString *path = [bundle pathForResource:nibName ofType:@"nib"];
	
	if (path == nil) path = [bundle pathForResource:nibName ofType:@"xib"]; // Is this check needed? All xibs will get compiled to nibs right?
	
	if (path == nil) return NO;
	
	return YES;
}

@end

#pragma mark -

@implementation UITableView (DCTTableViewCell)

- (void)dct_registerDCTTableViewCellSubclass:(Class)tableViewCellClass {
	
	if (![tableViewCellClass isSubclassOfClass:[DCTTableViewCell class]]) return;
	
	UINib *nib = [UINib nibWithNibName:[tableViewCellClass nibName] bundle:nil];
	NSString *reuseIdentifier = [tableViewCellClass reuseIdentifier];
	
	[self registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

@end
