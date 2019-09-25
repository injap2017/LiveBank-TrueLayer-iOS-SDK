//
//  LoginViewController.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/12/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, TrueLayerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func login(_ sender: Any) {
        // setup truelayer client SDK and try to login if succeeded then go choose accounts
        TrueLayerClient.install(withId: "livebank-1f5v", Secret: "fa8sb938vcaadz78eu23ju", RedirectURI: "livebank://truelayer")

        let baseController = self.topViewController()!
        let viewController = TruelayerClientUI.TrueLayerViewController()!
        
        viewController.delegate = self
        
        let navigationController = UINavigationController.init(rootViewController: viewController)
        baseController.present(navigationController, animated: true, completion: {
            
        })
        
    }
    
    // - Accesscory functions
    private func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    private func truelayerViewController() -> TrueLayerViewController? {
        let storyboard = UIStoryboard(name: "TrueLayerStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "truelayer") as? TrueLayerViewController
    }
    
    // - TrueLayerViewControllerDelegate
    func truelayerViewController(_ viewController: TrueLayerViewController, error: Error?) {
        if let e = error {
            print(e);
        }
        else {
            self.performSegue(withIdentifier: "accounts", sender: self)
        }
    }
    
    func dismiss() {
        
    }
}
