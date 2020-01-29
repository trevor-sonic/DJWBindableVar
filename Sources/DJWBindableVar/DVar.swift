//
//  DVar.swift
//  Dynamic Bindable Variable
//
//  Created by dejaWorks on 13/09/2018.
//  Copyright © 2018 dejaWorks. All rights reserved.
//

import Foundation


/// Dynamic Bindable Variable
open class DVar<T>{
    public typealias VarHandler    = (T) -> ()
    
    
    /// Listener handler
    private var listener: VarHandler?
    private var listeners = [String: VarHandler]()
    private var _value: T
    // MARK: - Init
    /// Initialiser of the dynamic variable
    public init(_ value: T) { self._value = value }
    
    /// Value of the bond variable.
    public var value: T {
        set {
            self._value = newValue
            if listener != nil{
                notify()
            }else if listeners.count > 0 {
                notifyAll()
            }
        }
        get{
            return _value
        }
    }
    /// Set without sending any notification
    func silentSet(_ value:T){
        self._value = value
    }
    
    // MARK: - Deinit
    deinit{
        reset()
        //print("deinit \(T.self)")
    }
    /// Unbind the variable
    public func reset(){
        listener = nil
        listeners.removeAll()
    }
    public func unbind(id:String){
        if let index = listeners.index(forKey: id){
            listeners.remove(at: index)
        }
    }
    
    // MARK: - Single
    /// Single: Bind the variable and notify for the updates
    public func bind(_ listener: VarHandler?) { self.listener = listener }
    
    /// Single: Set + Bind the variable and notify for the updates
    public func bindAndSet(_ listener: VarHandler?) {
        self.listener = listener
        listener?(value)
    }
    /// Single: Notify bond UI element
    public func notify() {
        listener?(value)
    }
    
    /// Multi: Set +  Bind with ID with wich you can unbind.
    public func multiBindAndSet(_ listener: VarHandler?, id:String) {
        listeners[id] = listener
        notifyBound(id: id)
        #if DEBUG
        //print("New multi bind:\(multiBondDetails)")
        #endif
    }
    /// Multi: Bind with ID with wich you can unbind.
    public func multiBind(_ listener: VarHandler?, id:String) {
        listeners[id] = listener
    }
    /// Multi: Notify all bond UIs
    public func notifyAll() {
        listeners.forEach({ $0.value(value) })
    }
    /// Multi: Notify all bond UIs
    public func notifyBound(id:String) {
        //Global.mainAsync ({ [weak self] in
          //  self?.listeners[id]?(self!.value)
        //})
        listeners[id]?(value)
    }
    // MARK: - Debug tool
    /// Connection details. If  multi bind used as binding method
    public var multiBondDetails:[String]{
        let desc = listeners.map { key, value -> String in
            return key
        }
        return desc
    }
    
    /// Is variable connected to any UI. If single bind used as binding method
    public var isBondAsSingle:Bool{return listener == nil ? false:true}
}
