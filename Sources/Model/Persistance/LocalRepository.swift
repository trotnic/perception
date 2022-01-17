//
//  LocalRepository.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 13.01.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Foundation
import CoreData
import Fakery

protocol Repository {

    func readWorkspaces() -> Result<[SUWorkspace], Error>
    func createWorkspace(name: String) -> Result<UUID, Error>

    func readShelfs(workspaceId: UUID) -> Result<[SUShelf], Error>
}

final class LocalRepository {

    static let shared = LocalRepository()

    private let container: NSPersistentContainer

    private var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    private func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    init() {
        container = NSPersistentContainer(name: "Perception")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

}

extension LocalRepository: Repository {

    func readWorkspaces() -> Result<[SUWorkspace], Error> {
        let request = CDWorkspace.fetchRequest()
        do {
            let result = try viewContext.fetch(request).compactMap { workspace in
                workspace.identifier.flatMap { identifier in
                    workspace.name.flatMap { name in
                        SUWorkspace(id: identifier, title: name)
                    }
                }
            }
            return .success(result)
        } catch {
            return .failure(error)
        }
    }

    func createWorkspace(name: String) -> Result<UUID, Error> {
        do {
            let object = CDWorkspace(context: container.viewContext)
            let identifier = UUID()
            object.identifier = identifier
            object.name = name
            try container.viewContext.save()
            return .success(identifier)
        } catch {
            return .failure(error)
        }
    }

    func readShelfs(workspaceId: UUID) -> Result<[SUShelf], Error> {
        let request = CDShelf.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == \(workspaceId)")
        do {
            let result = try viewContext.fetch(request).compactMap { shelf in
                shelf.identifier.flatMap { identifier in
                    shelf.name.flatMap { name in
                        SUShelf(id: identifier, title: name)
                    }
                }
            }
            return .success(result)
        } catch {
            return .failure(error)
        }
    }

}
