/*
 DCTTableViewDataSource.m
 DCTTableViewDataSources
 
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
#define dct_weak weak
#define __dct_weak __weak
#define dct_nil(x)
#else
#define dct_weak unsafe_unretained
#define __dct_weak __unsafe_unretained
#define dct_nil(x) x = nil
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DCTTableViewCell.h"

typedef UITableViewCell *(^DCTTableViewDataSourceCellGenerator)(UITableView *tableView, NSIndexPath *indexPath);

@protocol DCTTableViewDataSource;

@protocol DCTParentTableViewDataSource <DCTTableViewDataSource>

@property (nonatomic, readonly) NSArray *childTableViewDataSources;

- (NSIndexPath *)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource tableViewIndexPathForDataIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)childTableViewDataSource:(id<DCTTableViewDataSource>)dataSource tableViewSectionForDataSection:(NSInteger)section;

- (NSIndexPath *)dataIndexPathForTableViewIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)dataSectionForTableViewSection:(NSInteger)section;

- (id<DCTTableViewDataSource>)childDataSourceForSection:(NSInteger)section;
- (id<DCTTableViewDataSource>)childDataSourceForIndexPath:(NSIndexPath *)indexPath;

- (BOOL)tableViewDataSourceShouldUpdateCells:(id<DCTTableViewDataSource>)dataSource;

@end


/** A protocol to extend the UITableViewDataSoruce for the purposes of more reusable objects to use as datasources.
 */
@protocol DCTTableViewDataSource <UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, dct_weak) id<DCTParentTableViewDataSource> parent;

- (void)reloadData;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (Class<DCTTableViewCell>)cellClassAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end


/** A class that provides a basic implementation of the DCTTableViewDataSource protocol
 */
@interface DCTTableViewDataSource : NSObject <DCTTableViewDataSource>

@property (nonatomic, assign) Class cellClass;
@property (nonatomic, copy) DCTTableViewDataSourceCellGenerator cellGenerator;

@end
