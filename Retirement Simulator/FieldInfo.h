//
//  FieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FieldInfo : NSObject {
	@private
		NSString *fieldLabel;
		NSString *fieldPlaceholder;
		BOOL isSelectedForSelectableObjectTableView;
	@protected
		BOOL fieldAccessEnabled;

}

@property(nonatomic,retain) NSString *fieldLabel;

@property(nonatomic,retain) NSString *fieldPlaceholder;

@property BOOL isSelectedForSelectableObjectTableView;

- (void)disableFieldAccess;
- (NSString*)textLabel;

-(id)initWithFieldLabel:(NSString*)theFieldLabel
			 andFieldPlaceholder:(NSString *)thePlaceholder;

- (id)getFieldValue;
- (void)setFieldValue:(NSObject*)newValue;
- (BOOL)fieldIsInitializedInParentObject;

- (NSManagedObject*)managedObject;
- (NSManagedObject*)fieldObject;


@end
