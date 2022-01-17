//
//  WorkspaceCreateScreen.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI

struct WorkspaceCreateScreen: View {
    @State private var name = ""

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Text("Confirm")
            }
        }
    }
}

struct WorkspaceCreateScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkspaceCreateScreen()
        }
    }
}
