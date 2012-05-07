//
//  TransferEndpoint.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TransferEndpointVisitor.h"

@class TransferInput;

@interface TransferEndpoint : NSManagedObject
{
	@private
		BOOL isSelectedForSelectableObjectTableView;
}

// Inverse Relationships
@property (nonatomic, retain) NSSet *transferFromEndpoint;
@property (nonatomic, retain) NSSet *transferToEndpoint;

-(NSString*)endpointLabel;

@property BOOL isSelectedForSelectableObjectTableView;

-(void)acceptEndpointVisitor:(id<TransferEndpointVisitor>)endpointVisitor;

@end

@interface TransferEndpoint (CoreDataGeneratedAccessors)

- (void)addTransferFromEndpointObject:(TransferInput *)value;
- (void)removeTransferFromEndpointObject:(TransferInput *)value;
- (void)addTransferFromEndpoint:(NSSet *)values;
- (void)removeTransferFromEndpoint:(NSSet *)values;

- (void)addTransferToEndpointObject:(TransferInput *)value;
- (void)removeTransferToEndpointObject:(TransferInput *)value;
- (void)addTransferToEndpoint:(NSSet *)values;
- (void)removeTransferToEndpoint:(NSSet *)values;

@end
