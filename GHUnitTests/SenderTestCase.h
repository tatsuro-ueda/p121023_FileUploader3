//
//  GetHtmlTestCase.h
//  FileUploader
//
//  Created by stky on 2012/10/15.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
@class ImageSender, MyClient, Parser, ViewController;

@interface SenderTestCase : GHAsyncTestCase
{
    ImageSender     *sender;
    MyClient        *myClient;
    Parser          *parser;
    ViewController  *vc;
}

@end
