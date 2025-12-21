//
//  ADRListRouter.swift
//  AIChoro
//
//  Created by 川村周也 on 2025/12/21.
//

import SwiftUI

@Observable
final class ADRListRouter {
    private(set) var path = NavigationPath()

    func pathBinding() -> Binding<NavigationPath> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    func setPath(path: NavigationPath) {
        self.path = path
    }

    func present(route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
