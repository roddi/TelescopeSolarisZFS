#import <Foundation/Foundation.h>

NSString * bigDifferPath = @"/tmp/bigdiffer";

void generateDiffingScript(NSArray * inCommits)
{
	unsigned int counter = 1;
	unsigned int count = [inCommits count];
	NSString * fullOutputString = @"";
	
	{
		NSString * outputString = @"";
		outputString = [outputString stringByAppendingFormat:@"#!/bin/bash\n\n# This is an automatically generated script. editing is pretty pointless\n\n"];
		outputString = [outputString stringByAppendingFormat:@"MACZFSPATH=\"../../mac-zfs\"\n"];
		outputString = [outputString stringByAppendingFormat:@"ONNVPATH=\".\"\n"];
		outputString = [outputString stringByAppendingFormat:@"TEMPFILEPATH=\"%@\"\n\n", bigDifferPath];
		outputString = [outputString stringByAppendingFormat:@"echo \"making directory $TEMPFILEPATH\"\n"];
		outputString = [outputString stringByAppendingFormat:@"mkdir $TEMPFILEPATH\n"];
		
		printf("%s", [outputString UTF8String]);
		fullOutputString = [fullOutputString stringByAppendingString:outputString];		
	}
	
	// object: onnv / key: mac-zfs
	NSDictionary * onnvPathsForMacZFSPaths = 
	[NSDictionary dictionaryWithObjectsAndKeys:
	 @"zfs_commands/zfs/zfs_main.c", @"zfs_commands/zfs/zfs_main.c",
	 @"zfs_commands/zfs/zfs_iter.c", @"zfs_commands/zfs/zfs_iter.c",
	 
	 @"zfs_commands/zpool/zpool_main.c", @"zfs_commands/zpool/zpool_main.c",
	 @"zfs_commands/zpool/zpool_util.c", @"zfs_commands/zpool/zpool_util.c",
	 @"zfs_commands/zpool/zpool_vdef.c", @"zfs_commands/zpool/zpool_vdev.c",
	 
	 @"zfs_commands/ztest/ztest.c", @"zfs_commands/ztest/ztest.c",
	 
	 @"zfs_common/zfs/zfs_prop.c", @"zfs_common/zfs/zfs_prop.c",
	 @"zfs_common/zfs/zfs_prop.h", @"zfs_common/zfs/zfs_prop.h",
	 
	 @"zfs_common/avl/avl.c", @"zfs_common/avl/avl.c",
	 
	 @"zfs_kext/os/kmem.c", @"zfs_kext/os/kmem.c",
	 @"zfs_kext/os/taskq.c", @"zfs_kext/os/taskq.c",
	 
	 @"zfs_kext/zfs/sys/arc.h", @"zfs_kext/zfs/sys/arc.h",
	 @"zfs_kext/zfs/sys/dmu.h", @"zfs_kext/zfs/sys/dmu.h",
	 
	 @"zfs_kext/zfs/spa.c", @"zfs_kext/zfs/spa.c",
	 @"zfs_kext/zfs/arc.c", @"zfs_kext/zfs/arc.c",
	 @"zfs_kext/zfs/dnode.c", @"zfs_kext/zfs/dnode.c",
	 @"zfs_kext/zfs/zfs_ioctl.c",@"zfs_kext/zfs/zfs_ioctl.c",
	 @"zfs_kext/zfs/refcount.c", @"zfs_kext/zfs/refcount.c",
	 @"zfs_kext/zfs/sha256.c", @"zfs_kext/zfs/sha256.c",
	 @"zfs_kext/zfs/zfs_acl.c", @"zfs_kext/zfs/zfs_acl.c",
	 @"zfs_kext/zfs/zfs_vnops.c", @"zfs_kext/zfs/zfs_vnops.c",
	 @"zfs_kext/zfs/zfs_vfsops.c", @"zfs_kext/zfs/zfs_vfsops.c",
	 
	 
	 @"zfs_lib/libzfs/libzfs.h", @"zfs_lib/libzfs/libzfs.h",
	 @"zfs_lib/libzfs/libzfs_dataset.c", @"zfs_lib/libzfs/libzfs_dataset.c",
	 nil];
	
	for (NSString * commitID in inCommits)
	{	
		NSString * outputString = @"";
		outputString = [outputString stringByAppendingFormat:@"\necho \"--- Revision: %d (%d/%d) --- \"\n", commitID, counter, count];
		
		outputString = [outputString stringByAppendingFormat:@"echo \"checkout...\"\n"];
		outputString = [outputString stringByAppendingFormat:@"git checkout %@\n", commitID];
		outputString = [outputString stringByAppendingFormat:@"rm -f $TEMPFILEPATH/%@.txt\n", commitID];
		outputString = [outputString stringByAppendingFormat:@"touch $TEMPFILEPATH/%@.txt\n", commitID];
		
		for (NSString * maczfsPath in [onnvPathsForMacZFSPaths allKeys])
		{
			NSString * onnvPath = [onnvPathsForMacZFSPaths objectForKey:maczfsPath];
			outputString = [outputString stringByAppendingFormat:@"diff -w $ONNVPATH/%@ $MACZFSPATH/%@ | wc >> $TEMPFILEPATH/%@.txt\n", 
							onnvPath, 
							maczfsPath, 
							commitID];	
		}
		printf("%s", [outputString UTF8String]);
		fullOutputString = [fullOutputString stringByAppendingString:outputString];
		counter++;
	}
}
 

