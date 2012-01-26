//
//  HelpPageFormPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormPopulator.h"

@interface HelpPageFormPopulator : FormPopulator {
    
}

-(void)populateHelpPageWithTitle:(NSString*)pageTitle andPageRef:(NSString*)pageRef;

@end
