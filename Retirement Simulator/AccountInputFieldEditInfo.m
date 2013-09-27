//
//  AccountInputFieldEditInfo.m
//  FutureBudget
//
//  Created by Steve Roehling on 9/26/13.
//
//

#import "AccountInputFieldEditInfo.h"
#import "Account.h"
#import "TransferEndpointAcct.h"

@implementation AccountInputFieldEditInfo

@synthesize account;

-(void)dealloc
{
    [account release];
    [super dealloc];
}

- (id)initWithAccount:(Account*)theAccount andDataModelController:(DataModelController*)dataModelController
{
    self = [super initWithInput:theAccount andDataModelController:dataModelController];
    if(self)
    {
        self.account = theAccount;
    }
    return self;
}

-(id)initWithInput:(Input *)theInput andDataModelController:(DataModelController *)dataModelController
{
    assert(0); // must call init method above.
}

-(BOOL)supportsDelete
{
    // Each account is initialized with an acctTransferEndpointAcct property. This serves as
    // an endpoint for any transfers with the account as either the source or destination
    // of a transfer. If the account is the endpoint of any transfer, then prevent it from
    // being deleted.
    //
    // Another option would have been to cascade and delete all the corresponding transfers,
    // or ask the user what they want to do (with a message like, "This account is referenced
    // by 2 different transfers. Are you sure you want to delete the corresponding transfers").
    if((self.account.acctTransferEndpointAcct.transferFromEndpoint.count > 0) ||
        (self.account.acctTransferEndpointAcct.transferToEndpoint.count > 0))
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

@end
