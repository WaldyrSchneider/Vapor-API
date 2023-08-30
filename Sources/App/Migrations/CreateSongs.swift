//
//  CreateSongs.swift
//  
//
//  Created by Waldyr Schneider on 29/08/23.
//

import Fluent

struct CreateSongs: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("songs").delete()
    }
}
