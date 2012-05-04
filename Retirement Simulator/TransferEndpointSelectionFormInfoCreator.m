//
//  TransferEndpointSelectionFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferEndpointSelectionFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "FormContext.h"
#import "StringValidation.h"
#import "SharedAppValues.h"
#import "SectionInfo.h"
#import "Account.h"
#import "DataModelController.h"
#import "LocalizationHelper.h"
#import "StaticFieldEditInfo.h"
#import "TransferEndpointAcct.h"
#import "Cash.h"
#import "TransferEndpointCash.h"
#import "TransferEndpointSelectionFieldEditInfo.h"

@implementation TransferEndpointSelectionFormInfoCreator

@synthesize formTitle;

-(id)initWithTitle:(NSString*)theFormTitle
{
	self = [super init];
	if(self)
	{
		assert([StringValidation nonEmptyString:theFormTitle]);
		self.formTitle = theFormTitle;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] 
		initWithFormContext:parentContext] autorelease];
  
	formPopulator.formInfo.title = self.formTitle;
  
  	SharedAppValues *sharedAppVals = [SharedAppValues 
		getUsingDataModelController:parentContext.dataModelController];
		
	[formPopulator nextSection];
	
	TransferEndpointSelectionFieldEditInfo *cashFieldEditInfo = 
		[[[TransferEndpointSelectionFieldEditInfo alloc] 
		initWithTransferEndpoint:sharedAppVals.cash.transferEndpointCash] autorelease];
	[formPopulator.currentSection addFieldEditInfo:cashFieldEditInfo];
		
		
	NSArray *inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		[formPopulator  nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LIST_SECTION_TITLE_ACCOUNTS")];
		for(Account *account in inputs)
		{    
			assert(account != nil);

			TransferEndpointSelectionFieldEditInfo *accountFieldEditInfo = 
				[[[TransferEndpointSelectionFieldEditInfo alloc] 
				initWithTransferEndpoint:account.acctTransferEndpointAcct ] autorelease];			
			[formPopulator.currentSection addFieldEditInfo:accountFieldEditInfo];
		}
	}
  
	return formPopulator.formInfo;
	
}




-(void)dealloc
{
	[formTitle  release];
	[super dealloc];
}

@end
