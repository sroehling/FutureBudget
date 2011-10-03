//
//  StaticNavFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@class FormFieldWithSubtitleTableCell;
@protocol FormInfoCreator;

@interface StaticNavFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		FormFieldWithSubtitleTableCell *valueCell;
		id<FormInfoCreator> formInfoCreator;
}

@property(nonatomic,retain) FormFieldWithSubtitleTableCell *valueCell;
@property(nonatomic,retain) id<FormInfoCreator> formInfoCreator;

- (id) initWithCaption:(NSString*)caption 
	andSubtitle:(NSString*)subtitle 
	andSubFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator;

@end
