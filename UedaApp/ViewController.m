//
//  ViewController.m
//  FileUploader
//
//  Created by stky on 2012/10/12.
//  Copyright (c) 2012年 stky. All rights reserved.
//

#import "ViewController.h"
#import "ImageSender.h"
#import "Parser.h"
#import "MyUtility.h"

static const float UPLOAD_SEC = 5.0;
static const float SEARCH_SEC = 5.0;
static const float SHOW_SEC = 5.0;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectImage:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad
        _imagePopController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [_imagePopController presentPopoverFromBarButtonItem:sender
                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                    animated:YES];
    }
    else {
        // それ以外
        [self presentViewController:imagePicker animated:YES completion:nil];
        // モーダルビューとしてカメラ画面を呼び出す
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // ユーザーの選択した写真を取得し、imageViewというUIImageView型のフィールドのイメージに設定する
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageView.image = image;
    [self fadeImageViewOpacityFromZeroToOne:_imageView];
    
    // UIPopoverControllerを閉じる
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad
        [_imagePopController dismissPopoverAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSURL *)getUrlFromKeyword:(NSString *)keyword
{
    NSDictionary *db = @{
//    @"あじさい":@"http://ja.wikipedia.org/wiki/%E3%81%82%E3%81%98%E3%81%95%E3%81%84",
    @"あじさい":@"https://www.google.co.jp/search?q=%E3%81%82%E3%81%98%E3%81%95%E3%81%84&tbm=isch",
    @"アナベル":@"http://www.shuminoengei.jp/m-pc/a-page_p_detail/target_plant_code-19",
    @"アルストロメリア":@"http://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%AB%E3%82%B9%E3%83%88%E3%83%AD%E3%83%A1%E3%83%AA%E3%82%A2",
    @"イブリンランディグ":@"http://www.b-net.kcv.jp/~miyagawa/tropical/e%20randig.html",
    @"カカオ":@"http://ja.wikipedia.org/wiki/%E3%82%AB%E3%82%AB%E3%82%AA",
    @"ぎぼうし":@"http://yasashi.info/ki_00002.htm",
    @"すいれんピンク":@"http://www.jtw.zaq.ne.jp/tanakun/watch2/suiren.htm",
    @"すいれん黄色":@"http://www.jtw.zaq.ne.jp/tanakun/watch2/suiren.htm",
    @"セントルイスゴールド":@"http://members.jcom.home.ne.jp/takanuma/zukan/stg.htm",
    @"ダチュラコルゲニア":@"http://www.geocities.co.jp/NatureLand/2943/datura.htm",
    @"はな菖蒲":@"http://ja.wikipedia.org/wiki/%E3%83%8F%E3%83%8A%E3%82%B7%E3%83%A7%E3%82%A6%E3%83%96",
    @"ばらオレンジ":@"http://ja.wikipedia.org/wiki/%E3%83%90%E3%83%A9",
    @"ばら赤":@"http://www.muratabaraen.jp/",
    @"ばら赤ふち":@"http://www.barakai.com/",
    @"ヒスイカズラ":@"http://aoki2.si.gunma-u.ac.jp/BotanicalGarden/HTMLs/hisuikazura.html",
    @"フェチタス":@"http://www.shuminoengei.jp/m-pc/a-page_p_detail/target_plant_code-41",
    @"フォーゲリアナ":@"http://www.weblio.jp/content/%E3%83%84%E3%83%B3%E3%83%99%E3%83%AB%E3%82%AE%E3%82%A2%E3%83%BB%E3%83%95%E3%82%A9%E3%83%BC%E3%82%B2%E3%83%AA%E3%82%A2%E3%83%8A",
    @"ベコニア黄色":@"http://image.search.yahoo.co.jp/search?rkf=2&ei=UTF-8&p=%E3%83%99%E3%82%B4%E3%83%8B%E3%82%A2",
    @"ベコニア赤ふち":@"http://image.search.yahoo.co.jp/search?rkf=2&ei=UTF-8&p=%E3%83%99%E3%82%B4%E3%83%8B%E3%82%A2",
    @"ポエルマニー":@"http://www.engeinavi.jp/db/view/link/366.html",
    @"ホワイトパール":@"http://www.b-net.kcv.jp/~miyagawa/tropical/wpearl.html",
    @"マーガレットランディグ":@"http://ganref.jp/m/roka_photo/portfolios/photo_detail/47f4cdc5019fa164b479b3865ca8732f",
    @"マグニフィカ":@"http://4travel.jp/domestic/area/toukai/aichi/nagoya/travelogue/10365931/",
    @"胡蝶蘭":@"http://www.kochoransodatekata.com/",
    @"黒姫":@"http://iwasaki.shop-pro.jp/?pid=32096431",
    @"日日そう":@"http://yasashi.info/ni_00003.htm"};
    
    return [NSURL URLWithString:db[keyword]];
}

- (IBAction)searchDb:(id)sender {
    // 画像を一時フォルダに保存
    // jpgで決めうち
    
    imageSender = [[ImageSender alloc] initWithStrUrl:@"https://180.43.2.112"];
    imageSender.trustedHosts = @[@"180.43.2.112"];

    // サーバにログイン
    [imageSender getHtmlWithPath:@"/piXserve/service/login.jsp" withOption:@"?username=admin&password="];

    // 「読込中」のアラートビューを表示する
    _infoAlertView = [[UIAlertView alloc] init];
    _infoAlertView.title = [NSString stringWithFormat:@"情報"];
    _infoAlertView.message = @"画像をアップロードしています";
    _infoAlertView.delegate = self;
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ai.frame = CGRectMake(30.0f, 50.0f, 225.0f, 90.0f);
    [_infoAlertView addSubview:ai];
    [_infoAlertView show];
    [ai startAnimating];
    
    [self performSelector:@selector(searchDb1) withObject:nil afterDelay:3.0];
}

- (void)searchDb1
{
    // 画像をサーバにアップロード
    _filename = [[self getStrftime] stringByAppendingString:@".jpg"];
    NSLog(@"%@", _filename);
    [imageSender upload:self.imageView.image withName:_filename withPath:@"/piXserve/service/uploadimage.jsp" withMimeType:@"image/jpg"];

    [self performSelector:@selector(searchDb2) withObject:nil afterDelay:UPLOAD_SEC];
}

- (void)searchDb2
{
    // アラートを消す
    [_infoAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    _infoAlertView = [[UIAlertView alloc] init];
    _infoAlertView.title = [NSString stringWithFormat:@"情報"];
    _infoAlertView.message = @"画像を画像検索しています";
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ai.frame = CGRectMake(30.0f, 50.0f, 225.0f, 90.0f);
    [_infoAlertView addSubview:ai];
    [_infoAlertView show];
    [ai startAnimating];
    _infoAlertView.delegate = self;

    parser = [[Parser alloc] init];
    NSString *option = [@"?db=D:\\piXlogic\\repository\\piXserve-dir\\piXserve\\2008\\piXserve-2008.war\\database\\FLOWER_im.xml&search_type=image&image=D:\\piXlogic\\repository\\piXserve-dir\\piXserve\\2008\\piXserve-2008.war\\upload\\" stringByAppendingString:_filename];
//    NSURL *url2 = [imageSender urlWithHostAndPath:@"https://180.43.2.112/piXserve/service/search.jsp"  withOption:option];
    NSURL *url2 = [MyUtility urlWithHost:@"https://180.43.2.112" withPath:@"/piXserve/service/search.jsp" withOption:option];
    if ([parser parseContentsOfURL:url2]) {
        NSLog(@"%@", parser.match);
    }

    [self performSelector:@selector(searchDb3) withObject:nil afterDelay:SEARCH_SEC];
}

- (void)searchDb3
{
    // アラートを消す
    [_infoAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    _infoAlertView = [[UIAlertView alloc] init];
    _infoAlertView.title = [NSString stringWithFormat:@"情報"];
    _infoAlertView.message = [NSString stringWithFormat:@"これは\n\n「%@」\n\nの画像です。\n\nインターネットで\n他の画像を検索します。", parser.match];
    [_infoAlertView show];
    _infoAlertView.delegate = self;

    [self performSelector:@selector(searchDb4) withObject:nil afterDelay:SHOW_SEC];
}

- (void)searchDb4
{
    [_infoAlertView dismissWithClickedButtonIndex:0 animated:YES];

    // キーワードをURLに変換する
    NSURL *url3 = [self getUrlFromKeyword:parser.match];
    
    // URLを表示する
    [[UIApplication sharedApplication] openURL:url3];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSString *)getStrftime
{
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HHmmss"];
    
    return [formatter stringFromDate:[NSDate date]];
}

- (void)fadeImageViewOpacityFromZeroToOne:(UIImageView*)putImageView
{
    // アニメーション
    CABasicAnimation* animeFlash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animeFlash.duration = 0.7;
    animeFlash.fromValue = [NSNumber numberWithFloat:0.0];
    animeFlash.toValue = [NSNumber numberWithFloat:1.0];
    
    putImageView.layer.opacity = 0.0;
    [putImageView.layer addAnimation:animeFlash forKey:@"animetePosition"];
    putImageView.layer.opacity = 1.0;
}

@end
