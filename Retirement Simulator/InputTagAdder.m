//
//  InputTagAdder.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import "InputTagAdder.h"
#import "FormContext.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "DataModelController.h"
#import "InputTagFormInfoCreator.h"
#import "Inputtag.h"

@implementation InputTagAdder

@synthesize addTagDmc;
@synthesize parentDmc;


-(void)teardownNewTagDmc
{
	if(self.addTagDmc != nil)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self 
			name:NSManagedObjectContextDidSaveNotification 
			object:self.addTagDmc.managedObjectContext];
		self.addTagDmc = nil;
	}
}

-(void)setupNewTagDmc
{
	[self teardownNewTagDmc];
	self.addTagDmc = [[[DataModelController alloc] 
			initWithPersistentStoreCoord:self.parentDmc.persistentStoreCoordinator] autorelease];
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(newFilterSavedDidSaveNotificationHandler:)
		name:NSManagedObjectContextDidSaveNotification 
		object:self.addTagDmc.managedObjectContext];	
}


- (void)newFilterSavedDidSaveNotificationHandler:(NSNotification *)notification
{
     [self.parentDmc.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}


-(void)addObjectFromTableView:(FormContext*)parentContext
{
	NSLog(@"Add email domain to domain filter");
	
	self.parentDmc = parentContext.dataModelController;
	[self setupNewTagDmc];
	
	InputTag *newTag = [self.addTagDmc insertObject:INPUT_TAG_ENTITY_NAME];
	
	InputTagFormInfoCreator *tagFormInfoCreator =
		[[[InputTagFormInfoCreator alloc] initWithTag:newTag] autorelease];
	
	GenericFieldBasedTableAddViewController *addView =  
		[[[GenericFieldBasedTableAddViewController alloc] 
		initWithFormInfoCreator:tagFormInfoCreator andNewObject:newTag
		andDataModelController:self.addTagDmc] autorelease];
	addView.popDepth = 1;
	addView.saveWhenSaveButtonPressed = TRUE;
		
	addView.disableCoreDataSaveUntilSaveButtonPressed = TRUE;

	[parentContext.parentController.navigationController pushViewController:addView animated:TRUE];
}



-(BOOL)supportsAddOutsideEditMode
{
	return FALSE;
}



@end
