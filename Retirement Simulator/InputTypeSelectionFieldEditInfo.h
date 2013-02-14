//
//  InputTypeSelectionFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/13.
//
//

#import <Foundation/Foundation.h>
#import "FormFieldWithSubtitleTableCell.h"
#import "FieldEditInfo.h"

@class InputTypeSelectionInfo;


@interface InputTypeSelectionFieldEditInfo : NSObject <FieldEditInfo>
{
	@private
		InputTypeSelectionInfo *inputTypeSelectionInfo;
		FormFieldWithSubtitleTableCell *inputCell;
}

@property(nonatomic,retain) InputTypeSelectionInfo *inputTypeSelectionInfo;
@property(nonatomic,retain) FormFieldWithSubtitleTableCell *inputCell;

-(id)initWithTypeSelectionInfo:(InputTypeSelectionInfo*)theInputTypeSelectionInfo;

@end
