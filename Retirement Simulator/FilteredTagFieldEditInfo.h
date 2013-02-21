//
//  FilteredTagFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/20/13.
//
//

#import "TagSelectionFieldEditInfo.h"

@class InputTag;
@class SharedAppValues;

@interface FilteredTagFieldEditInfo : TagSelectionFieldEditInfo
{
	@private
		SharedAppValues * sharedAppVals;
	
}

@property(nonatomic,retain) SharedAppValues * sharedAppVals;

-(id)initWithSharedAppVals:(SharedAppValues*)theSharedAppVals andInputTag:(InputTag*)theTag;

@end
