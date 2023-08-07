//
//  RouterState.swift
//
//
//  Created by Tony on 2023/07/24.
//

import ComposableArchitecture
import RouteStack

public protocol RouterState: Equatable {
  associatedtype Screen: Equatable
  
  var paths: [RoutePath<Screen>] { get set }
}
