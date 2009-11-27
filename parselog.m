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
		outputString = [outputString stringByAppendingFormat:@"MACZFSPATH=\"../../mac-zfs/upstream/opensolaris\"\n"];
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
	 @"usr/src/cmd/zfs/zfs_main.c", @"cmd/zfs/zfs_main.c",
	 @"usr/src/cmd/zfs/zfs_iter.c", @"cmd/zfs/zfs_iter.c",
	 
	 @"usr/src/cmd/zpool/zpool_main.c", @"cmd/zpool/zpool_main.c",
	 @"usr/src/cmd/zpool/zpool_util.c", @"cmd/zpool/zpool_util.c",
	 @"usr/src/cmd/zpool/zpool_vdef.c", @"cmd/zpool/zpool_vdev.c",
	 
	 @"usr/src/cmd/ztest/ztest.c", @"cmd/ztest/ztest.c",
	 
	 @"usr/src/common/zfs/zfs_prop.c", @"common/zfs/zfs_prop.c",
	 @"usr/src/common/zfs/zfs_prop.h", @"common/zfs/zfs_prop.h",
	 
	 @"usr/src/common/avl/avl.c", @"common/avl/avl.c",
	 
	 @"usr/src/uts/common/os/kmem.c", @"uts/common/os/kmem.c",
	 @"usr/src/uts/common/os/taskq.c", @"uts/common/os/taskq.c",
	 
	 @"usr/src/uts/common/fs/zfs/sys/arc.h", @"uts/common/fs/zfs/sys/arc.h",
	 @"usr/src/uts/common/fs/zfs/sys/dmu.h", @"uts/common/fs/zfs/sys/dmu.h",
	 
	 @"usr/src/uts/common/fs/zfs/spa.c", @"uts/common/fs/zfs/spa.c",
	 @"usr/src/uts/common/fs/zfs/arc.c", @"uts/common/fs/zfs/arc.c",
	 @"usr/src/uts/common/fs/zfs/dnode.c", @"uts/common/fs/zfs/dnode.c",
	 @"usr/src/uts/common/fs/zfs/zfs_ioctl.c",@"uts/common/fs/zfs/zfs_ioctl.c",
	 @"usr/src/uts/common/fs/zfs/refcount.c", @"uts/common/fs/zfs/refcount.c",
	 @"usr/src/uts/common/fs/zfs/sha256.c", @"uts/common/fs/zfs/sha256.c",
	 @"usr/src/uts/common/fs/zfs/zfs_acl.c", @"uts/common/fs/zfs/zfs_acl.c",
	 @"usr/src/uts/common/fs/zfs/zfs_vnops.c", @"uts/common/fs/zfs/zfs_vnops.c",
	 @"usr/src/uts/common/fs/zfs/zfs_vfsops.c", @"uts/common/fs/zfs/zfs_vfsops.c",
	 
	 
	 @"usr/src/lib/libzfs/common/libzfs.h", @"lib/libzfs/libzfs.h",
	 @"usr/src/lib/libzfs/common/libzfs_dataset.c", @"lib/libzfs/libzfs_dataset.c",
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
