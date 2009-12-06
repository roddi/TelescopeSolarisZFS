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
		//outputString = [outputString stringByAppendingFormat:@"MACZFSPATH=\"../../mac-zfs/upstream/opensolaris\"\n"];
		outputString = [outputString stringByAppendingFormat:@"MACZFSPATH=\"../../maczfs-10a286/src\"\n"];
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
	 @"usr/src/cmd/zpool/zpool_vdev.c", @"cmd/zpool/zpool_vdev.c",
	 
	 @"usr/src/cmd/ztest/ztest.c", @"cmd/ztest/ztest.c",
	 
	 @"usr/src/common/avl/avl.c", @"common/avl/avl.c",
	 
	 @"usr/src/common/nvpair/nvpair.c", @"common/nvpair/nvpair.c",

	 @"usr/src/common/zfs/zfs_namecheck.c", @"common/zfs/zfs_namecheck.c",
	 @"usr/src/common/zfs/zfs_prop.c", @"common/zfs/zfs_prop.c",
	 @"usr/src/common/zfs/zfs_prop.h", @"common/zfs/zfs_prop.h",
	 @"usr/src/common/zfs/zprop_common.c", @"common/zfs/zprop_common.c",
	 
	 @"usr/src/head/libintl.h", @"head/libintl.h",

	 @"usr/src/lib/libzfs/common/libzfs.h", @"lib/libzfs/common/libzfs.h",
	 @"usr/src/lib/libzfs/common/libzfs_dataset.c", @"lib/libzfs/common/libzfs_dataset.c",
	 @"usr/src/lib/libzfs/common/libzfs_impl.h", @"lib/libzfs/common/libzfs_impl.h",
	 @"usr/src/lib/libzfs/common/libzfs_import.c", @"lib/libzfs/common/libzfs_import.c",
	 @"usr/src/lib/libzfs/common/libzfs_pool.c", @"lib/libzfs/common/libzfs_pool.c",
	 @"usr/src/lib/libzfs/common/libzfs_util.c", @"lib/libzfs/common/libzfs_util.c",
	 
	 @"usr/src/uts/common/fs/zfs/arc.c", @"uts/common/fs/zfs/arc.c",
	 @"usr/src/uts/common/fs/zfs/bplist.c", @"uts/common/fs/zfs/bplist.c",
	 @"usr/src/uts/common/fs/zfs/dbuf.c", @"uts/common/fs/zfs/dbuf.c",
	 
	 @"usr/src/uts/common/fs/zfs/dmu.c", @"uts/common/fs/zfs/dmu.c",
	 @"usr/src/uts/common/fs/zfs/dmu_object.c", @"uts/common/fs/zfs/dmu_object.c",
	 @"usr/src/uts/common/fs/zfs/dmu_objset.c", @"uts/common/fs/zfs/dmu_objset.c",
	 @"usr/src/uts/common/fs/zfs/dmu_send.c", @"uts/common/fs/zfs/dmu_send.c",
	 @"usr/src/uts/common/fs/zfs/dmu_traverse.c", @"uts/common/fs/zfs/dmu_traverse.c",
	 @"usr/src/uts/common/fs/zfs/dmu_tx.c", @"uts/common/fs/zfs/dmu_tx.c",
	 
	 @"usr/src/uts/common/fs/zfs/dnode.c", @"uts/common/fs/zfs/dnode.c",
	 @"usr/src/uts/common/fs/zfs/dnode_sync.c", @"uts/common/fs/zfs/dnode_sync.c",
	 @"usr/src/uts/common/fs/zfs/dsl_dataset.c", @"uts/common/fs/zfs/dsl_dataset.c",
	 @"usr/src/uts/common/fs/zfs/dsl_dir.c", @"uts/common/fs/zfs/dsl_dir.c",
	 @"usr/src/uts/common/fs/zfs/dsl_pool.c", @"uts/common/fs/zfs/dsl_pool.c",
	 @"usr/src/uts/common/fs/zfs/dsl_prop.c", @"uts/common/fs/zfs/dsl_prop.c",
	 @"usr/src/uts/common/fs/zfs/dsl_scrub.c", @"uts/common/fs/zfs/dsl_scrub.c",	 
	 @"usr/src/uts/common/fs/zfs/refcount.c", @"uts/common/fs/zfs/refcount.c",
	 @"usr/src/uts/common/fs/zfs/sha256.c", @"uts/common/fs/zfs/sha256.c",
	 @"usr/src/uts/common/fs/zfs/spa.c", @"uts/common/fs/zfs/spa.c",
	 @"usr/src/uts/common/fs/zfs/spa_config.c", @"uts/common/fs/zfs/spa_config.c",
	 @"usr/src/uts/common/fs/zfs/spa_errlog.c", @"uts/common/fs/zfs/spa_errlog.c",
	 @"usr/src/uts/common/fs/zfs/spa_history.c", @"uts/common/fs/zfs/spa_history.c",
	 @"usr/src/uts/common/fs/zfs/spa_misc.c", @"uts/common/fs/zfs/spa_misc.c",

	 @"usr/src/uts/common/fs/zfs/sys/arc.h", @"uts/common/fs/zfs/sys/arc.h",
	 @"usr/src/uts/common/fs/zfs/sys/bplist.h", @"uts/common/fs/zfs/sys/bplist.h",
	 @"usr/src/uts/common/fs/zfs/sys/dbuf.h", @"uts/common/fs/zfs/sys/dbuf.h",
	 @"usr/src/uts/common/fs/zfs/sys/dmu.h", @"uts/common/fs/zfs/sys/dmu.h",
	 @"usr/src/uts/common/fs/zfs/sys/dmu_objset.h", @"uts/common/fs/zfs/sys/dmu_objset.h",
	 @"usr/src/uts/common/fs/zfs/sys/dmu_tx.h", @"uts/common/fs/zfs/sys/dmu_tx.h",
	 @"usr/src/uts/common/fs/zfs/sys/dnode.h", @"uts/common/fs/zfs/sys/dnode.h",
	 @"usr/src/uts/common/fs/zfs/sys/dsl_dataset.h", @"uts/common/fs/zfs/sys/dsl_dataset.h",
	 @"usr/src/uts/common/fs/zfs/sys/dsl_dir.h", @"uts/common/fs/zfs/sys/dsl_dir.h",
	 @"usr/src/uts/common/fs/zfs/sys/dsl_pool.h", @"uts/common/fs/zfs/sys/dsl_pool.h",
	 @"usr/src/uts/common/fs/zfs/sys/dsl_prop.h", @"uts/common/fs/zfs/sys/dsl_prop.h",
	 @"usr/src/uts/common/fs/zfs/sys/spa.h", @"uts/common/fs/zfs/sys/spa.h",
	 @"usr/src/uts/common/fs/zfs/sys/spa_impl.h", @"uts/common/fs/zfs/sys/spa_impl.h",
	 @"usr/src/uts/common/fs/zfs/sys/txg.h", @"uts/common/fs/zfs/sys/txg.h",
	 @"usr/src/uts/common/fs/zfs/sys/vdev.h", @"uts/common/fs/zfs/sys/vdev.h",
	 @"usr/src/uts/common/fs/zfs/sys/vdev_impl.h", @"uts/common/fs/zfs/sys/vdev_impl.h",
	 @"usr/src/uts/common/fs/zfs/sys/zap.h", @"uts/common/fs/zfs/sys/zap.h",
	 @"usr/src/uts/common/fs/zfs/sys/zap_leaf.h", @"uts/common/fs/zfs/sys/zap_leaf.h",
	 @"usr/src/uts/common/fs/zfs/sys/zfs_znode.h", @"uts/common/fs/zfs/sys/zfs_znode.h",
	 @"usr/src/uts/common/fs/zfs/sys/zio.h", @"uts/common/fs/zfs/sys/zio.h",
	 	 
	 @"usr/src/uts/common/fs/zfs/txg.c", @"uts/common/fs/zfs/txg.c",
	 
	 @"usr/src/uts/common/fs/zfs/vdev.c", @"uts/common/fs/zfs/vdev.c",
	 @"usr/src/uts/common/fs/zfs/vdev_disk.c", @"uts/common/fs/zfs/vdev_disk.c",
	 @"usr/src/uts/common/fs/zfs/vdev_file.c", @"uts/common/fs/zfs/vdev_file.c",
	 @"usr/src/uts/common/fs/zfs/vdev_label.c", @"uts/common/fs/zfs/vdev_label.c",
	 @"usr/src/uts/common/fs/zfs/vdev_root.c", @"uts/common/fs/zfs/vdev_root.c",
	 
	 @"usr/src/uts/common/fs/zfs/zap.c", @"uts/common/fs/zfs/zap.c",
	 @"usr/src/uts/common/fs/zfs/zfs_acl.c", @"uts/common/fs/zfs/zfs_acl.c",
	 @"usr/src/uts/common/fs/zfs/zfs_ctldir.c",@"uts/common/fs/zfs/zfs_ctldir.c",
	 @"usr/src/uts/common/fs/zfs/zfs_dir.c",@"uts/common/fs/zfs/zfs_dir.c",
	 @"usr/src/uts/common/fs/zfs/zfs_fm.c",@"uts/common/fs/zfs/zfs_fm.c",
	 @"usr/src/uts/common/fs/zfs/zfs_ioctl.c",@"uts/common/fs/zfs/zfs_ioctl.c",
	 @"usr/src/uts/common/fs/zfs/zfs_vnops.c", @"uts/common/fs/zfs/zfs_vnops.c",
	 @"usr/src/uts/common/fs/zfs/zfs_vfsops.c", @"uts/common/fs/zfs/zfs_vfsops.c",
	 @"usr/src/uts/common/fs/zfs/zfs_znode.c", @"uts/common/fs/zfs/zfs_znode.c",
	 @"usr/src/uts/common/fs/zfs/zio.c", @"uts/common/fs/zfs/zio.c",
	 @"usr/src/uts/common/fs/zfs/zil.c", @"uts/common/fs/zfs/zil.c",
	 @"usr/src/uts/common/fs/zfs/zvol.c", @"uts/common/fs/zfs/zvol.c",

	 @"usr/src/uts/common/os/kmem.c", @"uts/common/os/kmem.c",
	 @"usr/src/uts/common/os/list.c", @"uts/common/os/list.c",
	 @"usr/src/uts/common/os/taskq.c", @"uts/common/os/taskq.c",
	 
	 @"usr/src/uts/common/sys/avl.h", @"uts/common/sys/avl.h",
	 @"usr/src/uts/common/sys/kmem.h", @"uts/common/sys/kmem.h",
	 @"usr/src/uts/common/sys/kmem_impl.h", @"uts/common/sys/kmem_impl.h",
	 @"usr/src/uts/common/sys/list.h", @"uts/common/sys/list.h",
	 @"usr/src/uts/common/sys/mutex.h", @"uts/common/sys/mutex.h",
//	 @"usr/src/uts/common/sys/vfs.h", @"uts/common/sys/vfs.h",

	 @"usr/src/uts/common/sys/fs/zfs.h", @"uts/common/sys/fs/zfs.h",
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
	printf("commit message, chars\n");
	
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
