import SwiftUI

public protocol Bindable {
    associatedtype Id
    associatedtype Action
    associatedtype Prop

    var binder: Binder { get }
}

extension Bindable where Self: View, Prop: ObservableObject {
    public func bind<Content>(
        _ id: Id,
        @ViewBuilder _ build: @escaping (AnyViewModel<Id, Prop, Action>) -> Content
    ) -> PropBinding<Id, Prop, Action, Content> where Content: View {
        binder.bind(Prop.self, Action.self, id, build)
    }
}

extension Bindable where Self: View, Id == Singleton, Prop: ObservableObject {
    public func bind<Content>(
        @ViewBuilder _ build: @escaping (AnyViewModel<Id, Prop, Action>) -> Content
    ) -> PropBinding<Id, Prop, Action, Content> where Content: View {
        binder.bind(Prop.self, Action.self, Singleton(), build)
    }
}
