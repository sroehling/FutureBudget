//
//  ItemizedTaxAmtObjectAdder.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtObjectAdder.h"
#import "ItemizedTaxAmtSelectionFormInfoCreator.h"
#import "ItemizedTaxAmtsInfo.h"
#import "GenericFieldBasedTableEditViewController.h"


@implementation ItemizedTaxAmtObjectAdder

@synthesize itemizedTaxAmtsInfo;

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmtsInfo != nil);
		self.itemizedTaxAmtsInfo = theItemizedTaxAmtsInfo;
	}
	return self;
}

-(id)init
{
	assert(0); // must call init selector above
	return nil;
}

-(void)addObjectFromTableView:(UITableViewController*)parentView
{
	ItemizedTaxAmtSelectionFormInfoCreator *itemizedTaxAmtSelectionFormInfoCreator = 
		[[[ItemizedTaxAmtSelectionFormInfoCreator alloc]
		initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo] autorelease];
		
	GenericFieldBasedTableEditViewController *itemSelectionView = 
			[[[GenericFieldBasedTableEditViewController alloc] initWithFormInfoCreator:itemizedTaxAmtSelectionFormInfoCreator] autorelease];
			
    [parentView.navigationController pushViewController:itemSelectionView animated:YES];
}

-(void)dealloc
{
	[super dealloc];
	[itemizedTaxAmtsInfo release];
}


@end
