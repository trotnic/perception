//
//  SUEmojiTextField.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 8.03.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

#if os(iOS)
import UIKit
import SwiftUI

private class EmojiTextField: UITextField {

    // required for iOS 13
    override var textInputContextIdentifier: String? { "" }

    override var textInputMode: UITextInputMode? {
        UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(inputModeDidChange),
                name: UITextInputMode.currentInputModeDidChangeNotification,
                object: nil
            )
    }

    @objc func inputModeDidChange(_ notification: Notification) {
        guard isFirstResponder else { return }

        DispatchQueue.main.async { [weak self] in
            self?.reloadInputViews()
        }
    }
}

public struct SUEmojiTextField: UIViewRepresentable {

    @Binding private var text: String
    private let commitCallback: () -> Void

    public init(
        text: Binding<String>,
        commit: @escaping () -> Void
    ) {
        _text = text
        commitCallback = commit
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, commit: commitCallback)
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = EmojiTextField()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = context.coordinator
        view.text = text
        view.textAlignment = .center

        return view
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {}

    public final class Coordinator: NSObject, UITextFieldDelegate {

        @Binding private var text: String
        private let commitCallback: () -> Void

        init(
            text: Binding<String>,
            commit: @escaping () -> Void
        ) {
            _text = text
            commitCallback = commit
        }

        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            true
        }

        public func textFieldDidChangeSelection(_ textField: UITextField) {
            textField.text.flatMap { text in
                if text.count > 1,
                   let lastEmoji = textField.text?.last {
                    self.text = String(lastEmoji)
                    textField.text = String(lastEmoji)
                } else {
                    self.text = text
                }
            }
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            commitCallback()
        }
    }
}

struct SUEmojiTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SUColorStandartPalette.background
                .ignoresSafeArea()
            SUEmojiTextField(text: .constant("❤️"), commit: {})
                .background(.blue.opacity(0.2))
                .frame(width: 24.0, height: 24.0)
                .padding(.zero)
                .opacity(0.2)
        }
    }
}

#endif
