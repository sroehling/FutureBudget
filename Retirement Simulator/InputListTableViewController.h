//
//  InputListTableViewController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/20/13.
//
//

#import "GenericFieldBasedTableEditViewController.h"
#import "InputListFormInfoCreator.h"


@interface InputListTableViewController : GenericFieldBasedTableEditViewController <InputListHeaderDelegate>
{
	@private
		 InputListFormInfoCreator *inputListFormInfoCreator;
}

@property(nonatomic,retain) InputListFormInfoCreator *inputListFormInfoCreator;

-(id)initWithDataModelController:(DataModelController*)theDataModelController;

@end
