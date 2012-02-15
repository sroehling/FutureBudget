//
//  TaxBracketEntryObjectAdder.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableViewObjectAdder.h"
#import "TaxBracket.h"

@class TaxBracket;
@class DataModelController;

@interface TaxBracketEntryObjectAdder : NSObject <TableViewObjectAdder>  {
		@private
			TaxBracket *taxBracket;
			DataModelController *dataModelController;
}

@property(nonatomic,retain) TaxBracket *taxBracket;
@property(nonatomic,retain) DataModelController *dataModelController;

-(id)initWithTaxBracket:(TaxBracket*)theTaxBracket 
	andParentDataModelController:(DataModelController*)parentDataModelController;

@end
