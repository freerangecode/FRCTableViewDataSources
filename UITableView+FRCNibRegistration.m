//
//  UITableView+FRCNibRegistration.m
//  FRCTableViewDataSources
//
//  Created by Daniel Tull on 28.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "UITableView+FRCNibRegistration.h"
#import <objc/runtime.h>

@interface UITableView ()
@property (nonatomic, readonly) NSMutableDictionary *frcInternal_nibs;
@end

@implementation UITableView (FRCNibRegistration)

#pragma mark - UITableView (FRCNibRegistration)

- (id)frc_dequeueReusableCellWithIdentifier:(NSString *)identifier {
	
	UINib *nib = [self.frcInternal_nibs objectForKey:identifier];
	NSArray *items = [nib instantiateWithOwner:nil options:nil];
	
	for (id object in items)
		if ([object isKindOfClass:[UITableViewCell class]])
			return object;
	
	return nil;
}

- (void)frc_registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
	[self.frcInternal_nibs setObject:nib forKey:identifier];	
}

#pragma mark - Internal

- (NSMutableDictionary *)frcInternal_nibs {
	NSMutableDictionary *dictionary = objc_getAssociatedObject(self, _cmd);
	if (!dictionary) {
		dictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
		objc_setAssociatedObject(self, _cmd, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return dictionary;	
}

@end
