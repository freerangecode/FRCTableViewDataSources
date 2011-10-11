/*
 FRCTableViewCell.h
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

#import <UIKit/UIKit.h>


/** While most cells used in the FRCTableViewDataSource system should be 
 subclasses of FRCTableViewCell, you might want to use a third party cell 
 that cannot be a subclass. You can still take advantage of the object 
 configuration system by implementing this protocol.
 */
@protocol FRCTableViewCellObjectConfiguration <NSObject>

/** Allows you to configure the cell with the given object.
 
 After dequeuing the cell (or getting the cell for the first time), the
 FRCTableViewDataSource calls this method with the associated object.
 
 @param object The object the cell is representing.
 */
- (void)configureWithObject:(id)object;

/** A way to provide a custom height given the object.
 
 In some cases, you may way to have a custom height for your cell. This 
 class method allows us to determine how big a cell should be without having 
 an instance. Use this method to perform calculations for the height of 
 the cell.
 
 @param object The object the cell is representing.
 @param width The width of the table view the cell will be put into.
 
 @return The height for the cell.
 */
+ (CGFloat)heightForObject:(id)object width:(CGFloat)width;

@end


/** A table view cell class that implments the FRCTableViewCellObjectConfiguration
 protocol as well as enabling really easy way to set up a cell inside a nib
 or storyboard.
 */
@interface FRCTableViewCell : UITableViewCell <FRCTableViewCellObjectConfiguration>

/** Get an instance of the cell, either from a nib if one exists or via alloc, init.
 
 @return An instance of cell class.
 */
+ (id)cell;

/** The reuse identifier for the cell.
 
 By default, in the FRCTableViewDataSource system one cell class maps to
 one reuseIdentifier, which is the class name as a string. Subclass cells in 
 nibs should use the class name as a reuse identifier.
 
 @return The reuse identifier.
 */
+ (NSString *)reuseIdentifier;

/** This is the nibName to use to load and find the table view cell.
 
 By default it is the same name as the class.
 
 @return The nib name.
 */
+ (NSString *)nibName;

@end
