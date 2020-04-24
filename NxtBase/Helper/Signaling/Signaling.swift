//
//  Signaling.swift
//  NxtBase
//
//  Created by mac on 09/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import Foundation

struct SignalingMessage: Codable {
    let type: String
    let offer: SDP?
    let candidate: Candidate?
    let phone: String?
    let photoUrl: String?
    let name: String?
    let connectedUserId: Int?
    let isVideo: Bool?
    let callId: String?
}

struct Available: Codable {
    let type: String
    let connectedUserId: Int?
    let isAvailable: Bool?
    let reason: String?
    let name: String?
}

struct SDP: Codable {
    let sdp: String
}

struct Candidate: Codable {
    let sdp: String
    let sdpMLineIndex: Int32
    let sdpMid: String
}
