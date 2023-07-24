//
//  URL+Extensions.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//

import Foundation

extension URL {
  public func valueOf(_ name: String) -> String? {
    guard let url = URLComponents(string: self.absoluteString) else { return nil }
    return url.queryItems?.first(where: { $0.name == name })?.value
  }
}
