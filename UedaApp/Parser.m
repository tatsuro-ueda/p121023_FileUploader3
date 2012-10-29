//
//  Parser.m
//  UedaApp
//
//  Created by stky on 2012/10/24.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import "Parser.h"

@implementation Parser

- (BOOL)parseContentsOfURL:(NSURL *)url
{
    // XMLパーサーの準備
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    
    array = [NSMutableArray array];
    if ([parser parse]) {
        self.match = [array objectAtIndex:0];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqualToString:@"Image"]) {
        NSString *keywords = [attributeDict valueForKey:@"keywords"];
        [array addObject:keywords];
#ifdef TEST
        NSLog(@"%@", keywords);
#endif
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
}

- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError {
}
@end
