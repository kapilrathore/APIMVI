//
//  Repository.swift
//  APIMVI
//
//  Created by Kapil Rathore on 27/11/18.
//  Copyright © 2018 kite.work. All rights reserved.
//

import Foundation
import RxSwift
import RxGRDB
import GRDB

protocol Repository {
  func addBlogs(_ blogs: [Blog])
  func getAllBlogs() -> Observable<[Blog]>
}

class BlogRepository {
  private let database: AppDatabase
  private lazy var blogDao: BlogDao = database.blogsDao

  init(database: AppDatabase) {
    self.database = database
  }
}

extension BlogRepository: Repository {
  func addBlogs(_ blogs: [Blog]) {
    blogDao.insertAll(blogs)
  }

  func getAllBlogs() -> Observable<[Blog]> {
    return blogDao
      .getAll()
  }
}
