//
//  Ramen.swift
//  ImageSaveSampleApp
//
//  Created by RikutoSato on 2023/12/19.
//

import Foundation

struct Ramen: Identifiable {
    var id = UUID() // 自動生成される一意のID
    var name: String
    var shop: String
    var rating: Int
    var imageUrl: String? // Firebase Storageから取得した画像のURL（まだ画像がない場合はnil）
}
