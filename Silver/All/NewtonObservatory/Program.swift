class Program {
  #if COOPER
  public static func main(_ args: java.lang.String[]) {
    for argument in args {
      if argument == "--explore" {
        java.lang.System.exit(Explorer.Run())
        return
      }
    }
    Observatory.Run()
  }
  #else
  public static func Main(_ args: String[]) -> Int32 {
    for argument in args {
      if argument == "--explore" {
        return Explorer.Run()
      }
    }
    Observatory.Run()
    return 0
  }
  #endif
}
