//
//  AppDatabase.swift
//  APIMVI
//
//  Created by Kapil Rathore on 26/11/18.
//  Copyright © 2018 kite.work. All rights reserved.
//

import Foundation
import RxGRDB
import GRDB

class AppDatabase {
  private let dbName: String
  lazy var path = {
    self.applicationDocumentsDirectory
    .appendingPathComponent(dbName)
    .absoluteString
  }()
  lazy var dbQueue: DatabaseQueue = {
    do {
      let db = try DatabaseQueue(path: path, configuration: dbConfiguration)
      db.setupMemoryManagement(in: UIApplication.shared)
      return db
    } catch let error {
      fatalError("Can't create database queue: \(error)")
    }
  }()

  private lazy var applicationDocumentsDirectory: URL = {
    do {
      let documentDirectory = try FileManager.default
        .url(for: .documentDirectory,
             in: .userDomainMask,
             appropriateFor: nil,
             create: false)
      return documentDirectory
    } catch let error {
      fatalError("Can't find the documents directory: \(error)")
    }
  }()

  lazy var dbConfiguration: Configuration = {
    var configuration = Configuration()
    return configuration
  }()

  init(dbName: String) {
    self.dbName = dbName
    setupDbSchemaAndMigrate()
  }

  func setupDbSchemaAndMigrate() {
    var migrator = DatabaseMigrator()
    setupFirstVersion(&migrator)
    do {
      let dbQueue = self.dbQueue
      try migrator.migrate(dbQueue)
    } catch let error {
      fatalError("Can't create tables inside the database: \(error)")
    }
  }

  lazy var blogsDao: BlogDao = {
    do {
      let dbQueue = try DatabaseQueue(path: path)
      return BlogDao(dbQueue)
    } catch let error {
      fatalError(error.localizedDescription)
    }
  }()

  func setupFirstVersion(_ migrator: inout DatabaseMigrator) {
    migrator.registerMigration("v1.0") { db in
      try db.create(table: Blog.databaseTableName, body: { t in
        typealias Column = Blog.Column
        t.column(Column.id, .integer).notNull().primaryKey()
        t.column(Column.userId, .integer).notNull()
        t.column(Column.title, .text).notNull()
        t.column(Column.body, .text).notNull()
      })
    }
  }
}
