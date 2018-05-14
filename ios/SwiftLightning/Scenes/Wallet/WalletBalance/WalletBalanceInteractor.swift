//
//  WalletBalanceInteractor.swift
//  SwiftLightning
//
//  Created by Howard Lee on 2018-05-13.
//  Copyright (c) 2018 BiscottiGelato. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WalletBalanceBusinessLogic {
  func refresh(request: WalletBalance.Refresh.Request)
}


protocol WalletBalanceDataStore {
}


class WalletBalanceInteractor: WalletBalanceBusinessLogic, WalletBalanceDataStore {
  var presenter: WalletBalancePresentationLogic?
  
  
  // MARK: Refresh
  
  func refresh(request: WalletBalance.Refresh.Request) {
    LNServices.walletBalance() { (walletResponder) in
      do {
        let onChainBalance = try walletResponder()
        let onChainTotal = Bitcoin(inSatoshi: onChainBalance.total)
        let onChainConfirmed = Bitcoin(inSatoshi: onChainBalance.confirmed)
        let onChainUnconfirmed = Bitcoin(inSatoshi: onChainBalance.unconfirmed)

        var totalBalance = onChainTotal
        
        LNServices.channelBalance() { (channelResponder) in
          do {
            let channelBalance = try channelResponder()
            let channelConfirmed = Bitcoin(inSatoshi: channelBalance.confirmed)
            let channelPending = Bitcoin(inSatoshi: channelBalance.pendingOpen)
            
            totalBalance = Bitcoin(totalBalance + channelConfirmed + channelPending)
            
            let response = WalletBalance.Refresh.Response(totalBalance: totalBalance,
                                                          onChainTotal: onChainTotal,
                                                          onChainConfirmed: onChainConfirmed,
                                                          onChainUnconfirmed: onChainUnconfirmed,
                                                          channelConfirmed: channelConfirmed,
                                                          channelPending: channelPending)
            self.presenter?.presentRefresh(response: response)
            
          } catch {
            let response = WalletBalance.Refresh.Response(totalBalance: totalBalance,
                                                          onChainTotal: onChainTotal,
                                                          onChainConfirmed: onChainConfirmed,
                                                          onChainUnconfirmed: onChainUnconfirmed,
                                                          channelConfirmed: nil,
                                                          channelPending: nil)
            self.presenter?.presentRefresh(response: response)
          }
        }
        
      } catch {
        let response = WalletBalance.Refresh.Response(totalBalance: nil,
                                                      onChainTotal: nil,
                                                      onChainConfirmed: nil,
                                                      onChainUnconfirmed: nil,
                                                      channelConfirmed: nil,
                                                      channelPending: nil)
        self.presenter?.presentRefresh(response: response)
      }
    }
  }
}