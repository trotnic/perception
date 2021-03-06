//
//  DepFactory.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Firebase

public final class SUDepFactory {

  enum Constants {
    static let appName = "com-staruco-firebaseapp"
  }

  private lazy var app: FirebaseApp = .app(name: Constants.appName)!
  private lazy var firestore: Firestore = .firestore(app: app)
  private lazy var storage: Storage = .storage(app: app)
  private lazy var auth: Auth = .auth(app: app)

  private lazy var _userSession: UserSession = .init(auth: auth)
  private lazy var _repository: FireRepository = .init(firestore: firestore, storage: storage)

  public init() {
    FirebaseApp.configure(name: Constants.appName, options: .defaultOptions()!)
  }
}

public extension SUDepFactory {

  var repository: Repository { _repository }

  var userSession: UserSession { _userSession }

  var userManager: UserManager { UserManager(repository: _repository, userSession: _userSession) }

  var spaceManager: SpaceManager { SpaceManager(repository: _repository) }

  var searchManager: SearchManager { SearchManager(repository: _repository) }

  var workspaceManager: WorkspaceManager { WorkspaceManager(repository: _repository) }

  var documentManager: DocumentManager { DocumentManager(repository: _repository) }

  var memberManager: MemberManager { MemberManager(repository: _repository) }

  var inviteManager: InviteManager { InviteManager(repository: _repository) }

  var accountManager: AccountManager { AccountManager(repository: _repository) }

  var temporaryFileManager: TemporaryFileManager { TemporaryFileManager(userDefaults: .standard, fileManager: .default) }

  var textRecognitionManager: TextRecognitionManager { TextRecognitionManager() }

  var richiManager: RichiManager { RichiManager() }
}
