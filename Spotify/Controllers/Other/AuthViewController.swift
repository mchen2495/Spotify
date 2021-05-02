//
//  AuthViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    //webview for spotify sign in page
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    //use to tell welcomeController that user has successfully signed in or not (Auth set up)
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        //for when the webview is finish loading and re directs
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        //create webview for spotify sign in page
        webView.load(URLRequest(url: url))
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //make the frame of the webView the same size as the bounds of its parent (view)
        webView.frame = view.bounds
    }
    
    
    //MARK: WKNavigationDelegate method
    //After you move from signin screen to redirect url screen
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        /*
         //Exchange the code in redirect url link for access token
         https://www.google.com/?code=AQBZChSEsZL4q91E2JFy9Fpq24Ic2OdjUaM8xPdIOUFjOsR1e6ykkNT7ZbUVnYMn0upKxUiQLe2foFzKTJAea88zIbQgaJCWrUTXBFD-ppMBGIkprHq9sN5VcsHjx8c2Yy12lubsVwhrCb9tsiqLuCYmEwvdc_joXwNbsIk8hrgvYj-5w6C_PjdA4Dr-6Q
         */
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        
        print("Code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            
            DispatchQueue.main.async {
                //pop all other view controller off the stack and back to rootView ontroller
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
        
    }

}
