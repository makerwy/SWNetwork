//
//  SWNetwork+JSON.swift
//  SWNetwork
//
//  Created by wangyang on 2020/12/31.
//

import Foundation
import KakaJSON
import RxSwift
import Moya

extension Response {
    ///JSON -> Model
    func mapObject<T: Convertible>(_ type: T.Type) throws -> T {
        guard let object = data.kj.model(type) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    ///JSON -> [Model]
    func mapArray<T: Convertible>(_ type: T.Type) throws -> [T] {
        guard let array = try mapJSON() as? [[String: Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        return array.kj.modelArray(type)
    }
    
    /// JSON -> Model
    func mapObject<T: Convertible>(_ type: T.Type, atKeyPath keyPath: String) throws -> T {
        guard let object = ((try mapJSON() as? NSDictionary)?.value(forKeyPath: keyPath) as? NSDictionary)?.kj.model(type) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    /// JSON -> [Model]
    func mapArray<T: Convertible>(_ type: T.Type, atKeyPath keyPath: String) throws -> [T] {
        guard let array = (try mapJSON() as? NSDictionary)?.value(forKeyPath: keyPath) as? [[String: Any]] else {
            throw MoyaError.jsonMapping(self)
        }
        return array.kj.modelArray(type)
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    /// JSON -> Model
    func mapObject<T: Convertible>(_ type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            Single.just(try response.mapObject(type))
        }
    }
    /// JSON -> ModelArray
    func mapArray<T: Convertible>(_ type: T.Type) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            Single.just(try response.mapArray(type))
        }
    }
    /// JSON -> Model
    func mapObject<T: Convertible>(_ type: T.Type, atKeyPath keyPath: String) -> Single<T> {
        return flatMap { response -> Single<T> in
            Single.just(try response.mapObject(type, atKeyPath: keyPath))
        }
    }
    /// JSON -> ModelArray
    func mapArray<T: Convertible>(_ type: T.Type, atKeyPath keyPath: String) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            Single.just(try response.mapArray(type, atKeyPath: keyPath))
        }
    }
}

public extension ObservableType where E == Response {
    /// JSON -> Model
    func mapObject<T: Convertible>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.just(try response.mapObject(type))
        }
    }
    /// JSON -> ModelArray
    func mapArray<T: Convertible>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.just(try response.mapArray(type))
        }
    }
    /// JSON -> Model
    func mapObject<T: Convertible>(_ type: T.Type, atKeyPath keyPath: String) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            Observable.just(try response.mapObject(type, atKeyPath: keyPath))
        }
    }
    /// JSON -> ModelArray
    func mapArray<T: Convertible>(_ type: T.Type, atKeyPath keyPath: String) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            Observable.just(try response.mapArray(type, atKeyPath: keyPath))
        }
    }
}
