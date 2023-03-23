import SwiftUI

public final class Binder: ObservableObject {
    private var registration = [Key :() -> Any]()

    public init() {
    }

    public func register<VM>(_ viewModel: @autoclosure @escaping () -> VM) -> Binder where VM: ViewModel {
        registration[Key(idType: VM.Id.self, propertyType: VM.Prop.self, actionType: VM.Action.self)] = { viewModel().typeErased }
        return self
    }

    public func resolve<Id, Prop, Action>(_: Id.Type, _: Prop.Type, _: Action.Type) -> AnyViewModel<Id, Prop, Action> {
        let key = Key(idType: Id.self, propertyType: Prop.self, actionType: Action.self)
        switch registration[key] {
        case let .some(viewModel):
            return viewModel() as! AnyViewModel<Id, Prop, Action>
        case .none:
            fatalError("View model is not registered: Prop == \(Prop.self), Action == \(Action.self)")
        }
    }

    @discardableResult
    public func bind<Id, Prop, Action, Content>(
        _: Prop.Type,
        _: Action.Type,
        _ id: Id,
        @ViewBuilder _ build: @escaping (AnyViewModel<Id, Prop, Action>) -> Content
    ) -> PropBinding<Id, Prop, Action, Content> where Content: View {
        let viewModel = resolve(Id.self, Prop.self, Action.self)
        viewModel.bind(to: id)
        return PropBinding(viewModel, build)
    }
}

struct Key {
    let idType: Any.Type
    let propertyType: Any.Type
    let actionType: Any.Type

    init(idType: Any.Type, propertyType: Any.Type, actionType: Any.Type) {
        self.idType = idType
        self.propertyType = propertyType
        self.actionType = actionType
    }
}

extension Key: Hashable {
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(idType).hash(into: &hasher)
        ObjectIdentifier(propertyType).hash(into: &hasher)
        ObjectIdentifier(actionType).hash(into: &hasher)
    }
}

func == (_ x: Key, _ y: Key) -> Bool {
    return
        x.idType == y.idType &&
        x.propertyType == y.propertyType &&
        x.actionType == y.actionType
}
