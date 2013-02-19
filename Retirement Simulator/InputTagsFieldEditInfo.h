//
//  InputTagsFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "FieldEditInfo.h"

@class Input;
@class VariableContentTableCell;

@interface InputTagsFieldEditInfo : NSObject <FieldEditInfo>
{
	@private
		Input *input;
		VariableContentTableCell *valueCell;
}

@property(nonatomic,retain) Input *input;
@property(nonatomic,retain) VariableContentTableCell *valueCell;

-(id)initWithInput:(Input*)theInput;

@end
