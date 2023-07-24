//
//  Dependencies.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//

import UIKit
import ComposableArchitecture

extension UIApplication: DependencyKey {
  static public var liveValue = UIApplication.shared
}

extension DependencyValues {
  public var uiApplication: UIApplication {
    get { self[UIApplication.self] }
    set { self[UIApplication.self] = newValue }
  }
}
