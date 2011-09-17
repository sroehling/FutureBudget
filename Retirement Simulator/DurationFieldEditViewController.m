//
//  DurationFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DurationFieldEditViewController.h"
#import "DurationInfo.h"
#import "FieldInfo.h"


#define DURATION_PICKER_YEAR_COMPONENT 0
#define DURATION_PICKER_MONTH_COMPONENT 1
#define DURATION_PICKER_NUM_YEARS 100
#define DURATION_PICKER_NUM_MONTHS 360


@implementation DurationFieldEditViewController

@synthesize durationPicker;
@synthesize durationFieldInfo;


- (id)initWithDurationFieldInfo:(FieldInfo*)theFieldInfo
{
	assert(theFieldInfo != nil);
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.durationFieldInfo = theFieldInfo;
    }
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	assert(0); // init not supported from NIB
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// TODO - Need to init with a frame that is sized for the current device
	self.durationPicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)] autorelease];
	self.durationPicker.showsSelectionIndicator = YES;
	[self.view addSubview:durationPicker];
	[self.durationPicker setDelegate:self];
	
	NSNumber *durationVal = [self.durationFieldInfo getFieldValue];
	DurationInfo *durationInfo = [[[DurationInfo alloc] initWithTotalMonths:durationVal] autorelease];
	
	[self.durationPicker selectRow:durationInfo.yearsPart inComponent:DURATION_PICKER_YEAR_COMPONENT animated:FALSE];
	[self.durationPicker selectRow:durationInfo.monthsPart inComponent:DURATION_PICKER_MONTH_COMPONENT animated:FALSE];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void) dealloc
{
	[super dealloc];
	[durationFieldInfo release];
	[durationPicker release];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {

	return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger) component
{

    if (component == DURATION_PICKER_YEAR_COMPONENT) {
		return DURATION_PICKER_NUM_YEARS;
	}
	else if(component == DURATION_PICKER_MONTH_COMPONENT)
	{
		return DURATION_PICKER_NUM_MONTHS;
	}
	else
	{
		assert(0); // should not get here
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 

    if (component == DURATION_PICKER_YEAR_COMPONENT) {
		NSString *yearPickerLabel = (row > 0)?
			[NSString stringWithFormat:@"%d %@",row,
				[DurationInfo formatYearLabel:row]]:@"";
		return yearPickerLabel;
	}
	else if(component == DURATION_PICKER_MONTH_COMPONENT)
	{
		NSString *monthPickerLabel = (row > 0)?
			[NSString stringWithFormat:@"%d %@",row,
				[DurationInfo formatMonthLabel:row]]:@"";
		return monthPickerLabel;
	}
	else
	{
		assert(0); // should not get here
	}


}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	NSInteger years = [self.durationPicker selectedRowInComponent:DURATION_PICKER_YEAR_COMPONENT];
	NSInteger months = [self.durationPicker selectedRowInComponent:DURATION_PICKER_MONTH_COMPONENT];
	
	// Don't allow both years and months to be 0
	if((years==0) && (months==0))
	{
		months = 1;
	}
	
	DurationInfo *durationInfo = [[[DurationInfo alloc] initWithYearPart:years 
		andMonthsPart:months] autorelease];

	[self.durationFieldInfo setFieldValue:durationInfo.totalMonths];

}


@end
