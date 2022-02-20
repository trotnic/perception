//
//  Repository.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//


public protocol Repository {
    func workspaces(for userId: String) async throws -> [SUShallowWorkspace]
    func listenWorkspace(with id: String, completion: @escaping (SUWorkspace) -> Void)
    func workspace(with id: String) async throws -> SUWorkspace
    func createWorkspace(with title: String, userId: String) async throws -> String
    func createDocument(with title: String, in workspaceId: String, for userId: String) async throws -> String
    func document(with id: String) async throws -> SUDocument
    func observeDocument(with id: String)
    func updateDocument(with id: String, text: String) async throws
    func deleteDocument(with id: String, in workspaceId: String) async throws
}
