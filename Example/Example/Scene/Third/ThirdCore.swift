//
//  ThirdCore.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import ComposableArchitecture
import Foundation

public struct Third: Reducer {
  public struct State: Equatable {
    public var value: String

    public init(value: String) {
      self.value = value
    }
  }

  public enum Action: Equatable {
    case tappedBackButton
    case tappedBackToRootButton
  }
  
  @Dependency(\.uiApplication) var uiApplication

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tappedBackButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://back")!)
        return .none
      case .tappedBackToRootButton:
        uiApplication.open(URL(string: "tcaRouteStackExample://backToRoot")!)
        return .none
      }
    }
  }
  
  public init() { }
}
