/*
 FRCSplitTableViewDataSource.h
 FRCTableViewDataSources
 
 Created by Daniel Tull on 16.09.2010.
 
 
 
 Copyright (c) 2010 Daniel Tull. All rights reserved.
 
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

#import "FRCParentTableViewDataSource.h"

typedef enum {
	FRCSplitTableViewDataSourceTypeSection = 0,
	FRCSplitTableViewDataSourceTypeRow
} FRCSplitTableViewDataSourceType;

/** A class to provide a way of displaying data from multiple data sources in a table view. */
@interface FRCSplitTableViewDataSource : FRCParentTableViewDataSource

/** Add a child data source. This calls to the tableView to animate the cells in.
 
 @param dataSource The data source to add as a child.
 */
- (void)addChildTableViewDataSource:(FRCTableViewDataSource *)dataSource;

/** Remove a child data source. This calls to the tableView to animate out the cells.
 
 @param dataSource The child data source to remove.
 */
- (void)removeChildTableViewDataSource:(FRCTableViewDataSource *)dataSource;

/** The type of the split. 
 
 - *FRCSplitTableViewDataSourceTypeSection* Splits each child
 table view data source into separate sections
 - *FRCSplitTableViewDataSourceTypeRow* Makes this data source responsible for once section
 and joins each child table view data source one after the other inside this section.
 */
@property (nonatomic, assign) FRCSplitTableViewDataSourceType type;
@end
