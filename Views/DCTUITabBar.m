/*
 DCTUITabBar.m
 DCTUIKit
 
 Created by Daniel Tull on 26.11.2009.
 
 
 
 Copyright (c) 2009 Daniel Tull. All rights reserved.
 
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

#import "DCTUITabBar.h"


@implementation DCTUITabBar

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[uiTabBar release];
	[super dealloc];	
}

- (id)init {
	
	if (!(self = [super initWithFrame:CGRectMake(0.0, 0.0, 320.0, 49.0)])) return nil;
	
	UITabBar *tb = [[UITabBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 49.0)];
	uiTabBar = [tb retain];
	uiTabBar.delegate = self;
	
	return self;	
}

#pragma mark -
#pragma mark UIView


- (void)drawRect:(CGRect)rect {
}

- (void)layoutSubviews {
	[self addSubview:uiTabBar];
}

#pragma mark -
#pragma mark DCTTabBar

- (void)setSelectedItem:(UITabBarItem *)anItem {
	uiTabBar.selectedItem = anItem;
}

- (UITabBarItem *)selectedItem {
	return uiTabBar.selectedItem;
}

- (void)setItems:(NSArray *)someItems {
	uiTabBar.items = someItems;
}

- (NSArray *)items {
	return uiTabBar.items;
}

#pragma mark -
#pragma mark UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	[self.delegate dctTabBar:self didSelectItem:item];
}

@end
