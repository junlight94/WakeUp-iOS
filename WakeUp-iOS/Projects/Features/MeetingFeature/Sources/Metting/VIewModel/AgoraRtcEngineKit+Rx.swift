//
//  AgoraRtcEngineKit+Rx.swift
//  MeetingFeature
//
//  Created by 강현준 on 2023/09/04.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import BaseFeatureDependency
import AVFoundation
import AgoraRtcKit
import Foundation
import RxCocoa
import RxSwift

enum AgoraRtcRxError: Error {
    case localInvokeError
    case agoraError(AgoraErrorCode)
}

extension AgoraErrorCode: LocalizedError {
    fileprivate var isCommonError: Bool {
        return (rawValue > 0 && rawValue < 5) || rawValue == 10 || rawValue == 7
    }
    
    public var errorDescription: String? {
        return "AgoraErrorCode \(self.rawValue)"
    }
}

extension Reactive where Base: AgoraRtcEngineKit {
    var delegate: AgoraRtcEngineDelegateProxy {
        return AgoraRtcEngineDelegateProxy.proxy(for: base)
    }
 
    func leaveChannel() -> Observable<AgoraChannelStats> {
        let success = delegate.didLeaveChannelSubject.asObserver().take(1)
        let error = delegate.didOccurErrorSubject.asObserver()
            .filter { $0.isCommonError || $0 == .leaveChannelRejected || $0 == .invalidChannelId }
            .take(1)
            .flatMap { error -> Observable<AgoraChannelStats> in
                Observable.error(AgoraRtcRxError.agoraError(error))
            }
        
        return engineInvoke(onSuccess: success, onError: error) {
            self.base.leaveChannel(nil)
        }
    }
    
    func didJoinedOfUid() -> Observable<UInt> {
        return delegate.methodInvoked(#selector(AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:)))
            .map { a in
                try castOptionalOrThrow(UInt.self, a[1])
            }
    }
    
    
    func didOfflineOfUid() -> Observable<UInt> {
        return delegate.methodInvoked(#selector(AgoraRtcEngineDelegate.rtcEngine(_:didOfflineOfUid:reason:)))
            .map { a in
                try castOptionalOrThrow(UInt.self, a[1])
            }
    }
    
    func reportAudioVolumeIndicationOfSpeakers() -> Observable<[AgoraRtcAudioVolumeInfo]> {
        return delegate.methodInvoked(#selector(AgoraRtcEngineDelegate.rtcEngine(_:reportAudioVolumeIndicationOfSpeakers:totalVolume:)))
            .map { a in
                try castOptionalOrThrow([AgoraRtcAudioVolumeInfo].self, a[1])
            }
    }
}

private func engineInvoke<T>(onSuccess: Observable<T>, onError: Observable<T>, method: @escaping (() -> Int32)) -> Observable<T> {
    return Observable<T>.create { (observer) -> Disposable in
        guard method() == 0 else {
            observer.onError(AgoraRtcRxError.localInvokeError)
            return Disposables.create()
        }
        
        let disposable = onSuccess.amb(onError).subscribe(observer)
        
        return Disposables.create {
            disposable.dispose()
        }
    }
}

    /// object인자를 T타입으로 변환해서 해당 object인자만 리턴해줌
private func castOptionalOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}
