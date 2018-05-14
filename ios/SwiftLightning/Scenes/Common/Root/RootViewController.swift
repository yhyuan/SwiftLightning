//
//  RootViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-20.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RootDisplayLogic: class {
  func displaySetupScenes()
  func displayUnlockScenes()
  func displayErrorStatus(viewModel: Root.WalletPresenceRouting.ViewModel)
  
  func displayWalletNavigation()
  func displayConfirmWalletUnlockFailure(viewModel: Root.ConfirmWalletUnlock.ViewModel)
}


class RootViewController: UIViewController, RootDisplayLogic {
  
  var interactor: RootBusinessLogic?
  var router: (NSObjectProtocol & RootRoutingLogic & RootDataPassing)?

  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = RootInteractor()
    let presenter = RootPresenter()
    let router = RootRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  
  // MARK: View lifecycle
  
  @IBOutlet weak var logoImageView: SLLogoView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let request = Root.WalletPresenceRouting.Request()
    interactor?.checkWalletPresence(request: request)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    logoImageView.animationDuration = TimeInterval(2.0)
    logoImageView.pushAnimate()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    logoImageView.popAnimate()
  }
  
  
  // MARK: Route based on Wallet Presence
  
  func displaySetupScenes() {
    DispatchQueue.main.async {
      self.router?.routeToCreateRecover()
    }
  }
  
  func displayUnlockScenes() {
    DispatchQueue.main.async {
      self.router?.routeToUnlockApp()
    }
  }
  
  func displayErrorStatus(viewModel: Root.WalletPresenceRouting.ViewModel) {
    let alertDialog = UIAlertController(title: viewModel.errorTitle,
                                        message: viewModel.errorMsg,
                                        preferredStyle: .alert).addAction(title: "OK", style: .default)
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
    }
  }
  
  
  // MARK: Confirm Wallet is Unlocked before proceeding to Wallet Navigation
  
  func goWalletNavigation() {
    // We gotta confirm that the wallet is indeed unlocked before proceeding
    let request = Root.ConfirmWalletUnlock.Request()
    interactor?.confirmWalletUnlock(request: request)
  }
  
  func displayWalletNavigation() {
    DispatchQueue.main.async {
      self.router?.routeToWalletNavigation()
    }
  }
  
  func displayConfirmWalletUnlockFailure(viewModel: Root.ConfirmWalletUnlock.ViewModel) {
    let alertDialog = UIAlertController(title: viewModel.errTitle, message: viewModel.errMsg, preferredStyle: .alert).addAction(title: "OK", style: .default)
    
    DispatchQueue.main.async {
      self.present(alertDialog, animated: true, completion: nil)
    }
  }
}
