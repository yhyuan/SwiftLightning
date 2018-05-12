//
//  LNDDebugLevelRouter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-11.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol LNDDebugLevelRoutingLogic
{
  func routeToSettingsMain()
}

protocol LNDDebugLevelDataPassing
{
  var dataStore: LNDDebugLevelDataStore? { get }
}

class LNDDebugLevelRouter: NSObject, LNDDebugLevelRoutingLogic, LNDDebugLevelDataPassing
{
  weak var viewController: LNDDebugLevelViewController?
  var dataStore: LNDDebugLevelDataStore?
  
  // MARK: Routing
  
  func routeToSettingsMain() {
    //    let destinationVC = viewController! as! WalletMainViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToWalletMain(source: dataStore!, destination: &destinationDS)
    navigateToSettingsMain(source: viewController!)
  }
  
  
  // MARK: Navigation

  func navigateToSettingsMain(source: LNDDebugLevelViewController) {
    guard let navigationController = source.navigationController else {
      SLLog.assert("\(type(of: source)).navigationController = nil")
      return
    }
    navigationController.popViewController(animated: true)
  }
  
  
  // MARK: Passing data
  
  func passDataToSettingsMain(source: LNDDebugLevelDataStore, destination: inout SettingsMainDataStore) { }

}
