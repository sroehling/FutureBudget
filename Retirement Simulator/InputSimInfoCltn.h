//
//  InputSimInfoCltn.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Input;

@interface InputSimInfoCltn : NSObject {
    @private
		NSMutableDictionary *inputSimInfoMap;
		NSMutableSet *inputsSimulated;
}

@property(nonatomic,retain) NSMutableDictionary *inputSimInfoMap;
@property(nonatomic,retain) NSMutableSet *inputsSimulated;

-(id)getSimInfo:(Input*)theInput;
-(void)addSimInfo:(Input*)theInput withSimInfo:(id)simInfo;
-(NSArray*)simInfos;

@end
