////
////  LocalRepository.swift
////  Perception
////
////  Created by Uladzislau Volchyk on 13.01.22.
////  Copyright © 2022 Star Unicorn. All rights reserved.
////
//
//import Foundation
//import CoreData
//import Fakery
//
//public protocol Repository {
//
//    func findWorkspace(id: UUID) -> Result<SUWorkspace, Error>
//    func readWorkspaces() -> Result<[SUWorkspace], Error>
//    func createWorkspace(name: String) -> Result<UUID, Error>
//
//    func readShelfs(workspaceId: UUID) -> Result<[SUShelf], Error>
//}
//
//public final class LocalRepository {
//
//    static let shared = LocalRepository()
//
//    private let container: NSPersistentContainer
//
//    private var viewContext: NSManagedObjectContext {
//        container.viewContext
//    }
//
//    private func newBackgroundContext() -> NSManagedObjectContext {
//        container.newBackgroundContext()
//    }
//
//    public init() {
//        container = NSPersistentContainer(name: "Perception")
//        container.loadPersistentStores { storeDescription, error in
//            if let error = error {
//                fatalError("Failed to load Core Data stack: \(error)")
//            }
//        }
//    }
//
//}
//
//extension LocalRepository: Repository {
//
//    public func findWorkspace(id: UUID) -> Result<SUWorkspace, Error> {
//        let request = CDWorkspace.fetchRequest()
//        request.predicate = NSPredicate(format: "identifier == '\(id)'")
//        do {
//            let result = try viewContext.fetch(request).compactMap { workspace in
//                workspace.identifier.flatMap { identifier in
//                    workspace.name.flatMap { title in
//                        SUWorkspace(meta: .init(id: identifier.uuidString), title: title, shelfs: [])
//                    }
//                }
//            }
//            return .success(result[0])
//        } catch {
//            return .failure(error)
//        }
//    }
//
//    public func readWorkspaces() -> Result<[SUWorkspace], Error> {
//        let request = CDWorkspace.fetchRequest()
//        do {
//            let result = try viewContext.fetch(request).compactMap { workspace in
//                workspace.identifier.flatMap { identifier in
//                    workspace.name.flatMap { name in
//                        SUWorkspace(meta: .init(id: identifier.uuidString), title: name, shelfs: [])
//                    }
//                }
//            }
//            return .success(result)
//        } catch {
//            return .failure(error)
//        }
//    }
//
//    public func createWorkspace(name: String) -> Result<UUID, Error> {
//        do {
//            let object = CDWorkspace(context: container.viewContext)
//            let identifier = UUID()
//            object.identifier = identifier
//            object.name = name
//            try container.viewContext.save()
//            return .success(identifier)
//        } catch {
//            return .failure(error)
//        }
//    }
//
//    public func readShelfs(workspaceId: UUID) -> Result<[SUShelf], Error> {
////        let request = CDWorkspace.fetchRequest()
////        request.predicate = NSPredicate(format: "identifier == '\(workspaceId)'")
////        do {
////            let result = try viewContext.fetch(request).compactMap { workspace in
////                workspace.shelfs?
////                    .compactMap { $0 as? CDShelf }
////                    .compactMap { shelf in
////                        shelf.identifier.flatMap { identifier in
////                            shelf.name.flatMap { title in
////                                SUShelf(meta: .init(id: identifier, workspaceId: workspaceId.uuidString), title: title, documents: [])
////                            }
////                        }
////                    }
////            }
////            return .success(result[0])
////        } catch {
////            return .failure(error)
////        }
//        .success([])
//    }
//}
