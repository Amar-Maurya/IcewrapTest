//
//  AppCoordinator.swift
//  Icewrap Test
//


import Foundation
import UIKit

protocol AppFlow {
    func showLogin()
    func showChannelList(viewModel: ChannelListViewModel)
}

class AppCoordinator: AppFlow {
    static let shared = AppCoordinator()
    
    var window: UIWindow? {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            return sceneDelegate.window
        }
        return UIWindow()
    }
    
    
    func showLogin() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController.instantiateFromStoryboard()
            loginVC.viewModel = LoginViewModel(delegate: loginVC)
            let navigationController = UINavigationController(rootViewController: loginVC)
            navigationController.navigationBar.tintColor = .black
            navigationController.navigationBar.backgroundColor = .clear
            navigationController.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
    }

    func showChannelList(viewModel: ChannelListViewModel) {
        DispatchQueue.main.async {
            if !(self.window?.rootViewController is UINavigationController) {
                let loginVC = LoginViewController.instantiateFromStoryboard()
                loginVC.viewModel = LoginViewModel(delegate: loginVC)
                let navigationController = UINavigationController(rootViewController: loginVC)
                navigationController.navigationBar.tintColor = .black
                navigationController.navigationBar.backgroundColor = .clear
                navigationController.setNavigationBarHidden(true, animated: false)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                let channelListVC = ChannelListViewController.instantiateFromStoryboard()
                navigationController.setNavigationBarHidden(false, animated: false)
                channelListVC.viewModel = viewModel
                navigationController.pushViewController(channelListVC, animated: true)
            }
        }
    }
}

