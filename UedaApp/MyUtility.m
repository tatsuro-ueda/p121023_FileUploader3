//
//  MyUtility.m
//  cmpdir_test2
//
//  Created by stky on 2012/10/04.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import "MyUtility.h"
#import "StandardPaths.h"

@implementation MyUtility

+ (void)mkdir:(NSString *)dirName;
{
    NSString *path = [[NSFileManager defaultManager] pathForPrivateFile:dirName];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
}

+ (void)print:(NSString *)string withFilePath:(NSString *)filePath;
{
    NSError *error;
    [string writeToFile:[[NSFileManager defaultManager] pathForPrivateFile:filePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

+ (void)delete:(NSString *)path
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[[NSFileManager defaultManager] pathForPrivateFile:path] error:&error];
}

+ (NSArray *)list:(NSString *)path
{
    NSError *error;
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSFileManager defaultManager] pathForPrivateFile:path] error:&error];
}

+ (void)alertError:(NSString*)message
{
    // 「読込中」のアラートビューを表示する
    UIAlertView* infoAlertView = [[UIAlertView alloc] init];
    infoAlertView.title = [NSString stringWithFormat:@"エラー"];
    infoAlertView.message = message;
    infoAlertView.delegate = self;
    [infoAlertView addButtonWithTitle:@"了解"];
    [infoAlertView show];
}

+ (NSURL *)urlWithHost:(NSString *)host withPath:(NSString *)path withOption:(NSString *)option
{
    if (host == nil) {
        [[NSException exceptionWithName:@"Exception"
                                 reason:@"NSString* host is nil"
                               userInfo:nil]
         raise];
    }
    if (path == nil) {
        path = @"";
    }
    if (option == nil) {
        option = @"";
    }
    NSString* escaped_option = [option stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strUrl = [[host stringByAppendingString:path] stringByAppendingString:escaped_option];
    return [NSURL URLWithString:strUrl];
}

@end