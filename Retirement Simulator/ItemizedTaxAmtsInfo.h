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
		NSString *anchorWithinHelpFile;
		
		TaxInput *tax;
		ItemizedTaxAmts *itemizedTaxAmts;
		
		ItemizedTaxAmtFieldPopulator *fieldPopulator;
		
		BOOL itemizeIncomes;
		BOOL itemizeExpenses;
		BOOL itemizeAccountContribs;
		BOOL itemizeAccountWithdrawals;
		BOOL itemizeAccountInterest;
		BOOL itemizeAccountDividends;
		BOOL itemizeAccountCapitalGains;
		BOOL itemizeAccountCapitalLosses;
		BOOL itemizeLoanInterest;
		BOOL itemizeAssetGains;
		BOOL itemizeAssetLosses;
		
}

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *amtPrompt;
@property(nonatomic,retain) NSString *itemTitle;
@property(nonatomic,retain) NSString *itemSectionTitleFormat;
@property(nonatomic,retain) NSString *itemHelpInfoFile;
@property(nonatomic,retain) NSString *anchorWithinHelpFile;

@property(nonatomic,retain) TaxInput *tax;
@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;
@property(nonatomic,retain) ItemizedTaxAmtFieldPopulator *fieldPopulator;

@property BOOL itemizeIncomes;
@property BOOL itemizeExpenses;
@property BOOL itemizeAccountContribs;
@property BOOL itemizeAccountWithdrawals;
@property BOOL itemizeAccountInterest;
@property BOOL itemizeAccountDividends;
@property BOOL itemizeAccountCapitalGains;
@property BOOL itemizeAccountCapitalLosses;

@property BOOL itemizeLoanInterest;
@property BOOL itemizeAssetGains;
@property BOOL itemizeAssetLosses;
@property BOOL itemizeTaxesPaid;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andTax:(TaxInput*)theTax
	andItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
	andTitle:(NSString*)theTitle andAmtPrompt:(NSString *)theAmtPrompt
	andItemTitle:(NSString*)theItemTitle
	andItemSectionTitleFormat:(NSString*)theItemSectionTitleFormat
	andItemHelpInfoFile:(NSString*)theItemHelpFile
	andAnchorWithinHelpFile:(NSString*)anchorName
	andItemizeIncomes:(BOOL)doItemizeIncomes
	andItemizeExpenses:(BOOL)doItemizeExpenses
	andItemizeAccountContribs:(BOOL)doItemizeAcctContribs
	andItemizeAccountWithdrawals:(BOOL)doItemizeAcctWithdrawals
	andItemizeAccountInterest:(BOOL)doItemizeAcctInterest
	andItemizeAccountDividends:(BOOL)doItemizeAcctDividend
	andItemizeCapitalGains:(BOOL)doItemizeCapitalGains
	andItemizeCapitalLosses:(BOOL)doItemizeCapitalLosses
	andItemizeAssetGains:(BOOL)doItemizeAssetGains
	andItemizeAssetLosses:(BOOL)doItemizeAssetLosses
	andItemizeLoanInterest:(BOOL)doItemizeLoanInterest
	andItemizeTaxesPaid:(BOOL)doItemizeTaxesPaid;
	
+(ItemizedTaxAmtsInfo*)taxSourceInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;
+(ItemizedTaxAmtsInfo*)taxAdjustmentInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;
+(ItemizedTaxAmtsInfo*)taxDeductionInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;
+(ItemizedTaxAmtsInfo*)taxCreditInfo:(TaxInput*)tax usingDataModelController:(DataModelController*)dataModelController;

-(NSString *)itemizationSummary;
-(NSString*)itemizationCountSummary;

@end
