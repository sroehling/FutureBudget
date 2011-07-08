//
//  ManagedObjectFieldInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldInfo.h"

@interface ManagedObjectFieldInfo : FieldInfo {
    NSManagedObject *managedObjectWithField;
			NSString *fieldKey;

    
}

-(id)initWithManagedObject:(NSManagedObject*)theManagedObject
               andFieldKey:(NSString*)theFieldKey
             andFieldLabel:(NSString*)theFieldLabel
			andFieldPlaceholder:(NSString*)thePlaceholder;


@property(nonatomic,retain) NSManagedObject *managedObjectWithField;
@property(nonatomic,retain) NSString *fieldKey;




@end
