//
//  SongController.swift
//  
//
//  Created by Waldyr Schneider on 29/08/23.
//

import Vapor
import Fluent

struct SongController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID") { song in
            song.delete(use: delete)
        }
    }
    
    // GET Request / return all songs route
    func index(req: Request) async throws -> [Song] {
        try await Song.query(on: req.db).all()
    }
    
    // POST Request / create song route
    func create(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
        try await song.save(on: req.db)
        return .ok
    }
    
    // PUT Request / update song route
    func update(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
        
        guard let songFromDb = try await Song.find(song.id, on: req.db) else { throw Abort(.notFound) }
        
        songFromDb.title = song.title
        try await songFromDb.update(on: req.db)
        
        return .ok
    }
    
    // DELETE Request / delete song route songs/id
    func delete(req: Request) async throws -> HTTPStatus {
        guard let song = try await Song.find(req.parameters.get("songID"), on: req.db) else { throw Abort(.notFound) }
        
        try await song.delete(on: req.db)
        
        return .ok
    }
}
