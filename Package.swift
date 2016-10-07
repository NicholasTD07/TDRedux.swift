import PackageDescription

let package = Package(
    name: "TDRedux"
)

let dylib = Product(
    name: "TDRedux",
    type: .Library(.Dynamic),
    modules: "TDRedux"
)

products.append(dylib)
