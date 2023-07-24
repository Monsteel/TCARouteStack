//
//  RouteStackStore.swift
//
//
//  Created by Tony on 2023/07/24.
//

import ComposableArchitecture
import RouteStack
import Foundation
import SwiftUI

public struct RouteStackStore<
  State: RouterState,
  Action: RouterAction,
  Screen: Equatable,
  Root: View,
  Destination: View
>: View
where
State.Screen == Action.Screen,
State.Screen == Screen
{
  let store: Store<State, Action>
  @ViewBuilder let root: () -> Root
  @ViewBuilder let destination: (Store<Screen, Action.ScreenAction>) -> Destination
  
  func scopedStore(id: RoutePath<Screen>.ID, screen: Screen) -> Store<Screen, Action.ScreenAction> {
    var screen = screen
    return store.scope(
      state: {
        if let index = $0.paths.flatten.firstIndex(where: { $0.id == id }) {
          screen = $0.paths.flatten[safe: index]?.data ?? screen
        }
        return screen
      },
      action: {
        return Action.pathAction(id, action: $0)
      }
    )
  }
  
  public init(
    _ store: Store<State, Action>,
    root: @escaping () -> Root,
    destination: @escaping (Store<Screen, Action.ScreenAction>) -> Destination
  ) {
    self.store = store
    self.root = root
    self.destination = destination
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      RouteStack(
        viewStore.binding(
          get: \.paths,
          send: Action.updatePaths
        ),
        root: root,
        destination: { id, screen in
          destination(scopedStore(id: id, screen: screen))
        }
      )
    }
  }
}

extension Collection {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
