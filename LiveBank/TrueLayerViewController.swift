//
//  TrueLayerViewController.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/15/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import UIKit

protocol TrueLayerViewControllerDelegate: class {
    func truelayerViewController(_ viewController: TrueLayerViewController, error: Error?)
    func dismiss()
}

class TrueLayerViewController: UIViewController, UIWebViewDelegate {
    
    weak var delegate:TrueLayerViewControllerDelegate?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initModel()
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initModel() {
        
    }
    
    func initView() {
        webView.loadRequest(URLRequest(url: self.authLink()!))
    }
    
    func authLink() -> URL? {
        let authURL = TrueLayerString.AUTH_URL
        let clientID = TrueLayerClient.currentClientId()
        let scopes = TrueLayerString.SCOPES
        let redirectURI = TrueLayerClient.currentRedirectURI()
        
        return URL(string: "\(authURL)?response_type=code&client_id=\(clientID!)&nonce=2238757534&scope=\(scopes)&redirect_uri=\(redirectURI!)&enable_mock=true");
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if let delegate = self.delegate {
                delegate.dismiss()
            }
        })
    }
    
    // - UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.formSubmitted {
            
            let scheme = request.url!.scheme!
            let host = request.url!.host!
            let uri = scheme + "://" + host
            
            if uri == TrueLayerClient.currentRedirectURI() {
                // catch the code and redirect to appdelegate
                let code = request.url!.queryItems["code"]
                
                // dismiss dialog
                self.dismiss(animated: true, completion: {
                    TrueLayerClient.exchangeCode(code: code!, failure: { error in
                        if let d = self.delegate {
                            d.truelayerViewController(self, error:error)
                        }
                    }, success: {
                        if let d = self.delegate {
                            d.truelayerViewController(self, error:nil)
                        }
                    })
                })
                
                // no further actions
                return false
            }
        }
       
        return true;
    }
}
