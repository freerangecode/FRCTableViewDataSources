/*
 FRCTableViewDataSource.m
 FRCTableViewDataSources
 
 Created by Daniel Tull on 20.05.2011.
 
 
 
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

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
	#define frc_weak weak
	#define __frc_weak __weak
	#define frc_nil(x)
	#define FRCTableViewDataSourceTableViewRowAnimationAutomatic UITableViewRowAnimationAutomatic
#else
	#define frc_weak unsafe_unretained
	#define __frc_weak __unsafe_unretained
	#define frc_nil(x) x = nil
	#define FRCTableViewDataSourceTableViewRowAnimationAutomatic UITableViewRowAnimationFade
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FRCParentTableViewDataSource;

/** A class that provides a basic implementation of the FRCTableViewDataSource protocol
 */
@interface FRCTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, assign) Class cellClass;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, frc_weak) FRCParentTableViewDataSource *parent;

- (void)reloadData;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
