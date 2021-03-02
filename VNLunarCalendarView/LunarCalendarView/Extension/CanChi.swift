//
//  CanChi.swift
//  VNLunarCalendarView
//
//  Created by Hoàng Tuấn on 02/03/2021.
//

import Foundation

public struct CanChi {
    static let Thu: [Thu] = [ .sun, .mon, .tue, .wed, .thu, .fri, .sat ]
    static let Chi: [Chi] = [.ti, .suu, .dan, .mao, .thin, .ty, .ngo, .mui, .than, .dau, .tuat, .hoi]
    static let Can: [Can] = [ .giap, .at, .binh, .dinh, .mau, .ky, .canh, .tan, .nham, .quy]
}

enum Thu {
    case mon, tue, wed, thu, fri, sat, sun
    var string: String {
        switch self {
        case .mon: return "T2"
        case .tue: return "T3"
        case .wed: return "T4"
        case .thu: return "T5"
        case .fri: return "T6"
        case .sat: return "T7"
        case .sun: return "CN"
        }
    }
    
    var stringFullUpcase: String {
        switch self {
        case .mon: return "THỨ 2"
        case .tue: return "THỨ 3"
        case .wed: return "THỨ 4"
        case .thu: return "THỨ 5"
        case .fri: return "THỨ 6"
        case .sat: return "THỨ 7"
        case .sun: return "CHỦ NHẬT"
        }
    }
    
    var stringFullNormal: String {
        switch self {
        case .mon: return "Thứ Hai"
        case .tue: return "Thứ Ba"
        case .wed: return "Thứ Tư"
        case .thu: return "Thứ Năm"
        case .fri: return "Thứ Sáu"
        case .sat: return "Thứ Bảy"
        case .sun: return "Chủ Nhật"
        }
    }
}

enum Can {
    case giap, at, binh, dinh, mau, ky, canh, tan, nham, quy
    var string: String {
        switch self {
        case .giap: return "Giáp"
        case .at: return "Ất"
        case .binh: return "Bính"
        case .dinh: return "Đinh"
        case .mau: return "Mậu"
        case .ky: return "Kỷ"
        case .canh: return "Canh"
        case .tan: return "Tân"
        case .nham: return "Nhâm"
        case .quy: return "Quý"
        }
    }
}

enum Chi {
    case ti, suu, dan, mao, thin, ty, ngo, mui, than, dau, tuat, hoi
    var string: String {
        switch self {
        case .ti: return "Tý"
        case .suu: return "Sửu"
        case .dan: return "Dần"
        case .mao: return "Mão"
        case .thin: return "Thìn"
        case .ty: return "Tỵ"
        case .ngo: return "Ngọ"
        case .mui: return "Mùi"
        case .than: return "Thân"
        case .dau: return "Dậu"
        case .tuat: return "Tuất"
        case .hoi: return "Hợi"
        }
    }
}
