import SwiftUI

public protocol Bindable {
    associatedtype Action
    associatedtype Prop

    var binder: Binder { get }
}

extension Bindable where Self: View, Prop: ObservableObject & Identifiable {
    public func bind<Content>(
        _ id: Prop.ID,
        @ViewBuilder _ build: @escaping (AnyViewModel<Prop, Action>) -> Content
    ) -> PropBinding<Prop, Action, Content> where Content: View {
        binder.bind(Prop.self, Action.self, id, build)
    }
}

extension Bindable where Self: View, Prop: ObservableObject & Identifiable, Prop.ID == Singleton {
    public func bind<Content>(
        @ViewBuilder _ build: @escaping (AnyViewModel<Prop, Action>) -> Content
    ) -> PropBinding<Prop, Action, Content> where Content: View {
        binder.bind(Prop.self, Action.self, Singleton(), build)
    }
}
