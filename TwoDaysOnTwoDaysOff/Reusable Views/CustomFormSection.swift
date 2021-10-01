//
//  CustomFormSection.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 27.09.2021.
//

import SwiftUI

struct CustomSection<Header, Footer, Content>: View where Header: View, Footer: View, Content: View{
    var header: Header
    var footer: Footer
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack {
            header
            content()
                .padding([.horizontal], 16)
                .padding([.vertical], 10)
                .background(
                    RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white)
                )
            footer
        }
    }
    
    init(header: Header, footer: Footer, @ViewBuilder content: @escaping ()->Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }
}

extension CustomSection where Header == EmptyView {
    init(header: Header = EmptyView(), footer: Footer, @ViewBuilder content: @escaping ()->Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }
}

extension CustomSection where Footer == EmptyView {
    init(header: Header, footer: Footer = EmptyView(), @ViewBuilder content: @escaping ()->Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }
}

extension CustomSection where Header == EmptyView, Footer == EmptyView {
    init(header: Header = EmptyView(), footer: Footer = EmptyView(), @ViewBuilder content: @escaping ()->Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }
}
