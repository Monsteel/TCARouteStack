//
//  RouterView.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import SwiftUI
import ComposableArchitecture
import TCARouteStack

public struct RouterView: View {
  @ObservedObject
  private var viewStore: ViewStoreOf<Router>
  private let store: StoreOf<Router>
  
  public init(store: StoreOf<Router>) {
    self.viewStore = ViewStoreOf<Router>(store, observe: { $0 })
    self.store = store
  }
  
  private func root() -> some View {
    RootView(store: store.scope(state: \.root, action: Router.Action.root))
  }
  
  public var body: some View {
    RouteStackStore(store, root: root) { store in
      SwitchStore(store) { state in
        switch state {
        case .first:
          CaseLet(/Screen.State.first, action: Screen.Action.first, then: FirstView.init)

        case .second:
          CaseLet(/Screen.State.second, action: Screen.Action.second, then: SecondView.init)
          
        case .third:
          CaseLet(/Screen.State.third, action: Screen.Action.third, then: ThirdView.init)
        }
      }
    }
    .onOpenURL { url in
      viewStore.send(.openURL(url))
    }
  }
}
