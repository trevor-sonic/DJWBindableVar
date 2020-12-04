//
//  BVar.swift
//  Common use Bindable Variable
//
//  Created by dejaWorks on 29/11/2020.
//

import Foundation

/// Dynamic Bindable Variable
open class BVar<T:Equatable>{
    public typealias VarHandler    = (T) -> ()
    
    /// Listener handler
    private var listenerRemote: VarHandler?
    private var listenerLocal: VarHandler?
    private var _value: T
    

    // MARK: - Init
    /// Initialiser of the dynamic variable
    public init (_ value: T) { self._value = value }
    // MARK: - Deinit
    deinit{
        reset()
    }
    /// Unbind the variable
    public func reset(){
        listenerRemote = nil
        listenerLocal = nil
    }
    
    // MARK: - Set
    /// Value of the bond variable.
    public var value: T {
        set {
            if self._value != newValue {
                self._value = newValue
                listenerLocal?(value)
                listenerRemote?(value)
            }
        }
        get{
            return _value
        }
    }
    /// Set without sending any notification
    public func silentSet(_ value:T){
        self._value = value
    }
    
    // MARK: - Remote
    /// Single: Bind the variable and notify for the updates
    public func bind(_ listener: VarHandler?) { self.listenerRemote = listener }
    
    /// Bind remote
    /// Single: Set + Bind the variable and notify for the updates
    public func bindAndSet(_ listener: VarHandler?) {
        self.listenerRemote = listener
        listener?(value)
    }
    
    // MARK: - Local
    /// Self local binder UI (the where variable set and change)
    /// use this for the sender object to receive value back
    public func bindLocal(_ listener: VarHandler?) {
        self.listenerLocal = listener
    }
    
    
}
