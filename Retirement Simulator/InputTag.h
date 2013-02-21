//
//  InputTag.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Input;
@class SharedAppValues;

extern NSString * const INPUT_TAG_ENTITY_NAME;
extern NSString * const INPUT_TAG_NAME_KEY;
extern NSUInteger const INPUT_TAG_NAME_MAX_LENGTH;
extern NSString * const INPUT_TAG_NOTES_KEY;

@interface InputTag : NSManagedObject

@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSSet *taggedInputs;

@property (nonatomic, retain) SharedAppValues *sharedAppValsFilteredTags;


@end

@interface InputTag (CoreDataGeneratedAccessors)

- (void)addTaggedInputsObject:(Input *)value;
- (void)removeTaggedInputsObject:(Input *)value;
- (void)addTaggedInputs:(NSSet *)values;
- (void)removeTaggedInputs:(NSSet *)values;

@end
