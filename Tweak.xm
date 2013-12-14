typedef enum {
	CallEventIncomingCall = 1,
	CallEventCallCancelled = 4
} CallEvent;

%ctor
{
	NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];

	[notifyCenter addObserverForName:@"kSIPCallNotification" object:nil queue:nil usingBlock:^(NSNotification *notification)
		{
			NSLog(@"BetterFritz: Incoming notification!");
			NSDictionary *userInfo = [notification userInfo];

			int callType = [[userInfo objectForKey:@"callEvent"] intValue];
			NSLog(@"Call type: %i",callType);
			if (callType == CallEventIncomingCall)
			{
				//Post Call notification
				UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			    localNotification.fireDate = [NSDate date];
			    localNotification.timeZone = [NSTimeZone defaultTimeZone];	

			    NSDictionary *remoteDict = userInfo[@"remoteDictionary"];
			    NSLog(@"remoteDict: %@",remoteDict);

			    NSString *bodyFormatString = NSLocalizedString(@"locNotifIncomingCall",nil) ?: @"Incoming Call from %@";
			    NSString *caller = ! ([remoteDict[@"name"] isEqualToString:@" "] || remoteDict[@"name"] == nil)  ? remoteDict[@"name"] : remoteDict[@"number"];
			    NSLog(@"caller: %@",caller);
			    NSString *body = [NSString stringWithFormat:bodyFormatString,caller];
				
			 
			    localNotification.alertBody = body;
			   	
			   	[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
			    [localNotification release];
			}

			else if (callType == CallEventCallCancelled)
			{
				[[UIApplication sharedApplication] cancelAllLocalNotifications];
			}

		}];
}


/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
