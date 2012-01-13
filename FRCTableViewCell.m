/*
 FRCTableViewCell.m
 FRCTableViewDataSources
 
 Created by Daniel Tull on 09.07.2011.
 
 
 
 Copyright (c) 2011 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "FRCTableViewCell.h"

@interface FRCTableViewCell ()
+ (BOOL)frcInternal_nibExistsWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;
@end

@implementation FRCTableViewCell

#pragma mark - UITableViewCell

- (void)prepareForReuse {
	[super prepareForReuse];
	self.textLabel.text = nil;
}

#pragma mark - FRCTableViewCell

- (void)awakeFromNib {
	[self sharedInit];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
	
	[self sharedInit];
	
	return self;	
}

- (void)sharedInit {}

+ (id)cell {
	
	NSString *nibName = [self nibName];
	
	if (!nibName)
		return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self reuseIdentifier]];
	
	NSArray *items = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	
	for (id object in items)
		if ([object isKindOfClass:self])
			return object;
	
	return nil;	
}

+ (NSString *)reuseIdentifier {
	return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier {
	return [[self class] reuseIdentifier];
}

+ (NSString *)nibName {
	
	NSString *nibName = NSStringFromClass(self);
	
	if ([self frcInternal_nibExistsWithNibName:nibName bundle:nil])
		return nibName;
	
	return nil;	
}

- (void)configureWithObject:(id)object {
	self.textLabel.text = [object description];
}

+ (CGFloat)heightForObject:(id)object width:(CGFloat)width {
	return 44.0f;
}

#pragma mark - Internal

+ (BOOL)frcInternal_nibExistsWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	
	if (nibName == nil) return NO;
	
	if (bundle == nil) bundle = [NSBundle mainBundle];
	
	NSString *path = [bundle pathForResource:nibName ofType:@"nib"];
	
	if (path == nil) path = [bundle pathForResource:nibName ofType:@"xib"]; // Is this check needed? All xibs will get compiled to nibs right?
	
	if (path == nil) return NO;
	
	return YES;
}

@end
