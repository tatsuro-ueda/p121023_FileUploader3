//
//  ViewController.h
//  FileUploader
//
//  Created by stky on 2012/10/12.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ImageSender, Parser;

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
    UIPopoverController     *_imagePopController;
    ImageSender                  *imageSender;
    Parser                  *parser;
    UIAlertView             *_infoAlertView;
    NSTimer                 *_timerIncrease;
    NSDateFormatter         *formatter;
    NSString                *_filename;
    NSOperationQueue        *_queue;
    UIImage                 *_image;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIImage *holdingImage;

- (IBAction)selectImage:(id)sender;
- (NSURL *)getUrlFromKeyword:(NSString *)keyword;
- (IBAction)searchDb:(id)sender;
- (NSString *)getStrftime;
- (void)fadeImageViewOpacityFromZeroToOne:(UIImageView*)putImageView;

@end
