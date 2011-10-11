/*
 FRCParentTableViewDataSource.h
 FRCTableViewDataSources
 
 Created by Daniel Tull on 20.08.2011.
 
 
 
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

#import "FRCTableViewDataSource.h"


/** This is an abstract class that implements forwarding of the UITableViewDataSource methods to child data source objects.
*/
@interface FRCParentTableViewDataSource : FRCTableViewDataSource

/// @name Conversion

/** Conversion method
 
 @param section The section in the co-ordinate space of the child.
 @param dataSource The child data source.
 
 @return The section in the co-ordinate space of the parent.
 */
- (NSInteger)convertSection:(NSInteger)section fromChildTableViewDataSource:(FRCTableViewDataSource *)dataSource;

/** Conversion method
 
 @param section The section in the co-ordinate space of the parent.
 @param dataSource The child data source.
 
 @return The section in the co-ordinate space of the child.
 */
- (NSInteger)convertSection:(NSInteger)section toChildTableViewDataSource:(FRCTableViewDataSource *)dataSource;

/** Conversion method
 
 @param indexPath The index path in the co-ordinate space of the child.
 @param dataSource The child data source.
 
 @return The index path in the co-ordinate space of the parent.
 */
- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath fromChildTableViewDataSource:(FRCTableViewDataSource *)dataSource;

/** Conversion method
 
 @param indexPath The index path in the co-ordinate space of the parent.
 @param dataSource The child data source.
 
 @return The index path in the co-ordinate space of the child.
 */
- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath toChildTableViewDataSource:(FRCTableViewDataSource *)dataSource;

/// @name Retrieving child data sources

/** This should return an array of all the child data sources.
 
 All these data sources should have thier parent set as this data source.
 */
@property (nonatomic, readonly) NSArray *childTableViewDataSources;


/** Retrieves the child data source for a given section.
 
 @param section The section the caller wants a data source for. This should be 
 in the "co-ordinates" of the data source you are calling to.
 
 @return The data source object for the given section.
 */
- (FRCTableViewDataSource *)childTableViewDataSourceForSection:(NSInteger)section;

/** Retrieves the child data source for a given index path.
 
 @param indexPath The indexPath the caller wants a data source for. This should be 
 in the "co-ordinates" of the data source you are calling to.
 
 @return The data source object for the given indexPath.
 */
- (FRCTableViewDataSource *)childTableViewDataSourceForIndexPath:(NSIndexPath *)indexPath;

/// @name Parental guidance

/** Allows the parent to prevent the child data source from updating. 
 
 Children should use this method to determine whether they should insert, 
 delete or update cells in their control.
 
 An example of this is FRCCollapsableSectionTableViewDataSource, which will return NO when
 it is closed. This way an updating child, like a FRCFetchedResultsTableViewDataSource
 will be prevented from inserting or deleting cells into the tableView.
 
 @param dataSource The child data source that is asking whether it can update.
 
 @return YES if the child can update the table, NO if not.
 */
- (BOOL)childTableViewDataSourceShouldUpdateCells:(FRCTableViewDataSource *)dataSource;

@end
