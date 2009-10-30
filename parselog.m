#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    NSLog(@"Hello, World!");
	
	if (argc != 2)
	{
		printf("usage:\n  %s <input file>\n", argv[0]);
		return -1;
	}

	NSString * inputFilepath = [NSString stringWithUTF8String:argv[1]];

	NSString * log = [NSString stringWithContentsOfFile:inputFilepath];
	
	NSArray * lines = [log componentsSeparatedByString:@"\n"];
	
	NSMutableDictionary * commits = [NSMutableDictionary dictionary];
	for (NSString * line in lines)
	{
		NSArray * lineComponents = [line componentsSeparatedByString:@":::"];
		if ([line hasPrefix:@"#"] || [lineComponents count] < 2)
		{
			NSLog (@"skipping line: %@", line);
			continue;
		}
		
		NSString * revision = [lineComponents objectAtIndex:0];
		NSString * commitID = [lineComponents objectAtIndex:1];
		NSString * message = @"";
		if ([lineComponents count] > 2)
			message = [lineComponents objectAtIndex:2];
		
		message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
		
		NSNumber * revisionNumber = [NSNumber numberWithInteger:[revision integerValue]];
		
		if ([commits objectForKey:revisionNumber])
		{
			if (![commitID isEqualToString:[[commits objectForKey:revisionNumber] objectForKey:@"commitID"]])
				NSLog(@"COMMIT ID MISMATCH: rev%@: %@(known) != %@(new)", [revisionNumber description], [[commits objectForKey:revision] objectForKey:@"commitID"], commitID);
		}		
		else
		{
			NSMutableDictionary * dict = [NSMutableDictionary dictionary];
			[dict setObject:commitID forKey:@"commitID"];
			[dict setObject:message forKey:@"message"];
			
			[commits setObject:dict forKey:revisionNumber];
		}
	}

	NSArray * sortedRevs = [[commits allKeys] sortedArrayUsingSelector:@selector(compare:)];
	unsigned int counter = 1;
	unsigned int count = [sortedRevs count];
	NSString * fullOutputString = @"";
	
	{
		NSString * outputString = @"";
		outputString = [outputString stringByAppendingFormat:@"#!/bin/bash\n\n# automatically generated script. editing this is pretty pointless\n\n# initializing git repo\n"];
		outputString = [outputString stringByAppendingFormat:@"git init\n\n"];
		outputString = [outputString stringByAppendingFormat:@"#this checks out the needed revisions from hg and commits them to git\n"];
		printf("%s", [outputString UTF8String]);
		fullOutputString = [fullOutputString stringByAppendingString:outputString];		
	}
	
	for (NSString * revNumber in sortedRevs)
	{
		NSMutableDictionary * dict = [commits objectForKey:revNumber];
		
		NSString * outputString = @"";
		outputString = [outputString stringByAppendingFormat:@"echo \"--- Revision: %d (%d/%d) --- \"\n", [revNumber intValue], counter, count];

		outputString = [outputString stringByAppendingFormat:@"echo \"hg checkout...\"\n", [revNumber intValue], counter, count];
		outputString = [outputString stringByAppendingFormat:@"hg checkout -r %@ \n", [dict objectForKey:@"commitID"]];
		
		outputString = [outputString stringByAppendingFormat:@"echo \"git commit...\"\n", [revNumber intValue], counter, count];
 		outputString = [outputString stringByAppendingFormat:@"git commit -a -m \"%@ ---- hg commit id: %@ \"\n", [dict objectForKey:@"message"], [dict objectForKey:@"commitID"]];
		outputString = [outputString stringByAppendingFormat:@"echo \" \"\n"];
		outputString = [outputString stringByAppendingFormat:@"\n"];
		
		printf("%s", [outputString UTF8String]);
		fullOutputString = [fullOutputString stringByAppendingString:outputString];
		counter++;
	}
	
    [pool drain];
    return 0;
}
