import SwiftUI

public protocol Bindable {
    associatedtype Action
    associatedtype Property

    var binder: Binder { get }
}

extension Bindable where Self: View, Property: ObservableObject & Identifiable {
    public func bind<Content>(
        _ id: Property.ID,
        @ViewBuilder _ build: @escaping (AnyViewModel<Property, Action>) -> Content
    ) -> PropertyBinding<Property, Action, Content> where Content: View {
        binder.bind(Property.self, Action.self, id, build)
    }
}

extension Bindable where Self: View, Property: ObservableObject & Identifiable, Property.ID == Singleton {
    public func bind<Content>(
        @ViewBuilder _ build: @escaping (AnyViewModel<Property, Action>) -> Content
    ) -> PropertyBinding<Property, Action, Content> where Content: View {
        binder.bind(Property.self, Action.self, Singleton(), build)
    }
}
