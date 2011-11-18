//
//  NumberFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldEditInfo.h"
#import "NumberFieldCell.h"
#import "NumberHelper.h"
#import "StringValidation.h"
#import "ManagedObjectFieldInfo.h"
#import "DataModelController.h"
#import "FieldInfo.h"
#import "NumberFieldValidator.h"



@implementation NumberFieldEditInfo


@synthesize numberFormatter;
@synthesize objectForDelete;
@synthesize validator;


+ (NumberFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                               andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
                        andNumberFormatter:(NSNumberFormatter*)numFormatter
						andValidator:(NumberFieldValidator*)theValidator
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
              initWithManagedObject:obj andFieldKey:key andFieldLabel:label 
										 andFieldPlaceholder:placeholder];
    NumberFieldEditInfo *fieldEditInfo = [[NumberFieldEditInfo alloc] 
		initWithFieldInfo:fieldInfo andNumberFormatter:numFormatter andValidator:theValidator];
    [fieldEditInfo autorelease];
    [fieldInfo release];
	
    
    return fieldEditInfo;
}

- (id) initWithFieldInfo:(FieldInfo *)theFieldInfo 
      andNumberFormatter:(NSNumberFormatter*)numFormatter
	  andValidator:(NumberFieldValidator*)theValidator
{
    self = [super initWithFieldInfo:theFieldInfo];
    if(self)
    {
        assert(numFormatter != nil);
        self.numberFormatter = numFormatter;
		self.validator = theValidator;

    }
    return self;
}

- (id) initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo
{
    assert(0); // should not call
    return nil;
}

- (NSString*)detailTextLabel
{
	NSNumber *displayVal = [[NumberHelper theHelper] displayValFromStoredVal:[self.fieldInfo getFieldValue] andFormatter:self.numberFormatter];
    return [self.numberFormatter stringFromNumber:displayVal];
    
}

- (UIViewController*)fieldEditController
{
    assert(0);
    return nil;
    
}

- (BOOL)hasFieldEditController
{
    return FALSE;
}

- (void)dealloc {
    [super dealloc];
    [numberFormatter release];
	[objectForDelete release];
	[validator release];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 30.0;
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    
    NumberFieldCell *cell = (NumberFieldCell *)[tableView 
		dequeueReusableCellWithIdentifier:NUMBER_FIELD_CELL_ENTITY_NAME];
    if (cell == nil) {
		cell = [[[NumberFieldCell alloc] init] autorelease];
    }    
    cell.fieldEditInfo = self;
    cell.label.text = [self textLabel];
    
    // Only try to initialize the text in the field if the field's
    // value has been initialized in the parent object. If it hasn't,
    // the text field will be left blank and the placeholder value
    // will be shown.
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        cell.textField.text = [self detailTextLabel];
    }

    cell.textField.placeholder = self.fieldInfo.fieldPlaceholder;
    
    return cell;
    
}

-(BOOL)supportsDelete
{
	if(self.objectForDelete != nil)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

-(void)deleteObject
{
	assert(self.objectForDelete != nil);
	[[DataModelController theDataModelController] deleteObject:self.objectForDelete];
	self.objectForDelete = nil;
}



@end
