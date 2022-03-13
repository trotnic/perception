//
//  Repository.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//


public protocol Repository {

    func startListenSpace(userId: String, callback: @escaping ([SUShallowWorkspace]) -> Void)
    func workspaces(for userId: String) async throws -> [SUShallowWorkspace]
//    func listenWorkspace(with id: String, completion: @escaping (SUWorkspace) -> Void)

    func startListenWorkspace(workspaceId: String, callback: @escaping (SUWorkspace) -> Void)
    func workspace(with id: String) async throws -> SUWorkspace
    func createWorkspace(with title: String, userId: String) async throws -> String
    func createDocument(with title: String, in workspaceId: String, for userId: String) async throws -> String

    func updateWorkspace(id: String, title: String) async throws
    func updateWorkspace(id: String, emoji: String) async throws

    func startListenDocument(documentId: String, callback: @escaping (SUDocument) -> Void)
    func document(with id: String) async throws -> SUDocument

    func updateDocument(with id: String, title: String) async throws
    func updateDocument(with id: String, emoji: String) async throws
    func updateDocument(with id: String, text: String) async throws

    func deleteDocument(with id: String, in workspaceId: String) async throws
    func deleteWorkspace(id: String, userId: String) async throws

    func members(workspaceId: String, callback: @escaping ([SUWorkspaceMember]) -> Void)
    func addMember(email: String, workspaceId: String) async throws
    func startListenInvites(userId: String, callback: @escaping ([SUShallowWorkspace]) -> Void) async throws

    func user(with id: String) async throws -> SUUser
    func updateUser(with id: String, name: String) async throws

    func startListenUser(with id: String, callback: @escaping (SUUser) -> Void)
    func stopListen(with id: String)

    func searchWorkspaces(for userId: String, with name: String) async throws -> [SUShallowWorkspace]
    func searchDocuments(for userId: String, with name: String) async throws -> [SUShallowDocument]
}
