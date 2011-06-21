//
//  StringLookupTable.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringLookupTable : NSObject {
	@private
		NSDictionary *lookupTable;
}

@property(nonatomic,retain) NSDictionary *lookupTable;

-(id)initWithStringLookupDictionary:(NSDictionary*)varStrings;

-(NSString*)stringVal:(NSString*)key;
-(NSString*)localizedStringVal:(NSString*)key;

@end
