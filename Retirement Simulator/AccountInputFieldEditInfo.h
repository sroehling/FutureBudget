//
//  AccountInputFieldEditInfo.h
//  FutureBudget
//
//  Created by Steve Roehling on 9/26/13.
//
//

#import "InputFieldEditInfo.h"

@class Account;

@interface AccountInputFieldEditInfo : InputFieldEditInfo {
    @private
        Account *account;
}

@property(nonatomic,retain) Account *account;

- (id)initWithAccount:(Account*)theAccount
    andDataModelController:(DataModelController*)dataModelController;

@end
