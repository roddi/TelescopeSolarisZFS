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
	
	unsigned int counter = 1;
	unsigned int count = [lines count];
	NSString * fullOutputString = @"";
	
	{
		NSString * outputString = @"";
		outputString = [outputString stringByAppendingFormat:@"#!/bin/bash\n\n# automatically generated script. editing this is pretty pointless\n\n"];
		outputString = [outputString stringByAppendingFormat:@"MACZFSPATH=/\n\n"];
		printf("%s", [outputString UTF8String]);
		fullOutputString = [fullOutputString stringByAppendingString:outputString];		
	}
	
	for (NSString * line in lines)
	{	
		NSString * commitID = [line stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		NSString * outputString = @"";
		outputString = [outputString stringByAppendingFormat:@"echo \"--- Revision: %d (%d/%d) --- \"\n", commitID, counter, count];

		outputString = [outputString stringByAppendingFormat:@"echo \"checkout...\"\n"];
		outputString = [outputString stringByAppendingFormat:@"git checkout %@", commitID];
/*		
		outputString = [outputString stringByAppendingFormat:@"echo \"git add...\"\n", [revNumber intValue], counter, count];		
 		outputString = [outputString stringByAppendingFormat:@"git add usr/src\n", [dict objectForKey:@"message"], [dict objectForKey:@"commitID"]];

		outputString = [outputString stringByAppendingFormat:@"echo \"git commit...\"\n", [revNumber intValue], counter, count];		
 		outputString = [outputString stringByAppendingFormat:@"git commit -a -m \"%@ ---- hg commit id: %@ \"\n", [dict objectForKey:@"message"], [dict objectForKey:@"commitID"]];
		outputString = [outputString stringByAppendingFormat:@"echo \" \"\n"];
		outputString = [outputString stringByAppendingFormat:@"\n"];
*/		
		printf("%s", [outputString UTF8String]);
		fullOutputString = [fullOutputString stringByAppendingString:outputString];
		counter++;
	}
	
    [pool drain];
    return 0;
}
