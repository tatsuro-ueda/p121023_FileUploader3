//
//  GetHtmlTestCase.m
//  FileUploader
//
//  Created by stky on 2012/10/15.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import "SenderTestCase.h"
#import "ImageSender.h"
#import "Parser.h"
#import "ViewController.h"
#import "MyUtility.h"

#define TEST

@implementation SenderTestCase

- (void)setUpClass
{
    sender = [[ImageSender alloc] initWithStrUrl:@"https://180.43.2.112"];
    sender.trustedHosts = @[@"180.43.2.112"];
    parser = [[Parser alloc] init];
    vc = [[ViewController alloc] init];
}

- (void)testGetHtml
{
    [self prepare];
    [sender getHtmlWithPath:@"/piXserve/service/login.jsp" withOption:@"?username=admin&password="];
    [self performSelector:@selector(_succeedGetHtml) withObject:nil afterDelay:3.0];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:4.0];
}

- (void)_succeedGetHtml
{
    if (sender.html != nil) {
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testGetHtml)];
        [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testSearch)];
    };
}

- (void)testUploadWithFiexedFilename
{
    [sender upload:[UIImage imageNamed:@"test2.jpg"] withName:@"test2.jpg" withPath:@"/piXserve/service/uploadimage.jsp" withMimeType:@"image/jpg"];
}

- (void)testUploadWithVariableFilename
{
    NSString *filename = [[vc getStrftime] stringByAppendingString:@".jpg"];
    [sender upload:[UIImage imageNamed:@"test2.jpg"] withName:filename withPath:@"/piXserve/service/uploadimage.jsp" withMimeType:@"image/jpg"];
}

//- (void)testUploadExceptionFileNotFound
//{
//    [sender upload:nil withName:@"test2.jpg"];
//    NSLog(@"%@", sender.error);
//}

//- (void)testSearch
//{
//    [self prepare];
//    NSURL *url = [sender urlWithHostAndPath:@"https://180.43.2.112/piXserve/service/search.jsp" withOption:@"?db=D:\\piXlogic\\repository\\piXserve-dir\\piXserve\\2008\\piXserve-2008.war\\database\\FLOWER_im.xml&search_type=image&image=D:\\piXlogic\\repository\\piXserve-dir\\piXserve\\2008\\piXserve-2008.war\\upload\\test.jpg"];
//    [sender getHtml:url];
//    [self performSelector:@selector(_succeedGetHtml) withObject:nil afterDelay:10.0];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:11.0];
//}

- (void)testParse
{
    NSString *option = [@"?db=D:\\piXlogic\\repository\\piXserve-dir\\piXserve\\2008\\piXserve-2008.war\\database\\FLOWER_im.xml&search_type=image&image=D:\\piXlogic\\repository\\piXserve-dir\\piXserve\\2008\\piXserve-2008.war\\upload\\" stringByAppendingString:@"test.jpg"];
    NSURL *url = [MyUtility urlWithHost:@"https://180.43.2.112" withPath:@"/piXserve/service/search.jsp"  withOption:option];
#ifdef TEST
    NSLog(@"%@", url);
#endif
    if ([parser parseContentsOfURL:url]) {
        NSLog(@"%@", parser.match);
    }
}

- (void)testGetUrlFromKeyword
{
    NSString *expected = @"http://ja.wikipedia.org/wiki/%E3%81%82%E3%81%98%E3%81%95%E3%81%84";
    NSURL *url = [vc getUrlFromKeyword:@"あじさい"];
    NSString *actual = [NSString stringWithFormat:@"%@", url];
    GHAssertEqualObjects(expected, actual, nil);
}

- (void)testGetStrftime
{
    NSString *s = [vc getStrftime];
    NSLog(@"%@", s);
    GHAssertNotNil(s, nil);
}

//- (void)testPutImageWithAnimation
//{
//    [vc putImageAt:(UIImageView*)withImage:(UIImage)];
//}
@end
