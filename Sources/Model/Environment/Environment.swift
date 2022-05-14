//
//  SUEnvironment.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 14.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine
import SwiftUIRouter
import SUFoundation

public final class SUEnvironment: ObservableObject {

  private let factory = SUDepFactory()

  public let navigator: Navigator = Navigator()
  public private(set) lazy var appState: SUAppStateProvider = SUAppState(
    navigator: navigator,
    richiManager: factory.richiManager
  )

  public var repository: Repository { factory.repository }
  public var userManager: UserManager { factory.userManager }
  public var spaceManager: SpaceManager { factory.spaceManager }
  public var searchManager: SearchManager { factory.searchManager }
  public var workspaceManager: WorkspaceManager { factory.workspaceManager }
  public var documentManager: DocumentManager { factory.documentManager }
  public var memberManager: MemberManager { factory.memberManager }
  public var inviteManager: InviteManager { factory.inviteManager }
  public var accountManager: AccountManager { factory.accountManager }
  public var temporaryFileManager: TemporaryFileManager { factory.temporaryFileManager }
  public var textRecognitionManager: TextRecognitionManager { factory.textRecognitionManager }
  public var richiManager: RichiManager { factory.richiManager }
}
