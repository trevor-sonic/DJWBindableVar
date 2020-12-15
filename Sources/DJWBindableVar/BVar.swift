//
//  BVar.swift
//  Common use Bindable Variable
//
//  Created by dejaWorks on 29/11/2020.
//

import Foundation


// MARK: - Bindable example with enum
class Examples{
    
    func something(){
        let bv1:BVar<Int> = BVar(0)
        let bv2:BVar<Int> = BVar(0)
        
        bv1.bind(.ui, andSet: true) { value in
            print(value)
        }
        
        bv2.bind(.ui, andSet: true) { value in
            print(value)
        }
        
        
        bv1.bBind(.slave, andSet: true, to: bv2)
        bv1.bBind(.slave, andSet: true, to: bv2, toBranch: .master)
        
    }
}
public enum Branch{
    case master
    
    /// ui related bindings
    case ui, ui2, ui3
    
    /// database
    case db
    
    /// to connect other main
    case slave
    
    /// for any other extra needs
    case extra, extra2, extra3
}

/// Dynamic Bindable Variable
open class BVar<T:Equatable>{
    
    public typealias VarHandler    = (T) -> Void
    private var _value: T
    

    private var listeners:[Branch:VarHandler?] = [:]
    
    // MARK: -  New version with enum
    public func bind( _ bindTo:Branch, andSet:Bool, _ listener: VarHandler? ) {
        listeners[bindTo] = listener
        if andSet { listener?(value) }
    }

    // MARK: - Bidirectional binding with enum
    /// Just binding is not making difference but bindAndSet need some care cause one is setting the other
    /// while binding so one must be master other slave
    public func bBind( _ bindTo:Branch, andSet:Bool, to bvar:BVar<T>, toBranch:Branch = .master) {
        
        bvar.bind(toBranch, andSet: false) { [weak self] value in
            self?.value = value
        }
        bind(bindTo, andSet: andSet) { value in
            bvar.value = value
        }
    }
    
    
    
    
    // MARK: - Init
    /// Initialiser of the dynamic variable
    public init (_ value: T) { self._value = value }
    // MARK: - Deinit
    deinit{
        unbindAll()
    }
    /// Unbind all variables
    public func unbindAll(){
        for (key, _) in listeners{
            listeners[key] = nil
        }
        listeners.removeAll()
    }
    public func unbind(_ bindTo:Branch){
        listeners.removeValue(forKey: bindTo)
    }
    // MARK: - Set
    /// Value of the bond variable.
    public var value: T {
        set {
            if self._value != newValue {
                
                self._value = newValue
                for (_, listener) in listeners{
                    listener?(value)
                }
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
    
}
