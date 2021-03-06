//
//  Input.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol InputVisitor;
@class InputTag;

extern NSString * const INPUT_NAME_KEY;
extern NSString * const INPUT_NOTES_KEY;
extern NSString * const INPUT_ICON_IMAGE_NAME_KEY;
extern NSString * const INPUT_TAGS_KEY;
extern NSString * const INPUT_ENTITY_NAME;


@interface Input : NSManagedObject {
	@private
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * iconImageName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSSet *tags;

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor;

-(NSString*)inlineInputType;
-(NSString*)inputTypeTitle;

@end

@interface Input (CoreDataGeneratedAccessors)

- (void)addTagsObject:(InputTag *)value;
- (void)removeTagsObject:(InputTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
