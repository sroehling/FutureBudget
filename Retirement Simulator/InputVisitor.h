//
//  InputVisitor.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol InputVisitor <NSObject>

- visitExpense:(ExpenseInput*)expense;

@end
