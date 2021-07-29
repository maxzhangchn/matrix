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

#import "MatrixHandler.h"
// #import <UIKit/UIKit.h>
// #import "AppDelegate.h"
// #import "TextViewController.h"


@interface MatrixHandler () <MatrixPluginListenerDelegate>
{
    WCMemoryStatPlugin *m_msPlugin;
}

@end

@implementation MatrixHandler

+ (MatrixHandler *)sharedInstance
{
    static MatrixHandler *g_handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_handler = [[MatrixHandler alloc] init];
    });
    
    return g_handler;
}

- (void)installMatrix
{
    Matrix *matrix = [Matrix sharedInstance];

    MatrixBuilder *curBuilder = [[MatrixBuilder alloc] init];
    curBuilder.pluginListener = self;
    
    printf("😂😂😂😂MatrixHandler installMatrix _init_WCMemoryStatPlugin\n");
    WCMemoryStatPlugin *memoryStatPlugin = [[WCMemoryStatPlugin alloc] init];
    memoryStatPlugin.pluginConfig = [WCMemoryStatConfig defaultConfiguration];
    [curBuilder addPlugin:memoryStatPlugin];
    
    [matrix addMatrixBuilder:curBuilder];
    
    printf("😂😂😂😂MatrixHandler installMatrix\n");
    [memoryStatPlugin start];
    m_msPlugin = memoryStatPlugin;
}


- (WCMemoryStatPlugin *)getMemoryStatPlugin
{
    return m_msPlugin;
}

// ============================================================================
#pragma mark - MatrixPluginListenerDelegate
// ============================================================================

- (void)onReportIssue:(MatrixIssue *)issue
{
    printf("😂😂😂😂onReportIssue\n");
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // TextViewController *textVC = nil;
    
    NSString *currentTilte = @"unknown";
    if ([issue.issueTag isEqualToString:[WCMemoryStatPlugin getTag]]) {
        currentTilte = @"OOM Info";
    }
    
    // if (issue.dataType == EMatrixIssueDataType_Data) {
    //     NSString *dataString = [[NSString alloc] initWithData:issue.issueData encoding:NSUTF8StringEncoding];
    //     textVC = [[TextViewController alloc] initWithString:dataString withTitle:currentTilte];
    // } else {
    //     textVC = [[TextViewController alloc] initWithFilePath:issue.filePath withTitle:currentTilte];
    // }
    // [appDelegate.navigationController pushViewController:textVC animated:YES];
    printf("😂😂😂😂navigationController pushViewController\n");
    
    [[Matrix sharedInstance] reportIssueComplete:issue success:YES];
}


@end
