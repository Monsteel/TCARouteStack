//
//  SecondCore.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import ComposableArchitecture
import Foundation

public struct Second: Reducer {
  public struct State: Equatable {
    public var value: String

    public init(value: String) {
      self.value = value
    }
  }

  public enum Action: Equatable {
    case tappedBackButton
    case tappedPushButton
    case tappedCustomSheetButton
    case tappedNormalSheetButton
    case tappedCoverSheetButton
  }
  
  @Dependency(\.uiApplication) var uiApplication
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tappedBackButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://back")!)
        return .none
      case .tappedPushButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://thirdView?value=push")!)
        return .none
      case .tappedCustomSheetButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://thirdView?value=customSheet")!)
        return .none
      case .tappedNormalSheetButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://thirdView?value=normalSheet")!)
        return .none
      case .tappedCoverSheetButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://thirdView?value=cover")!)
        return .none
      }
    }
  }
  
  public init() { }
}
