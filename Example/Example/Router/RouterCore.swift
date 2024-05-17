//
//  RouterCore.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import ComposableArchitecture
import TCARouteStack
import Foundation

public struct Router: Reducer {
  public struct State: Equatable, RouterState {
    public var root: Root.State
    public var paths: [RoutePath<Screen.State>]
    
    public init(
      root: Root.State = .init(),
      paths: [RoutePath<Screen.State>] = []
    ) {
      self.root = root
      self.paths = paths
    }
  }
  
  public enum Action: Equatable, RouterAction {
    case openURL(URL)
    case root(Root.Action)
    case updatePaths([RoutePath<Screen.State>])
    case pathAction(RoutePath<Screen.State>.ID, action: Screen.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .openURL(url):
        let value = url.valueOf("value") ?? ""
        var style: Style {
          switch value {
          case "push":
            return .push
          case "customSheet":
            return .sheet([.medium, .large], .visible)
          case "normalSheet":
            return .sheet()
          case "cover":
            return .cover
          default:
            return .cover
          }
        }
        switch url.host {
        case "back":
          state.paths.removeLast()
        case "backToRoot":
          state.paths.removeAll()
        case "firstView":
          state.paths.append(RoutePath(data: Screen.State.first(.init(value: value)), style: style))
        case "secondView":
          state.paths.append(RoutePath(data: Screen.State.second(.init(value: value)), style: style))
        case "thirdView":
          state.paths.append(RoutePath(data: Screen.State.third(.init(value: value)), style: style))
        default: break
        }
        return .none
      case .root:
        return .none
      case .updatePaths:
        return .none
      case .pathAction:
        return .none
      }
    }
    .forEachRoute {
      Screen()
    }
    Scope(state: \.root, action: /Action.root) { Root() }
  }
  
  public init() { }
}

public struct Screen: Reducer {
  public enum State: Equatable {
    case first(First.State)
    case second(Second.State)
    case third(Third.State)
  }
  
  public enum Action: Equatable {
    case first(First.Action)
    case second(Second.Action)
    case third(Third.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: /State.first, action: /Action.first) {
      First()
    }
    Scope(state: /State.second, action: /Action.second) {
      Second()
    }
    Scope(state: /State.third, action: /Action.third) {
      Third()
    }
  }
}
