//
//  ItemizedTaxAmtsInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemizedTaxAmts;

@interface ItemizedTaxAmtsInfo : NSObject {
   @private
		NSString *title;
		NSString *amtPrompt;
		NSString *itemTitle;
		ItemizedTaxAmts *itemizedTaxAmts;
}

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *amtPrompt;
@property(nonatomic,retain) NSString *itemTitle;
@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
	andTitle:(NSString*)theTitle andAmtPrompt:(NSString *)theAmtPrompt
	andItemTitle:(NSString*)theItemTitle;

@end
