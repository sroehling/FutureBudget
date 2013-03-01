//
//  TaxInputBlankOrPresetFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/26/13.
//
//

#import <Foundation/Foundation.h>
#import "FormInfoCreator.h"

@class InputCreationHelper;

@interface TaxInputBlankOrPresetFormInfoCreator : NSObject <FormInfoCreator>
{
	@private
		InputCreationHelper *inputCreationHelper;
		NSArray *taxInputPresetsPlistInfo;
}

@property(nonatomic,retain) InputCreationHelper *inputCreationHelper;
@property(nonatomic,retain) NSArray *taxInputPresetsPlistInfo;

-(id)initWithInputCreationHelper:(InputCreationHelper*)theInputCreationHelper;

@end
