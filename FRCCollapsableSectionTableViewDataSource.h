/*
 FRCCollapsableSectionTableViewDataSource.h
 FRCTableViewDataSources
 
 Created by Daniel Tull on 30.06.2011.
 
 
 
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

#import "FRCParentTableViewDataSource.h"

/** A class to represent the header cell for the collapsable data source. 
 */
@interface FRCCollapsableSectionTableViewDataSourceHeader : NSObject

/** The title to use in the header cell.
 */
@property (nonatomic, readonly) NSString *title;

/** YES if the FRCCollapsableSectionTableViewDataSource is open.
 */
@property (nonatomic, readonly) BOOL open;

/** YES if the FRCCollapsableSectionTableViewDataSource is empty and has
 nothing to expand out for.
 
 The FRCCollapsableSectionTableViewDataSource is deemed to be empty if
 it has no childTableViewDataSource or the childTableViewDataSource returns 
 0 for tableView:numberOfRowsInSection:.
 */
@property (nonatomic, readonly) BOOL empty;
@end


/** A data source that manages one section of a table view which puts a header cell 
 above its childTableViewDataSource to allow expanding and collapsing in an 
 acordian style.
 */
@interface FRCCollapsableSectionTableViewDataSource : FRCParentTableViewDataSource

/** The child data source to expand.
 */
@property (nonatomic, strong) FRCTableViewDataSource *childTableViewDataSource;

/** The class to use for header cell. Assuming it conforms to the 
 FRCTableViewCellObjectConfiguration protocol, it will get an instance of 
 FRCCollapsableSectionTableViewDataSourceHeader that represents the current state 
 of the collapsable data source.
 */
@property (nonatomic, assign) Class titleCellClass;

/** The title that should go in the header cell. 
 */
@property (nonatomic, copy) NSString *title;

/** Shows whether the collapsable data source is open or not. You can
 also use this to programatically expand or collapse.
 */
@property (nonatomic, assign, getter = isOpen) BOOL open;

/** A method for subclasses to override to provide a data source to use
 for the childTableViewDataSource.
 
 This method is only called when childTableViewDataSource is nil.
 */
- (void)loadChildTableViewDataSource;

@end
