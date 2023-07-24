//
//  RootCore.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import ComposableArchitecture
import Foundation

public struct Root: ReducerProtocol {
  public struct State: Equatable {

    public init() { }
  }

  public enum Action: Equatable {
    case tappedPushButton
    case tappedCustomSheetButton
    case tappedNormalSheetButton
    case tappedCoverSheetButton
  }
  
  @Dependency(\.uiApplication) var uiApplication

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .tappedPushButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://firstView?value=push")!)
        return .none
      case .tappedCustomSheetButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://firstView?value=customSheet")!)
        return .none
      case .tappedNormalSheetButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://firstView?value=normalSheet")!)
        return .none
      case .tappedCoverSheetButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://firstView?value=cover")!)
        return .none
      }
    }
  }
  
  public init() { }
}
