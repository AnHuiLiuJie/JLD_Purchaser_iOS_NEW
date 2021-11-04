//
//  GLPGoodsDetailsWebCell.m
//  DCProject
//
//  Created by bigbing on 2020/3/12.
//  Copyright © 2020 bigbing. All rights reserved.
//

#import "GLPGoodsDetailsWebCell.h"
#import <YBImageBrowser/YBImageBrowser.h>
//#import "YBImage.h"
@interface GLPGoodsDetailsWebCell ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, assign) CGFloat viewHeight; // 富文本高度
@property (nonatomic,strong) NSArray *imageUrlArr;
//@property (nonatomic, strong) WKWebView *webView;
//@property (nonatomic,strong) YBImageBrowser *brow;

@end

@implementation GLPGoodsDetailsWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];
    
    
    _viewHeight = 0;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController* userContentController = [[WKUserContentController alloc] init];
    configuration.userContentController = userContentController;
    [configuration.userContentController addScriptMessageHandler:self name:@"appGoodDetailImages"];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(15, 10, kScreenW - 30, 0.01) configuration:configuration];
    // _webView.userInteractionEnabled = NO;
    _webView.scrollView.bounces = NO;
    _webView.navigationDelegate = self;
    [self.contentView addSubview:_webView];
    
    //    [_webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //    [self updateMasonry];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if (self) {
        
    }else{
        return;
    }
    if ([message.name isEqualToString:@"appGoodDetailImages"]) {
        [self appGoodDetailImages:message.body];
        
        
    }
}

- (void)appGoodDetailImages:(NSString *)body{
    
}
#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self addImgClickJS];
    //    NSLog(@"加载完成");
    //    WEAKSELF
    //
    //    CGFloat lastHeight = self.webView.scrollView.contentSize.height;
    //
    //     NSLog(@"1111 --- %.2f",lastHeight);
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if (self.viewHeight == 0) {
    //            if (weakSelf.reloadBlock) {
    //                weakSelf.reloadBlock();
    //            }
    //
    //            self.viewHeight = lastHeight;
    //        }
    //
    //        [self updateMasonry];
    //    });
    
}

- (void)addImgClickJS {
    //获取所以的图片标签
    [self.webView evaluateJavaScript:@"function getImages(){\
     var imgs = document.getElementsByTagName('img');\
     var imgScr = '';\
     for(var i=0;i<imgs.length;i++){\
     if (i == 0){ \
     imgScr = imgs[i].src; \
     } else {\
     imgScr = imgScr +'***'+ imgs[i].src;\
     } \
     };\
     return imgScr;\
     };" completionHandler:nil];//注入js方法
    
    __weak typeof(self)weakSelf = self;
    [self.webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError *_Nullable error) {
        
        if (!error) {
            
            NSMutableArray *urlArray = result?[NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"***"]]:nil;
            NSLog(@"urlArray = %@",urlArray);
            weakSelf.imageUrlArr = urlArray;
            
            
        } else {
            weakSelf.imageUrlArr = nil;
        }
        
    }];
    
    //添加图片点击的回调
    [self.webView evaluateJavaScript:@"function registerImageClickAction(){\
     var imgs = document.getElementsByTagName('img');\
     for(var i=0;i<imgs.length;i++){\
     imgs[i].customIndex = i;\
     imgs[i].onclick=function(){\
     window.location.href='image-preview-index:'+this.customIndex;\
     }\
     }\
     }" completionHandler:nil];
    [self.webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 类似 UI 的 -webView: shouldStartLoadWithRequest: navigationType:
    //预览图片
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:@"image-preview-index"]) {
        //图片点击回调
        NSInteger index = [[url.absoluteString substringFromIndex:[@"image-preview-index:" length]] integerValue];
        //        NSString *imgPath = self.imageUrlArr.count > index?self.imageUrlArr[index]:nil;
        //        NSLog(@"imgPath = %@",imgPath);
        [self show:index];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)show:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSString *url  in _imageUrlArr) {
        YBIBImageData *data0 = [YBIBImageData new];
        data0.imageURL = [NSURL URLWithString:url];
        [arr addObject:data0];
    }
    YBImageBrowser*  _brow = [YBImageBrowser new];
//    _brow.outTransitionType = 0;
//    _brow.enterTransitionType = 0;
    _brow.dataSourceArray = arr;
    _brow.currentPage = index;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    _brow.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [_brow show];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //
    //    WEAKSELF;
    //    if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            UIScrollView *scrollView = self.webView.scrollView;
    //            CGSize size = CGSizeMake(kScreenW - 30, scrollView.contentSize.height);
    //
    //            NSLog(@"111 - size - %@",NSStringFromCGSize(size));
    //
    //            if (size.height > weakSelf.viewHeight) {
    //                weakSelf.viewHeight = size.height;
    //                [weakSelf updateMasonry];
    //
    ////                if (weakSelf.contentView.frame.size.height < self.viewHeight) {
    ////                    if (weakSelf.reloadBlock) {
    ////                        weakSelf.reloadBlock();
    ////                    }
    ////                }
    //            }
    //        });
    //    }
}




#pragma mark - action
- (void)updateMasonry {
    
    //     [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //           make.top.equalTo(self.contentView.mas_top).offset(10);
    //           make.left.offset(15);
    //           make.right.offset(-15);
    //           make.height.offset(self.viewHeight);
    //           make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    //      }];
    //
    //    _webView.frame = CGRectMake(15, 10, kScreenW - 30, self.viewHeight);
}





#pragma mark - setter
- (void)dc_setValueWithModel:(GLPGoodsDetailModel *)detailModel selctButton:(NSString *)selctButton viewHeight:(CGFloat)viewHeight
{
    if ([selctButton isEqualToString:@"600"]) {
        
        self.webView.frame = CGRectMake(15, 0, kScreenW - 30, viewHeight);
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.height.equalTo(viewHeight);
        }];
        
        _bgView.hidden = NO;
        _webView.hidden = NO;
        NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                           "<head> \n"
                           "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                           "<meta name=\"format-detection\" content=\"telephone=no\" /> \n"
                           "<style type=\"text/css\"> \n"
                           "body {font-size:14px;}\n"
                           "</style> \n"
                           "</head> \n"
                           "<body>%@"
                           "<script type='text/javascript'>"
                           "window.onload = function(){\n"
                           "var $img = document.getElementsByTagName('img');\n"
                           "for(var p in  $img){\n"
                           " $img[p].style.width = '100%%';\n"
                           "$img[p].style.height ='auto'\n"
                           "}\n"
                           "}"
                           "</script>"
                           "</body>"
                           "</html>",detailModel.goodsDesc];
        [_webView loadHTMLString:htmls baseURL:nil];
        
    } else {
        
        
        _webView.hidden = YES;
        _bgView.hidden = YES;
        _webView.frame = CGRectMake(15, 0, kScreenW - 30, 0);
        [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.height.equalTo(0);
        }];
    }
}

- (void)dealloc {

    [self.webView stopLoading];
    self.webView.navigationDelegate = nil;
    //    [_webView removeObserver:self forKeyPath:@"scrollView.contentSize" context:nil];
}


@end
