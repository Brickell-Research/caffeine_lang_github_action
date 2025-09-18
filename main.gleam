import argv
import caffeine_lang/compiler
import gleam/io

fn print_usage() -> Nil {
  io.println("Caffeine SLI/SLO compiler")
  io.println("")
  io.println("Usage:")
  io.println(
    "  caffeine compile <specification_directory> <instantiation_directory>",
  )
  io.println("")
  io.println("Arguments:")
  io.println(
    "  specification_directory   Directory containing specification files",
  )
  io.println(
    "  instantiation_directory   Directory containing instantiation files",
  )
}

pub fn main() -> Nil {
  let args = argv.load().arguments

  case args {
    ["compile", spec_dir, inst_dir] -> {
      compiler.compile(spec_dir, inst_dir)
    }
    ["compile"] -> {
      io.println_error("Error: compile command requires 2 arguments")
      print_usage()
    }
    ["compile", ..] -> {
      io.println_error("Error: compile command requires exactly 2 arguments")
      print_usage()
    }
    ["--help"] | ["-h"] | [] -> {
      print_usage()
    }
    _ -> {
      io.println_error("Error: unknown command")
      print_usage()
    }
  }
}
