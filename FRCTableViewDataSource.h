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

#import "FRCTableViewDataSources.h"

typedef void (^FRCTableViewDataSourceCellConfigurationBlock) (UITableViewCell *cell, NSIndexPath *indexPath, id object);

@class FRCParentTableViewDataSource;

/** An abstract class to represent a core FRCTableViewDataSource object. Examples of concrete 
 subclasses are FRCObjectTableViewDataSource and FRCFetchedResultsTableViewDataSource.
 
 When subclassing, generally you should write your own implmentation for the objectAtIndexPath:
 and reloadData methods.
 */
@interface FRCTableViewDataSource : NSObject <UITableViewDataSource>

/** This is the class to use for cells of this data source. 
 
 Ideally this should should be a subclass of FRCTableViewCell or
 implement the FRCTableViewCellObjectConfiguration protocol for best reseults.
 */
@property (nonatomic, assign) Class cellClass;

- (void)setCellClass:(Class)cellClass forObjectClass:(Class)objectClass;
- (Class)cellClassForObjectClass:(Class)objectClass;

/** The table view that is associated with the data source.
 */
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/** A parent data source, if one exists.
 
 To enable nesting any data source has the potential to have a
 parent, although this is not always true (for instance the root 
 data source).
 */
@property (nonatomic, frc_weak) FRCParentTableViewDataSource *parent;

/** A convinient way to repload the cells of the data source, this 
 should be overridden by subclasses to provide desired results.
 */
- (void)reloadData;

/** To get the associated object from the data source for the given 
 index path. By default this returns the index path, but subclasses
 should return the correct object to use.
 
 If the cellClass conforms to FRCTableViewCellObjectConfiguration,
 it is this object that will be given to the cell when
 configureWithObject: is called.
 
 @param indexPath The index path in the co-ordinate space of the data source.
 
 @return The representing object.
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/** To enable a data source to have different cell classes for different
 index paths.
 
 This method returns the class in the property cellClass. Subclasses
 should override for different results.
 
 @param indexPath The index path in the co-ordinate space of the data source.
 
 @return The class of the cell to use.
 */
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath;

/** This allows subclasses to simply configure the cell without needing
 to implement the standard tableView:cellForRowAtIndexPath: method.
 
 @param cell The cell to be configured.
 @param indexPath The index path in the co-ordinate space of the data source.
 @param object The represented object at the indexPath.
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@property (nonatomic, copy) FRCTableViewDataSourceCellConfigurationBlock cellConfigurer;


@property (nonatomic, copy) NSString *sectionHeaderTitle;
@property (nonatomic, copy) NSString *sectionFooterTitle;

@end
