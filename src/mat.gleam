import gleam/bool.{guard}
import gleam/dynamic
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

pub fn format1(template: String, a) -> String {
  let #(f, rest) = inner_format_once(template, a, default_converter)
  f <> rest
}

pub fn format2(template: String, a, b) -> String {
  let #(f1, rest) = inner_format_once(template, a, default_converter)
  let #(f2, rest) = inner_format_once(rest, b, default_converter)
  f1 <> f2 <> rest
}

pub fn format3(template: String, a, b, c) -> String {
  let #(f1, rest) = inner_format_once(template, a, default_converter)
  let #(f2, rest) = inner_format_once(rest, b, default_converter)
  let #(f3, rest) = inner_format_once(rest, c, default_converter)
  f1 <> f2 <> f3 <> rest
}

pub fn format4(template: String, a, b, c, d) -> String {
  let #(f1, rest) = inner_format_once(template, a, default_converter)
  let #(f2, rest) = inner_format_once(rest, b, default_converter)
  let #(f3, rest) = inner_format_once(rest, c, default_converter)
  let #(f4, rest) = inner_format_once(rest, d, default_converter)
  f1 <> f2 <> f3 <> f4 <> rest
}

pub fn format5(template: String, a, b, c, d, e) -> String {
  let #(f1, rest) = inner_format_once(template, a, default_converter)
  let #(f2, rest) = inner_format_once(rest, b, default_converter)
  let #(f3, rest) = inner_format_once(rest, c, default_converter)
  let #(f4, rest) = inner_format_once(rest, d, default_converter)
  let #(f5, rest) = inner_format_once(rest, e, default_converter)
  f1 <> f2 <> f3 <> f4 <> f5 <> rest
}

fn inner_format_once(
  template: String,
  value: a,
  converter: fn(a) -> String,
) -> #(String, String) {
  case string.split_once(template, "{}") {
    Ok(#(pre, post)) -> #(pre <> converter(value), post)
    Error(Nil) -> #(template, "")
  }
}

pub fn format_list(template: String, values: List(a)) -> String {
  inner_format(template, values, default_converter)
}

fn inner_format(template: String, values: List(a), converter: fn(a) -> String) {
  case values {
    [] -> template
    [value, ..rest] -> {
      case string.split_once(template, "{}") {
        Ok(#(pre, post)) ->
          pre <> converter(value) <> inner_format(post, rest, converter)
        Error(Nil) -> template
      }
    }
  }
}
