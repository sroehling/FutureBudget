//
//  InputTagAdder.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import <Foundation/Foundation.h>
#import "TableViewObjectAdder.h"
#import "DataModelController.h"

@interface InputTagAdder : NSObject <TableViewObjectAdder>
{
	@private
		DataModelController *addTagDmc;
		DataModelController *parentDmc;
}

@property(nonatomic,retain) DataModelController *addTagDmc;
@property(nonatomic,retain) DataModelController *parentDmc;

@end
