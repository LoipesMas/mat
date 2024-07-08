import gleam/bool.{guard}
import gleam/dynamic
import gleam/result
import gleam/string

fn default_converter(value: a) -> String {
  let dyn_val = dynamic.from(value)
  use <- guard(
    when: dynamic.classify(dyn_val) == "Function",
    return: "<function>",
  )
  case dynamic.string(dyn_val) {
    Error(_) -> string.inspect(value)
    Ok(v) -> v
  }
}

pub fn format1(template: String, a) -> Result(String, Nil) {
  use #(f, rest) <- result.map(inner_format_once(template, a, default_converter))
  f <> rest
}

pub fn format2(template: String, a, b) -> Result(String, Nil) {
  use #(f1, rest) <- result.try(inner_format_once(
    template,
    a,
    default_converter,
  ))
  use #(f2, rest) <- result.try(inner_format_once(rest, b, default_converter))
  Ok(f1 <> f2 <> rest)
}

pub fn format3(template: String, a, b, c) -> Result(String, Nil) {
  use #(f1, rest) <- result.try(inner_format_once(
    template,
    a,
    default_converter,
  ))
  use #(f2, rest) <- result.try(inner_format_once(rest, b, default_converter))
  use #(f3, rest) <- result.try(inner_format_once(rest, c, default_converter))
  Ok(f1 <> f2 <> f3 <> rest)
}

pub fn format4(template: String, a, b, c, d) -> Result(String, Nil) {
  use #(f1, rest) <- result.try(inner_format_once(
    template,
    a,
    default_converter,
  ))
  use #(f2, rest) <- result.try(inner_format_once(rest, b, default_converter))
  use #(f3, rest) <- result.try(inner_format_once(rest, c, default_converter))
  use #(f4, rest) <- result.try(inner_format_once(rest, d, default_converter))
  Ok(f1 <> f2 <> f3 <> f4 <> rest)
}

pub fn format5(template: String, a, b, c, d, e) -> Result(String, Nil) {
  use #(f1, rest) <- result.try(inner_format_once(
    template,
    a,
    default_converter,
  ))
  use #(f2, rest) <- result.try(inner_format_once(rest, b, default_converter))
  use #(f3, rest) <- result.try(inner_format_once(rest, c, default_converter))
  use #(f4, rest) <- result.try(inner_format_once(rest, d, default_converter))
  use #(f5, rest) <- result.try(inner_format_once(rest, e, default_converter))
  Ok(f1 <> f2 <> f3 <> f4 <> f5 <> rest)
}

fn inner_format_once(
  template: String,
  value: a,
  converter: fn(a) -> String,
) -> Result(#(String, String), Nil) {
  use #(pre, rest) <- result.map(string.split_once(template, "{}"))
  #(pre <> converter(value), rest)
}

pub fn format_list(template: String, values: List(a)) -> Result(String, Nil) {
  inner_format(template, values, default_converter)
}

fn inner_format(template: String, values: List(a), converter: fn(a) -> String) {
  case values {
    [] ->
      case string.contains(template, "{}") {
        True -> Error(Nil)
        False -> Ok(template)
      }
    [value, ..rest] -> {
      use #(pre, post) <- result.try(string.split_once(template, "{}"))
      inner_format(pre <> converter(value) <> post, rest, converter)
    }
  }
}
