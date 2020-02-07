import PushCore

do {
    try Push.run()
} catch {
    print("Pushing failed: \(error)")
}
