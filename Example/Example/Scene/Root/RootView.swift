//
//  RootView.swift
//  Example
//
//  Created by Tony on 2023/07/24.
//  
//

import SwiftUI
import ComposableArchitecture

public struct RootView: View {
  @ObservedObject
  private var viewStore: ViewStoreOf<Root>
  private let store: StoreOf<Root>
  
  public init(store: StoreOf<Root>) {
    self.viewStore = ViewStoreOf<Root>(store, observe: { $0 })
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("Root View 입니다.")
        .font(.title)
        .foregroundStyle(.red)
      
      Button("push") {
        viewStore.send(.tappedPushButton)
      }
      
      Button("custom-sheet") {
        viewStore.send(.tappedCustomSheetButton)
      }
      
      Button("normal-sheet") {
        viewStore.send(.tappedNormalSheetButton)
      }
      
      Button("cover") {
        viewStore.send(.tappedCoverSheetButton)
      }
    }
  }
}
