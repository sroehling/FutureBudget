//
//  ItemizedTaxAmtsInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaxInput;
@class ItemizedTaxAmts;

@class  ItemizedTaxAmtFieldPopulator;
@class  DataModelController;

@interface ItemizedTaxAmtsInfo : NSObject {
   @private
		NSString *title;
		NSString *amtPrompt;
		NSString *itemTitle;
		NSString *itemSectionTitleFormat;
		NSString *itemHelpInfoFile;
		
		ItemizedTaxAmts *itemizedTaxAmts;
		
		ItemizedTaxAmtFieldPopulator *fieldPopulator;
		
		BOOL itemizeIncomes;
		BOOL itemizeExpenses;
		BOOL itemizeAccountContribs;
		BOOL itemizeAccountWithdrawals;
		BOOL itemizeAccountInterest;
		BOOL itemizeLoanInterest;
		BOOL itemizeAssetGains;
		
}

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *amtPrompt;
@property(nonatomic,retain) NSString *itemTitle;
@property(nonatomic,retain) NSString *itemSectionTitleFormat;
@property(nonatomic,retain) NSString *itemHelpInfoFile;

@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;
@property(nonatomic,retain) ItemizedTaxAmtFieldPopulator *fieldPopulator;

@property BOOL itemizeIncomes;
@property BOOL itemizeExpenses;
@property BOOL itemizeAccountContribs;
@property BOOL itemizeAccountWithdrawals;
@property BOOL itemizeAccountInterest;
@property BOOL itemizeLoanInterest;
@property BOOL itemizeAssetGains;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
	andTitle:(NSString*)theTitle andAmtPrompt:(NSString *)theAmtPrompt
	andItemTitle:(NSString*)theItemTitle
	andItemSectionTitleFormat:(NSString*)theItemSectionTitleFormat
	andItemHelpInfoFile:(NSString*)theItemHelpFile
	andItemizeIncomes:(BOOL)doItemizeIncomes
	andItemizeExpenses:(BOOL)doItemizeExpenses
	andItemizeAccountContribs:(BOOL)doItemizeAcctContribs
	andItemizeAccountWithdrawals:(BOOL)doItemizeAcctWithdrawals
	andItemizeAccountInterest:(BOOL)doItemizeAcctInterest
	andItemizeAssetGains:(BOOL)doItemizeAssetGains
	andItemizeLoanInterest:(BOOL)doItemizeLoanInterest;
	
+(ItemizedTaxAmtsInfo*)taxSourceInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;
+(ItemizedTaxAmtsInfo*)taxAdjustmentInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;
+(ItemizedTaxAmtsInfo*)taxDeductionInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;
+(ItemizedTaxAmtsInfo*)taxCreditInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;

@end
