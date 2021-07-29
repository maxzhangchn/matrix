/*
 * Tencent is pleased to support the open source community by making wechat-matrix available.
 * Copyright (C) 2019 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the BSD 3-Clause License (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "WCMemoryRecordManager.h"
#import "MatrixPathUtil.h"
#import "MatrixLogDef.h"

@interface WCMemoryRecordManager () {
    NSMutableArray *m_recordList;
    MemoryRecordInfo *m_currRecord;
    BOOL _printTimes;
}

@end

@implementation WCMemoryRecordManager

- (id)init
{
    self = [super init];
    if (self) {
        printf("😂😂😂😂WCMemoryRecordManager init\n");
        [self loadRecordList];
    }
    return self;
}

- (NSArray *)recordList
{
    if (m_recordList.count > 0) {
        // Filter the record of this startup
        NSMutableArray *retList = [NSMutableArray arrayWithArray:m_recordList];
        [retList removeObject:m_currRecord];
        return retList;
    } else {
        return [NSArray array];
    }
}

- (MemoryRecordInfo *)getRecordByLaunchTime:(uint64_t)launchTime
{
    printf("😂😂😂😂getRecordByLaunchTime\n");
    for (MemoryRecordInfo *record in m_recordList) {
        if (record.launchTime == launchTime) {
            return record;
        }
    }
    return nil;
}

- (void)insertNewRecord:(MemoryRecordInfo *)record
{
    m_currRecord = record;
    [m_recordList addObject:record];
    printf("😂😂😂😂insertNewRecord\n");
    [self saveRecordList];
}

- (void)updateRecord:(MemoryRecordInfo *)record
{
    for (int i = 0; i < m_recordList.count; ++i) {
        MemoryRecordInfo *tmpRecord = m_recordList[i];
        if (record.launchTime == tmpRecord.launchTime) {
            [m_recordList replaceObjectAtIndex:i withObject:record];
            printf("😂😂😂😂updateRecord record.launchTime:==tmpRecord.launchTime:%llu\n", tmpRecord.launchTime);
            [self saveRecordList];
            break;
        }
    }
}

- (void)deleteRecord:(MemoryRecordInfo *)record
{
    for (int i = 0; i < m_recordList.count; ++i) {
        MemoryRecordInfo *tmpRecord = m_recordList[i];
        if (record.launchTime == tmpRecord.launchTime) {
            [m_recordList removeObjectAtIndex:i];
            printf("😂😂😂😂deleteRecord record.launchTime == tmpRecord.launchTime\n");
            [self saveRecordList];
            NSString *eventPath = [record recordDataPath];
            [[NSFileManager defaultManager] removeItemAtPath:eventPath error:NULL];
            break;
        }
    }
}

- (void)deleteAllRecords
{
    for (int i = 0; i < m_recordList.count; ++i) {
        MemoryRecordInfo *record = m_recordList[i];
        NSString *eventPath = [record recordDataPath];
        [[NSFileManager defaultManager] removeItemAtPath:eventPath error:NULL];
    }

    [m_recordList removeAllObjects];
    printf("😂😂😂😂deleteAllRecords\n");
    [self saveRecordList];
}

- (void)loadRecordList
{
    @try {
        m_recordList = [NSKeyedUnarchiver unarchiveObjectWithFile:[self recordListPath]];
        if ([m_recordList isKindOfClass:[NSArray class]] == NO) {
            m_recordList = nil;
        } else {
            m_recordList = [[NSMutableArray alloc] initWithArray:m_recordList];
        }
    } @catch (NSException *exception) {
        MatrixError(@"loadRecordList fail, %@", exception);
    } @finally {
        if (m_recordList == nil) {
            m_recordList = [NSMutableArray array];
        }
    }

    // just limit 3 record
    if (m_recordList.count > 3) {
        while (m_recordList.count > 3) {
            MemoryRecordInfo *record = m_recordList[0];
            [m_recordList removeObjectAtIndex:0];
            NSString *eventPath = [record recordDataPath];
            [[NSFileManager defaultManager] removeItemAtPath:eventPath error:NULL];
        }
        printf("😂😂😂😂 WCMemoryRecordManager loadRecordList m_recordList.count > 3)\n");
        [self saveRecordList];
    }
}




- (void)saveRecordList
{
    @try {
        [NSKeyedArchiver archiveRootObject:m_recordList toFile:[self recordListPath]];
    } @catch (NSException *exception) {
        MatrixError(@"saveRecordList fail, %@", exception);
    }
}

- (NSString *)recordListPath
{
    NSString *pathComponent = @"RecordList.dat";
    NSString *path = [[MatrixPathUtil memoryStatPluginCachePath] stringByAppendingPathComponent:pathComponent];
    if (!_printTimes) {
        _printTimes = YES;
        printf("😂😂😂😂 recordListPath:%s \n", [path UTF8String]);
    }
    return path;
}

@end
