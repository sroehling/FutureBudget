//
//  RelativeDatePickerViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RelativeDatePickerViewController.h"
#import "RelativeEndDate.h"
#import "LocalizationHelper.h"
#import "FieldInfo.h"
#import "RelativeEndDateInfo.h"

#define RELATIVE_DATE_PICKER_YEAR_COMPONENT 0
#define RELATIVE_DATE_PICKER_MONTH_COMPONENT 1
#define RELATIVE_DATE_PICKER_WEEK_COMPONENT 2
#define RELATIVE_DATE_PICKER_NUM_YEARS 100
#define RELATIVE_DATE_PICKER_NUM_MONTHS 360
#define RELATIVE_DATE_PICKER_NUM_WEEKS 52

@implementation RelativeDatePickerViewController

@synthesize relDatePicker;
@synthesize relEndDateFieldInfo;
@synthesize relEndDateInfo;

- (id)initWithRelativeEndDateFieldInfo:(FieldInfo*)theRelEndDateFieldInfo
{
	assert(theRelEndDateFieldInfo != nil);
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.relEndDateFieldInfo = theRelEndDateFieldInfo;
		self.relEndDateInfo = (RelativeEndDateInfo*)[theRelEndDateFieldInfo getFieldValue];
    }
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	assert(0); // init not supported from NIB
}

- (void)dealloc
{
    [super dealloc];
	[relDatePicker release];
	[relEndDateFieldInfo release];
	[relEndDateInfo release];
}


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.relDatePicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,320, 500)] autorelease];
	self.relDatePicker.showsSelectionIndicator = YES;
	[self.view addSubview:relDatePicker];
	[self.relDatePicker setDelegate:self];
	
	[self.relDatePicker selectRow:self.relEndDateInfo.years inComponent:RELATIVE_DATE_PICKER_YEAR_COMPONENT animated:FALSE];
	[self.relDatePicker selectRow:self.relEndDateInfo.months inComponent:RELATIVE_DATE_PICKER_MONTH_COMPONENT animated:FALSE];
	[self.relDatePicker selectRow:self.relEndDateInfo.weeks inComponent:RELATIVE_DATE_PICKER_WEEK_COMPONENT animated:FALSE];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {

	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger) component
{

    if (component == RELATIVE_DATE_PICKER_YEAR_COMPONENT) {
		return RELATIVE_DATE_PICKER_NUM_YEARS;
	}
	else if(component == RELATIVE_DATE_PICKER_MONTH_COMPONENT)
	{
		return RELATIVE_DATE_PICKER_NUM_MONTHS;
	}
	else if(component == RELATIVE_DATE_PICKER_WEEK_COMPONENT)
	{
		return RELATIVE_DATE_PICKER_NUM_WEEKS;
	}
	else
	{
		assert(0); // should not get here
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 

    if (component == RELATIVE_DATE_PICKER_YEAR_COMPONENT) {
		return [NSString stringWithFormat:@"%d Y",row];
	}
	else if(component == RELATIVE_DATE_PICKER_MONTH_COMPONENT)
	{
		return [NSString stringWithFormat:@"%d M",row];
	}
	else if(component == RELATIVE_DATE_PICKER_WEEK_COMPONENT)
	{
		return [NSString stringWithFormat:@"%d W",row];
	}
	else
	{
		assert(0); // should not get here
	}


}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	self.relEndDateInfo.years = [self.relDatePicker selectedRowInComponent:RELATIVE_DATE_PICKER_YEAR_COMPONENT];
	self.relEndDateInfo.months = [self.relDatePicker selectedRowInComponent:RELATIVE_DATE_PICKER_MONTH_COMPONENT];
	self.relEndDateInfo.weeks = [self.relDatePicker selectedRowInComponent:RELATIVE_DATE_PICKER_WEEK_COMPONENT];

	[self.relEndDateFieldInfo setFieldValue:self.relEndDateInfo];

}


@end
