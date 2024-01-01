//
//  Ramen.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2024/01/01.
//

import Foundation

struct Ramen: Identifiable {
    var id = UUID() // 自動生成される一意のID
    var name: String
    var shop: String
    var rating: Int
    var imageUrl: String? // Firebase Storageから取得した画像のURL（まだ画像がない場合はnil）
}

// まずはここで使用するデータをまとめる。
