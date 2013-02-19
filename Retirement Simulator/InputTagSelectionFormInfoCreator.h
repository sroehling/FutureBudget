//
//  InputTagSelectionFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"
#import "Input.h"

@interface InputTagSelectionFormInfoCreator : NSObject <FormInfoCreator>
{
	@private
		Input *inputBeingTagged;

}

@property(nonatomic,retain) Input *inputBeingTagged;

-(id)initWithInput:(Input*)theInput;

@end
