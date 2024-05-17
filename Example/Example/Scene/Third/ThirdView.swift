//
//  ThirdView.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import SwiftUI
import ComposableArchitecture

public struct ThirdView: View {
  @ObservedObject
  private var viewStore: ViewStoreOf<Third>
  private let store: StoreOf<Third>
  
  public init(store: StoreOf<Third>) {
    self.viewStore = ViewStoreOf<Third>(store, observe: { $0 })
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Text("Third View 입니다.")
        .font(.title)
      
      Text("\(viewStore.value) 로 열렸습니다.")
        .font(.subheadline)
      
      Button("back") {
        viewStore.send(.tappedBackButton)
      }
      
      Button("back To root") {
        viewStore.send(.tappedBackToRootButton)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.green)
  }
}
