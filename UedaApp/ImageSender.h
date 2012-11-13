//
//  Sender.h
//  FileUploader
//
//  Created by stky on 2012/10/15.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ImageSender : AFHTTPClient<NSURLConnectionDataDelegate, NSURLConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableData       *buffer;
    UIAlertView*        _infoAlertView;
}

@property NSString *html;
@property NSString *error;
@property NSArray* trustedHosts;
@property NSString* targetHost;

- (id)initWithStrUrl:(NSString *)strUrl;
- (void)getHtmlWithPath:(NSString*)path withOption:(NSString*)option;
- (void)upload:(UIImage *)image withName:(NSString *)name withPath:(NSString*)path withMimeType:(NSString*)mimeType;

+ (ImageSender *)sharedClient:(NSURL*)url;
- (void)getHtmlWithHost:(NSString*)host withPath:(NSString *)path;

@end
