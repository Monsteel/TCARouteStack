//
//  RouterAction.swift
//
//
//  Created by Tony on 2023/07/24.
//

import ComposableArchitecture
import RouteStack

public protocol RouterAction: Equatable {
  associatedtype Screen: Equatable
  associatedtype ScreenAction: Equatable
  
  static func updatePaths(_ paths: RoutePaths<Screen>) -> Self
  static func pathAction(_ id: RoutePath<Screen>.ID, action: ScreenAction) -> Self
}
