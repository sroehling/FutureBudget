//
//  InputListFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormInfoCreator.h"
#import "TableHeaderDisclosureButtonDelegate.h"

@protocol InputListHeaderDelegate;
@class TableHeaderWithDisclosure;

@interface InputListFormInfoCreator : NSObject  <FormInfoCreator,TableHeaderDisclosureButtonDelegate> {
    @private
		id<InputListHeaderDelegate> headerDelegate;
		TableHeaderWithDisclosure *tableHeader;
}

@property(nonatomic,assign) id<InputListHeaderDelegate> headerDelegate;
@property(nonatomic,retain) TableHeaderWithDisclosure *tableHeader;

-(void)configureHeader:(DataModelController*)dataModelController;

@end

@protocol InputListHeaderDelegate <NSObject>

-(void)inputListHeaderFilterTagsButtonPressed;

@end
