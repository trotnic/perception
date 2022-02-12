//
//  Auth+.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import FirebaseAuth

extension Auth {

    var currentUserUnwrapped: User {
        currentUser!
    }
}
