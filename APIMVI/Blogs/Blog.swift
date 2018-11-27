//
//  Blog.swift
//  APIMVI
//
//  Created by Kapil Rathore on 26/11/18.
//  Copyright © 2018 kite.work. All rights reserved.
//

import Foundation
import RxGRDB
import GRDB

class Blog: Record, Decodable {
  let userId: Int
  let id: Int
  let title: String
  let body: String

  struct Column {
    static let userId = "userId"
    static let id = "id"
    static let title = "title"
    static let body = "body"
  }

  override class var databaseTableName: String {
    return "blogs"
  }

  public override func encode(to container: inout PersistenceContainer) {
    container[Column.userId] = userId
    container[Column.id] = id
    container[Column.title] = title
    container[Column.body] = body
  }
}

extension Blog: Equatable {
  static func == (lhs: Blog, rhs: Blog) -> Bool {
    return lhs.userId == rhs.userId
      && lhs.id == rhs.id
      && lhs.title == rhs.title
      && lhs.body == rhs.body
  }
}
