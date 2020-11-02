//
//  UIViewController+Extention.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import UIKit

extension UIViewController{
    static private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    /// Presents an error dialog of the current view.
    /// -Parameters:
    ///   error: Error to be presented to the user.
    ///   retryCompletion: A closure to be executed when the user click on the retry button.
    func showError(error:MDError, retryCompletion:@escaping (()->Void)){
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let retry = UIAlertAction(title: "Retry", style: .default) { (_) in
            retryCompletion()
        }
        alert.addAction(ok)
        alert.addAction(retry)
        present(alert, animated: true, completion: nil)
    }
    
    /// Presents an error dialog of the current view.
    /// -Parameter: error: Error to be presented to the user.
    func showDialog(error:MDError){
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    /// Starts showing an activity indicator view.
    func startLoadingAnimation(){
        UIViewController.activityIndicator.startAnimating()
        view.addSubview(UIViewController.activityIndicator)
        UIViewController.activityIndicator.color = .red
        UIViewController.activityIndicator.center = view.center
        
    }
    
    /// Stops showing an activity indicator view.
    func stopLoadingAnimation(){
        UIViewController.activityIndicator.stopAnimating()
        UIViewController.activityIndicator.removeFromSuperview()
    }
}