void analyse(NSDictionary* inCommitDict, NSArray* inCommitIDs)
{
	//printf("commit message, line count, word count, character count\n");
	printf("commit message, character count\n");
	
	for (NSString * commitID in inCommitIDs)
	{
		NSString * wordcountPath = [NSString stringWithFormat:@"%@/%@.txt", bigDifferPath, commitID];
		NSString * wordcountString = [NSString stringWithContentsOfFile:wordcountPath];
		NSArray * lines = [wordcountString componentsSeparatedByString:@"\n"];
		
		NSUInteger wordCountForThisCommit = 0;
		NSUInteger lineCountForThisCommit = 0;
		NSUInteger characterCountForThisCommit = 0;
		
		for (NSString * line in lines)
		{
			NSScanner * lineScanner = [NSScanner scannerWithString:line];
			NSInteger lineCount = 0;
			NSInteger wordCount = 0;
			NSInteger characterCount = 0;
			if ([lineScanner scanInteger:&lineCount])
			{
				lineCountForThisCommit += lineCount;
			}
			if ([lineScanner scanInteger:&wordCount])
			{
				wordCountForThisCommit += wordCount;
			}
			if ([lineScanner scanInteger:&characterCount])
			{
				characterCountForThisCommit += characterCount;
			}
		}
/*		NSString * analysisString = [NSString stringWithFormat:@"%@,%d,%d,%d\n", 
									 [inCommitDict objectForKey:commitID], 
									 (int)lineCountForThisCommit,
									 (int)wordCountForThisCommit,
									 (int)characterCountForThisCommit];*/
		NSString * analysisString = [NSString stringWithFormat:@"%@,%d\n", 
									 [inCommitDict objectForKey:commitID], 
									 (int)characterCountForThisCommit];
		printf("%s", [analysisString UTF8String]);
	}
}


int main (int argc, const char * argv[]) 
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
    NSLog(@"Hello, World!");
	
	if (argc != 3)
	{
		printf("usage:\n  %s -[d|a] <input file>\n", argv[0]);
		return -1;
	}

	NSString * inputFilepath = [NSString stringWithUTF8String:argv[2]];

	NSString * log = [NSString stringWithContentsOfFile:inputFilepath];
	
	NSArray * lines = [log componentsSeparatedByString:@"\n"];
	
	NSMutableArray * commitIDs = [NSMutableArray array];
	NSMutableDictionary * commitDicts = [NSMutableDictionary dictionary];
	
	for (NSString * line in lines)
	{
		NSMutableArray * components = [NSMutableArray arrayWithArray:[line componentsSeparatedByString:@" "]];
		if ([components count] < 2)
			continue;
		
		NSString * commitID = [components objectAtIndex:0];
		[components removeObjectAtIndex:0];
		
		NSString * commitMessage = [components componentsJoinedByString:@" "];
		commitMessage = [commitMessage stringByReplacingOccurrencesOfString:@"," withString:@"_"];

		const NSUInteger kMaxLen = 50;
		if ([commitMessage length] > kMaxLen)
		{
			commitMessage = [commitMessage substringToIndex:kMaxLen];
		}
		
		[commitIDs addObject:commitID];
		[commitDicts setObject:commitMessage forKey:commitID];
	}

	NSString * option = [NSString stringWithUTF8String:argv[1]];
	
	if ([option isEqualToString:@"-d"])
	{
		generateDiffingScript(commitIDs);
	}
	else 
	if ([option isEqualToString:@"-a"])
	{
		analyse(commitDicts, commitIDs);
	}
	else 
	{
		NSLog(@"unknown option: %@", option);
	}
	
    [pool drain];
    return 0;
}
