// Clear for ProWidgets
// Created by Julian (insanj) Weiss
// Source and license fully available on GitHub.

#import "CWViewController.h"
#import "CWTheme.h"
#import "CWWidget.h"

#define CWCONTENTHEIGHT 270.0

@implementation CWViewController

- (void)load {
	self.requiresKeyboard = YES;
	self.shouldMaximizeContentHeight = NO;
	self.shouldAutoConfigureStandardButtons = YES;

	_clearTheme = [[CWTheme alloc] initWithName:@"CWTheme" bundle:[NSBundle bundleForClass:self.class] widget:self.widget disabledBlur:NO];
	self.view.backgroundColor = [_clearTheme tintColor];
}

- (NSString *)title {
	return @"Clear";
}

- (void)loadView {
	self.view = [[UITextView new] autorelease];

	_textView = [[UITextView alloc] initWithFrame:self.view.frame];
	_textView.delegate = self;

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}

-(UITableView *)tableView {
	return (UITableView *) self.view;
}

- (CGFloat)contentHeightForOrientation:(PWWidgetOrientation)orientation {
	return CWCONTENTHEIGHT;
}

- (void)willBePresentedInNavigationController:(UINavigationController *)navigationController {
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:((CWWidget *)self.widget).addTaskImage style:UIBarButtonItemStylePlain target:self action:@selector(triggerAction)] autorelease];
	[[self textView] becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range {
	[self triggerAction];
	return YES;
}

- (void)triggerAction {
	NSString *scheme = [@"clearapp://task/create?taskName=" stringByAppendingString:[self textView].text];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)dealloc {
	[_clearTheme release];
	[super dealloc];
}

/*** UITableViewDelegate ***/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row == 0 ? CWCONTENTHEIGHT - 50.0 : 50.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

	unsigned int row = [indexPath row];

	if (row >= [_reminders count]) return;

	EKEventStore *store = self.store;
	EKReminder *reminder = _reminders[row];

	NSError *error = nil;
	if ([store removeReminder:reminder commit:YES error:&error]) {
		[_reminders removeObjectAtIndex:row];
		[self reload];
		applyFadeTransition(tableView, PWTransitionAnimationDuration);
	}
}

//////////////////////////////////////////////////////////////////////

/**
 * UITableViewDataSource
 **/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_reminders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	unsigned int row = [indexPath row];

	NSString *identifier = @"PWWidgetRemindersTableViewCell";
	PWWidgetRemindersTableViewCell *cell = (PWWidgetRemindersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

	if (!cell) {
		cell = [[[PWWidgetRemindersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier theme:self.theme] autorelease];
		[cell setButtonTarget:self action:@selector(buttonPressed:)];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	EKReminder *reminder = _reminders[row];

	// reminder title
	[cell setTitle:reminder.title];

	// reminder alarm
	NSArray *alarms = reminder.alarms;
	if ([alarms count] > 0) {

		NSDate *alarmDate = nil;
		EKRecurrenceRule *recurrenceRule = nil;

		// alarm date
		EKAlarm *alarm = alarms[0];
		alarmDate = alarm.absoluteDate;

		// repeat
		NSArray *recurrenceRules = reminder.recurrenceRules;
		if ([recurrenceRules count] > 0) {
			recurrenceRule = recurrenceRules[0];
		}

		[cell setAlarmDate:alarmDate recurrenceRule:recurrenceRule];
	}

	EKCalendar *calendar = reminder.calendar;
	CGColorRef color = calendar.CGColor;
	UIColor *colorUI = [UIColor colorWithCGColor:color];
	if (colorUI == nil) colorUI = [UIColor blackColor];
	[cell setListColor:colorUI];

	[cell setButtonReminder:reminder];

	return cell;
}

- (void)loadReminders {

	dispatch_async(dispatch_get_global_queue(0, 0), ^{

		NSPredicate *predicate = [self.store predicateForIncompleteRemindersWithDueDateStarting:nil ending:nil calendars:nil];
		[self.store fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {

			[_reminders release];
			_reminders = [reminders mutableCopy];

			dispatch_sync(dispatch_get_main_queue(), ^{
				// reload table view
				[self reload];
				applyFadeTransition(self.tableView, PWTransitionAnimationDuration);
			});
		}];
	});
}

- (void)buttonPressed:(UIButton *)button {
	EKReminder *reminder = objc_getAssociatedObject(button, &PWWidgetRemindersTableViewCellReminderKey);
	if (reminder != nil) {
		EKEventStore *store = self.store;
		reminder.completed = YES;
		if ([store saveReminder:reminder commit:YES error:nil]) {
			[_reminders removeObject:reminder];
			[self reload];
			applyFadeTransition(self.tableView, PWTransitionAnimationDuration);
		}
	}


@end
