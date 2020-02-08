import PoesCore

do {
    try Poes.run()
} catch {
    print("Pushing failed: \(error)")
}
