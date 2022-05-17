//
//  Repository.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation

public protocol Repository {
  func startListenSpace(userId: String, callback: @escaping ([SUShallowWorkspace]) -> Void) async throws
  func workspaces(for userId: String) async throws -> [SUShallowWorkspace]

  func startListenWorkspace(workspaceId: String, callback: @escaping (SUWorkspace) -> Void)
  func workspace(with id: String) async throws -> SUWorkspace
  func createWorkspace(with title: String, userId: String) async throws -> String
  func createDocument(with title: String, in workspaceId: String, for userId: String) async throws -> String

  func updateWorkspace(id: String, title: String) async throws
  func updateWorkspace(id: String, emoji: String) async throws

  func startListenDocument(documentId: String, callback: @escaping (SUDocument) -> Void)
  func document(with id: String) async throws -> SUDocument

  func updateDocument(documentId: String, updateSubject: SUDocumentUpdateSubject) async throws
  func updateDocument(with id: String, title: String) async throws
  func updateDocument(with id: String, emoji: String) async throws
  func updateDocument(with id: String, text: String) async throws

  func insertImageIntoDocument(with id: String, imageData: Data) async throws
  func insertTextIntoDocument(with id: String, text: String) async throws

  func deleteBlock(documentId: String, blockId: String) async throws

  func deleteDocument(with id: String, in workspaceId: String) async throws
  func deleteWorkspace(id: String, userId: String) async throws

  func members(workspaceId: String, callback: @escaping ([SUWorkspaceMember]) -> Void)
  func sendInvite(email: String, workspaceId: String) async throws
  func removeMember(userId: String, workspaceId: String) async throws

  func startListenInvites(userId: String, callback: @escaping ([SUShallowWorkspace]) -> Void) async throws
  func confirmInvite(userId: String, workspaceId: String)
  func rejectInvite(userId: String, workspaceId: String)

  func user(with id: String) async throws -> SUUser
  func updateUser(with id: String, name: String) async throws
  func uploadImage(data: Data, userId: String)

  func startListenUser(with id: String, callback: @escaping (SUUser) -> Void)
  func stopListen(with id: String)

  func searchWorkspaces(for userId: String, with name: String) async throws -> [SUShallowWorkspace]
  func searchDocuments(for userId: String, with name: String) async throws -> [SUShallowDocument]
}
