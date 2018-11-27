//
//  BlogDao.swift
//  APIMVI
//
//  Created by Kapil Rathore on 26/11/18.
//  Copyright © 2018 kite.work. All rights reserved.
//

import Foundation
import RxSwift
import RxGRDB
import GRDB

class BlogDao {
  private let dbQueue: DatabaseQueue

  init(_ dbQueue: DatabaseQueue) {
    self.dbQueue = dbQueue
  }

  func insert(_ blog: Blog) {
    do {
      try dbQueue.inDatabase { db in
        _ = try blog.insert(db)
      }
    } catch let error {
      fatalError("Couldn't save the transaction status: \(error)")
    }
  }

  func insertAll(_ blogs: [Blog]) {
    do {
      try dbQueue.inDatabase { db in
        for blog in blogs {
          _ = try blog.insert(db)
        }
      }
    } catch let error {
      fatalError("Couldn't save the transaction statuses: \(error)")
    }
  }

  func deleteAll(_ blogs: [Blog]) {
    do {
      try dbQueue.inDatabase { db in
        for blog in blogs {
          _ = try blog.delete(db)
        }
      }
    } catch let error {
      fatalError("Couldn't delete the transaction statuses: \(error)")
    }
  }

  func getAll() -> Observable<[Blog]> {
    let request = Blog.all()
    return request.rx
      .fetchAll(in: dbQueue)
      .asObservable()
  }
}
