//
//  DocumentViewModel.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 29.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import SUFoundation


public final class DocumentViewModel: ObservableObject {

    private let appState: AppState
    private let documentMeta: SUDocumentMeta

    public init(appState: AppState, documentMeta: SUDocumentMeta) {
        self.appState = appState
        self.documentMeta = documentMeta
    }
}

public extension DocumentViewModel {

    func backAction() {
        
    }
}
