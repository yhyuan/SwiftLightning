//
//  ChannelOpenPresenter.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-04-23.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChannelOpenPresentationLogic {
  
  func presentChannelConfirm(response: ChannelOpen.ChannelConfirm.Response)
  func presentNodePubKeyValid(response: ChannelOpen.ValidateNodePubKey.Response)
  func presentNodePortIPValid(response: ChannelOpen.ValidateNodeIPPort.Response)
  func presentAmountValid(response: ChannelOpen.ValidateAmounts.Response)
  func presentOnChainConfirmedBalance(response: ChannelOpen.GetBalance.Response)
}


class ChannelOpenPresenter: ChannelOpenPresentationLogic {
  
  weak var viewController: ChannelOpenDisplayLogic?
  
  // MARK: Validate Entries
  
  func presentNodePubKeyValid(response: ChannelOpen.ValidateNodePubKey.Response) {
    var errorLabelString = ""
    
    if !response.isKeyValid {
      errorLabelString = "Invalid Public Key"
      viewController?.updateInvalidity(nodePubKey: true)
    } else {
      viewController?.updateInvalidity(nodePubKey: false)
    }
    
    let viewModel = ChannelOpen.ValidateNodePubKey.WarningVM(errorLabel: errorLabelString)
    viewController?.displayNodePubKeyValidWarning(viewModel: viewModel)
  }
  
  func presentNodePortIPValid(response: ChannelOpen.ValidateNodeIPPort.Response) {
    var errorLabelString = ""
    var nodeIPPortInvalid = true

    if !response.isIPValid {
      errorLabelString = "Invalid Host Address"
    } else if !response.isPortValid {
      errorLabelString = "Invalid Port"
    } else {
      nodeIPPortInvalid = false
    }
    
    let viewModel = ChannelOpen.ValidateNodeIPPort.WarningVM(errorLabel: errorLabelString)
    viewController?.displayIPPortValidWarning(viewModel: viewModel)
    viewController?.updateInvalidity(nodeIPPort: nodeIPPortInvalid)
  }
  
  func presentAmountValid(response: ChannelOpen.ValidateAmounts.Response) {
    
    var errorLabelString = ""
    var errorAlertString: String? = nil
    
    var fundingInvalid = true
    var initPayInvalid = true
    
    switch response.initPayError {
    case .some(.invalid):
      errorLabelString = "Invalid entry"
    case .some(.insufficient):
      errorLabelString = "Over channel funding"
    case .some(.feeEstimation):
      errorLabelString = ""
      errorAlertString = "Cannot obtain fee estimation"
    case .some(.walletBalance):
      errorLabelString = ""
      errorAlertString = "Cannot obtain wallet balance"
    case .some(.empty):
      errorLabelString = ""
      initPayInvalid = false
    case .none:
      errorLabelString = ""
      initPayInvalid = false
    default:
      errorLabelString = ""
      errorAlertString = "Unexpected Error!"
    }
    
    let initPayViewModel = ChannelOpen.ValidateAmounts.InitPayWarningVM(initPayErrorLabel: errorLabelString)
    viewController?.displayInitPayAmtValidWarning(viewModel: initPayViewModel)
    
    switch response.fundingError {
    case .some(.invalid):
      errorLabelString = "Invalid Entry"
    case .some(.insufficient):
      errorLabelString = "Insufficient Funds"
    case .some(.minChannelSize):
      errorLabelString = "Min channel size (20,000) sat"
    case .some(.feeEstimation):
      errorLabelString = ""
      errorAlertString = "Cannot obtain fee estimation"
    case .some(.walletBalance):
      errorLabelString = ""
      errorAlertString = "Cannot obtain wallet balance"
    case .some(.empty):
      errorLabelString = ""
      initPayInvalid = false
    case .none:
      errorLabelString = ""
      fundingInvalid = false
    }
    
    viewController?.updateInvalidity(fundingAmt: fundingInvalid, initAmt: initPayInvalid)
    
    let fundingViewModel = ChannelOpen.ValidateAmounts.FundingWarningVM(fundingErrorLabel: errorLabelString)
    viewController?.displayFundingAmtValidWarning(viewModel: fundingViewModel)
    
    if let errorAlertString = errorAlertString {
      let viewModel = ChannelOpen.ValidateAmounts.ErrorVM(errTitle: "Channel Amount Error", errMsg: errorAlertString)
      viewController?.displayAmtValidError(viewModel: viewModel)
    }
  }
  
  
  // MARK: Get Balance
  
  func presentOnChainConfirmedBalance(response: ChannelOpen.GetBalance.Response) {
    if let confirmedBalance = response.onChainBalance {
      let balanceString = confirmedBalance.formattedInSatoshis()
      let viewModel = ChannelOpen.GetBalance.ViewModel(onChainBalance: balanceString)
      viewController?.displayOnChainConfirmedBalance(viewModel: viewModel)
    } else {
      let viewModel = ChannelOpen.GetBalance.ErrorVM(errTitle: "Wallet Balance", errMsg: "Cannot retreive wallet balance. Please restart app.")
      viewController?.displayOnChainConfirmedBalanceError(viewModel: viewModel)
    }
  }
  
  
  // MARK: Channel Opening Confirm
  
  func presentChannelConfirm(response: ChannelOpen.ChannelConfirm.Response) {
    if response.isPubKeyValid, response.isIPValid, response.isPortValid, response.isFundingValid, response.isInitPayValid {
      viewController?.displayChannelConfirm()
      
    } else {
      let viewModel = ChannelOpen.ChannelConfirm.ErrorVM(errTitle: "Channel Open Error",
                                                         errMsg: "Invalid new channel parameters. Please correct and try again")
      viewController?.displayChannelConfirmError(viewModel: viewModel)
    }
  }
}
