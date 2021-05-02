//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Michael Chen on 2/22/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "welcome_background")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let logoImageView: UIImageView = {
       let imageview = UIImageView(image: UIImage(named: "logo"))
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\n of songs on\n the go"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        //setting up IBAction for button
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(logoImageView)
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
        //setting the constraints for the button
        //x:how far from the right and left, y: how are from top, -50 bring it up 50 from bottum
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width - 40,
                                    height: 50)
        logoImageView.frame = CGRect(x: (view.width-120)/2, y: (view.height-350)/2, width: 120, height: 120)
        label.frame = CGRect(x: 30, y: logoImageView.bottum+30, width: view.width-60, height: 150)
    }
    
    ///when the sign in button is tapped
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        //push AuthViewController on to the navigationController stack
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func handleSignIn(success: Bool){
        //Log user in or alert them of error
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTapBarVC = TabBarViewController()
        //this view will be full screen so user can't swipe it away
        mainAppTapBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTapBarVC, animated: true)
    }

}
