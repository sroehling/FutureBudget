//
//  TestCoreDataObjects.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InMemoryCoreData;
@class DateSensitiveValueChange;

@interface TestCoreDataObjects : NSObject {
    
}

+ (DateSensitiveValueChange*)createTestValueChange:(InMemoryCoreData*)coreData 
		andDateObj:(NSDate*)dateObj andVal:(double)val;
										   
+ (DateSensitiveValueChange*)createTestValueChange:(InMemoryCoreData*)coreData 
   andDate:(NSString*)dateStr andVal:(double)val;

@end
