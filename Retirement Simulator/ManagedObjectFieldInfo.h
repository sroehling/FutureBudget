//
//  ManagedObjectFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ManagedObjectFieldInfo : NSObject {
    NSString *fieldLabel;
    NSString *fieldKey;
	NSString *fieldPlaceholder;
    NSManagedObject *managedObject;
    
    BOOL fieldAccessEnabled;
}

-(id)initWithManagedObject:(NSManagedObject*)theManagedObject
               andFieldKey:(NSString*)theFieldKey
             andFieldLabel:(NSString*)theFieldLabel
			andFieldPlaceholder:(NSString*)thePlaceholder;


@property(nonatomic,retain) NSString *fieldLabel;
@property(nonatomic,retain) NSString *fieldKey;
@property(nonatomic,retain) NSString *fieldPlaceholder;
@property(nonatomic,retain) NSManagedObject *managedObject;

- (id)getFieldValue;
- (void)setFieldValue:(id)newValue;
- (BOOL)fieldIsInitializedInParentObject;

- (void)disableFieldAccess;

- (NSString*)textLabel;

@end
