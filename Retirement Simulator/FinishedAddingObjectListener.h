//
//  FinishedAddingObjectListener.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FinishedAddingObjectListener <NSObject>

-(void)objectFinshedBeingAdded:(NSManagedObject*)addedObject;

@end
