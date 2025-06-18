//
//  DBSqliteHelper.swift
//  Vastar
//
//  Created by Charles Kuo on 2025/6/18.
//

import Foundation
import SQLite3

class DBSqliteHelper {
    private var database: OpaquePointer?

    // 開啟資料庫
    func openDatabase(fileName: String = "VastarDataBase", fileType: String = "db") -> OpaquePointer? {
        copyDatabaseIfNeeded(fileName: fileName, fileType: fileType)
        let dbPath = getDatabaseFullPath(fileName: "\(fileName).\(fileType)")

        if sqlite3_open(dbPath, &database) == SQLITE_OK {
            print("資料庫已開啟: \(dbPath)")
            return database
        } else {
            print("無法開啟資料庫")
            return nil
        }
    }

    // 關閉資料庫
    func closeDatabase() {
        if let db = database {
            sqlite3_close(db)
            print("資料庫已關閉")
        }
    }

    // 獲取資料庫完整路徑
    func getDatabaseFullPath(fileName: String) -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName).path
    }

    // 如果需要，複製資料庫檔案
    func copyDatabaseIfNeeded(fileName: String, fileType: String) {
        let fileManager = FileManager.default
        let fullFileName = "\(fileName).\(fileType)"
        let destinationPath = getDatabaseFullPath(fileName: fullFileName)

        if !fileManager.fileExists(atPath: destinationPath) {
            if let sourcePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
                do {
                    try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
                    print("資料庫已複製到: \(destinationPath)")
                } catch {
                    print("無法複製資料庫: \(error)")
                }
            } else {
                print("未找到來源資料庫檔案")
            }
        } else {
            print("資料庫檔案已存在: \(destinationPath)")
        }
    }

    // 執行 SQL 查詢
    func executeQuery(query: String) -> OpaquePointer? {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            return statement
        } else {
            print("SQL 查詢失敗: \(errorMessage())")
            return nil
        }
    }

    // 獲取錯誤訊息
    func errorMessage() -> String {
        if let db = database {
            return String(cString: sqlite3_errmsg(db))
        }
        return "無錯誤訊息"
    }

    // 移除檔案
    func removeFile(fileName: String) {
        let filePath = getDatabaseFullPath(fileName: fileName)
        do {
            try FileManager.default.removeItem(atPath: filePath)
            print("檔案已移除: \(filePath)")
        } catch {
            print("無法移除檔案: \(error)")
        }
    }
}
