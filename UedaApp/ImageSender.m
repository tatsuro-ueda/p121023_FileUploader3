//
//  Sender.m
//  FileUploader
//
//  Created by stky on 2012/10/15.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import "ImageSender.h"
#import "NSString+URLEncode.h"
#import "NSString+Encode.h"
#import "MyUtility.h"

@implementation ImageSender

- (id)initWithStrUrl:(NSString *)strUrl
{
    self = [super init];
    if (self) {
        // 初期化
        _targetHost = strUrl;
    }
    return self;
}

/*
 * よくわからない：ここから
 */

+ (ImageSender *)sharedClient:(NSURL*)url
{
    static ImageSender *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:url];
    });
    return _sharedClient;
}

- (void)getHtmlWithHost:(NSString *)host withPath:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:host];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [[ImageSender sharedClient:url] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

/*
 * よくわからない：ここまで
 */

- (void)getHtmlWithPath:(NSString*)path withOption:(NSString*)option
{
    NSURL* url = [MyUtility urlWithHost:_targetHost withPath:path withOption:option];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn) {
        buffer = [NSMutableData data];
    } else {
        _error = @"サーバに接続できません。ネットワークの環境をご確認ください。";
        [MyUtility alertError:_error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [buffer appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", response);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        // 信頼するホストならば・・・
        if ([_trustedHosts containsObject:challenge.protectionSpace.host])
            // 信頼する
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _html = [NSString encodedStringWithData:buffer];
    //    _html = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    NSLog(@"Succeed!! Received %d bytes of data", [buffer length]);
    NSLog(@"%@", _html);

    // 通知を作成する
    NSString *searchDb1 = [NSString stringWithFormat:@"searchDb1"];
    NSNotification *n = [NSNotification notificationWithName:searchDb1 object:self];
    
    // 通知実行！
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    _error = @"サーバに接続できません。ネットワークの環境をご確認ください。\n\n";
//    _error = [_error stringByAppendingString:error.debugDescription];
    
    
    _infoAlertView = [[UIAlertView alloc] init];
    _infoAlertView.title = [NSString stringWithFormat:@"エラー"];
    _infoAlertView.message = @"サーバに接続できません。ネットワークの環境をご確認ください。";
    [_infoAlertView addButtonWithTitle:@"詳細"];
    [_infoAlertView addButtonWithTitle:@"了解"];
    _infoAlertView.delegate = self;
    [_infoAlertView show];
    
    _error = error;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            // アラートを消す
            [_infoAlertView dismissWithClickedButtonIndex:0 animated:YES];
            break;
            
        default:
            [_infoAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [MyUtility alertError:_error.debugDescription];
            break;
    }
}

- (void)upload:(UIImage *)image withName:(NSString *)name withPath:(NSString*)path withMimeType:(NSString *)mimeType
{
    // 引数のnilチェック
    if ([image isEqual:nil]) {
        _error = @"内部エラー：アップロードする画像のデータがありません";
        [MyUtility alertError:_error];
        return;
    }
    if ([name isEqual:nil]) {
        _error = @"内部エラー：アップロードするファイルにつける名前がありません";
        [MyUtility alertError:_error];
        return;
    }

    NSURL* url = [MyUtility urlWithHost:_targetHost withPath:path withOption:nil];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:imageData name:@"filename" fileName:name mimeType:mimeType];
    }];
    
    NSLog(@"%@", request);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation start];
}

@end
