import SwiftUI
import Introspect

public struct RefreshableScrollView<Content: View>: View {
    class ViewModel: ObservableObject {
        weak var refreshControl: UIRefreshControl?
        var onRefresh: (@escaping () -> Void) -> Void
        
        init(onRefresh: @escaping (@escaping () -> Void) -> Void) {
            self.onRefresh = onRefresh
        }
        
        @objc func refreshContent(_ sender: UIRefreshControl) {
            onRefresh { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        }
        
        func endRefreshing() {
            refreshControl?.endRefreshing()
        }
    }
    
    @State private var isShowing = false
    @ObservedObject var viewModel: ViewModel
    var content: Content
    
    public init(@ViewBuilder content: () -> Content, onRefresh: @escaping (@escaping () -> Void) -> Void) {
        self.content = content()
        self.viewModel = .init(onRefresh: onRefresh)
    }
    
    public var body: some View {
        ScrollView {
            content
        }
        .introspectScrollView { scrollView in
            if self.viewModel.refreshControl != nil { return }
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self.viewModel, action: #selector(self.viewModel.refreshContent(_:)), for: .valueChanged)
            scrollView.refreshControl = refreshControl
            self.viewModel.refreshControl = refreshControl
        }
    }
}
