//
//  Store+Subscribe.swift
//  TDRedux
//
//  Created by Nicholas Tian on 18/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

extension Store {
    func subscribe<SelectedState>(with: (selector: (State) -> SelectedState, subscriber:)
    )
}
