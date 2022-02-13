//
//  Repository.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 12.02.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//


public protocol Repository {
    func workspaces(for userId: String) async throws -> [SUWorkspace]
    func workspace(with id: String) async throws -> SUWorkspace
    func createWorkspace(with title: String, userId: String) async throws -> String
    func createDocument(with title: String, in workspaceId: String, for userId: String) async throws -> String
}
