//
//  MnemonicExplainViewController.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-18.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SafariServices

protocol MnemonicExplainDisplayLogic: class {
  // func displaySomething(viewModel: MnemonicExplain.Something.ViewModel)
}


class MnemonicExplainViewController: UIViewController, MnemonicExplainDisplayLogic {
  var interactor: MnemonicExplainBusinessLogic?
  var router: (NSObjectProtocol & MnemonicExplainRoutingLogic & MnemonicExplainDataPassing)?

  
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
    let interactor = MnemonicExplainInteractor()
    let presenter = MnemonicExplainPresenter()
    let router = MnemonicExplainRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Prevent phone from sleeping
    UIApplication.shared.isIdleTimerDisabled = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // Allow phone to sleep
    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  
  // MARK: How to keep my backup safe?
  
  @IBAction func howToTapped(_ sender: SLBarButton) {
    SLSafariWebViewer.display(on: "https://en.bitcoin.it/wiki/Mnemonic_phrase", from: self)
  }
  
  
  // MARK: I understand

  @IBAction func understandTapped(_ sender: SLBarButton) {
    router?.routeToMnemonicDisplay()
  }
  
  
  
  
  

}
