//
//  FieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FieldEditInfo <NSObject>

@required
- (NSString*)textLabel;
- (NSString*)detailTextLabel;

- (BOOL)hasFieldEditController;
- (UIViewController*)fieldEditController;

- (BOOL)fieldIsInitializedInParentObject;
- (void)disableFieldAccess;

// The managed object associated with this FieldEditInfo.
// Generally, since there is a 1:1 correspondence between a FieldEditInfo
// an a row in a table, there is typically an associated managedObject. This
// is used in contexts where a row in a table is used to select the field
// value for another managed object (i.e., the managedObject returned
// is used to set a referenced property in another parent object).
- (NSManagedObject*) managedObject;

- (UITableViewCell*)cellForFieldEdit:(UITableView*)tableView;
- (CGFloat)cellHeightForWidth:(CGFloat)width;

@optional
- (BOOL)supportsDelete;
- (void)deleteObject;

// The 3 optional selectors below are for use with the 
// SelectableObjectTableEditViewController. 
- (void)updateSelection:(BOOL)isSelected;
- (BOOL)isSelected;
@property BOOL isDefaultSelection;

@end
