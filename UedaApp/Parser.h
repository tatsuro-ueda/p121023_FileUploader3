//
//  Parser.h
//  UedaApp
//
//  Created by stky on 2012/10/24.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject<NSXMLParserDelegate>
{
    NSMutableArray          *array;
}

@property NSString *match;

- (BOOL)parseContentsOfURL:(NSURL *)url;

@end
