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
@protocol GenericTableViewFactory;

@interface StaticNavFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		FormFieldWithSubtitleTableCell *valueCell;
		id<GenericTableViewFactory> subViewFactory;
}

@property(nonatomic,retain) FormFieldWithSubtitleTableCell *valueCell;
@property(nonatomic,retain) id<GenericTableViewFactory> subViewFactory;

- (id) initWithCaption:(NSString *)caption andSubtitle:(NSString *)subtitle
		andContentDescription:(NSString*)contentDesc 
		andSubViewFactory:(id<GenericTableViewFactory>)theSubViewFactory;

- (id) initWithCaption:(NSString*)caption 
	andSubtitle:(NSString*)subtitle 
	andContentDescription:(NSString*)contentDesc
	andSubFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator;

@end
