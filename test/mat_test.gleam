import gleam/dict.{type Dict}
import gleeunit
import gleeunit/should

import mat

pub fn main() {
  gleeunit.main()
}

pub fn empty_test() {
  mat.format_list("", [])
  |> should.equal(Ok(""))
}

pub fn no_template_test() {
  mat.format_list("foo", [])
  |> should.equal(Ok("foo"))
}

pub fn one_template_test() {
  mat.format_list("{}", ["bar"])
  |> should.equal(Ok("bar"))
}

pub fn two_template_test() {
  mat.format_list("{} something {}", ["bar", "baz"])
  |> should.equal(Ok("bar something baz"))
}

pub fn not_enough_values_test() {
  mat.format_list("{} something {} and {}", ["bar", "baz"])
  |> should.equal(Error(Nil))
}

pub fn too_many_values_test() {
  mat.format_list("just {}", ["bar", "baz"])
  |> should.equal(Error(Nil))
}

pub fn incorrect_template_test() {
  mat.format_list("just {wrong}", ["bar"])
  |> should.equal(Error(Nil))
}

pub fn incorrect_template_no_values_test() {
  mat.format_list("just {wrong}", [])
  |> should.equal(Ok("just {wrong}"))
}

pub fn bracket_not_closed_test() {
  mat.format_list("open {", [])
  |> should.equal(Ok("open {"))
}

pub fn bracket_not_open_test() {
  mat.format_list("} close", [])
  |> should.equal(Ok("} close"))
}

pub fn list_of_int_test() {
  mat.format_list("this is a list of ints: {}", [[1, 2, 3]])
  |> should.equal(Ok("this is a list of ints: [1, 2, 3]"))
}

pub fn list_of_string_test() {
  mat.format_list("this is a list of strings: {}", [["foo", "bar"]])
  |> should.equal(Ok("this is a list of strings: [\"foo\", \"bar\"]"))
}

type MyType {
  TypeA
  TypeB(alpha: Int, beta: Dict(String, Int))
}

pub fn mytype_a_test() {
  mat.format_list("{}", [TypeA])
  |> should.equal(Ok("TypeA"))
}

pub fn mytype_b_test() {
  mat.format_list("{}", [TypeB(42, dict.from_list([#("a", 1337)]))])
  |> should.equal(Ok("TypeB(42, dict.from_list([#(\"a\", 1337)]))"))
}

pub fn function_test() {
  mat.format_list("{}", [dict.new])
  |> should.equal(Ok("<function>"))
}

pub fn result_ok_test() {
  mat.format_list("{}", [Ok(1)])
  |> should.equal(Ok("Ok(1)"))
}

pub fn result_err_test() {
  mat.format_list("{}", [Error(Nil)])
  |> should.equal(Ok("Error(Nil)"))
}

pub fn list_of_list_test() {
  mat.format_list("{}", [[[]]])
  |> should.equal(Ok("[[]]"))
}

pub fn format_1_correct_test() {
  mat.format1("{}", 42)
  |> should.equal(Ok("42"))
}

pub fn format_1_empty_test() {
  mat.format1("oops", 42)
  |> should.equal(Error(Nil))
}

pub fn format_1_two_templates_test() {
  mat.format1("{} {}", 42)
  |> should.equal(Ok("42 {}"))
}

pub fn format_1_brackets_val_test() {
  mat.format1("{}", "{}")
  |> should.equal(Ok("{}"))
}

pub fn format_2_correct_test() {
  mat.format2("{} {}", 42, "foo")
  |> should.equal(Ok("42 foo"))
}

pub fn format_2_empty_test() {
  mat.format2("oops", 42, "foo")
  |> should.equal(Error(Nil))
}

pub fn format_2_one_template_test() {
  mat.format2("{} not enough", 42, "foo")
  |> should.equal(Error(Nil))
}

pub fn format_2_prefix_test() {
  mat.format2("pre {} {}", 42, "foo")
  |> should.equal(Ok("pre 42 foo"))
}

pub fn format_2_suffix_test() {
  mat.format2("{} {} suff", 42, "foo")
  |> should.equal(Ok("42 foo suff"))
}

pub fn format_2_infix_test() {
  mat.format2("{} in {}", 42, "foo")
  |> should.equal(Ok("42 in foo"))
}

pub fn format_2_brackets_val_test() {
  mat.format2("{} {} rest", "{}", "{}")
  |> should.equal(Ok("{} {} rest"))
}

pub fn format_2_brackets_val_2_test() {
  mat.format2("{} {} rest", "{}", "foo")
  |> should.equal(Ok("{} foo rest"))
}

pub fn format_2_brackets_val_3_test() {
  mat.format2("{} {} rest", "foo", "{}")
  |> should.equal(Ok("foo {} rest"))
}

pub fn format_3_correct_test() {
  mat.format3("{} {} {}", 42, "foo", [])
  |> should.equal(Ok("42 foo []"))
}

pub fn format_3_empty_test() {
  mat.format3("oops", 42, "foo", [])
  |> should.equal(Error(Nil))
}

pub fn format_3_one_template_test() {
  mat.format3("{} not enough", 42, "foo", [])
  |> should.equal(Error(Nil))
}

pub fn format_3_two_template_test() {
  mat.format3("{} {} not enough", 42, "foo", [])
  |> should.equal(Error(Nil))
}

pub fn format_3_prefix_test() {
  mat.format3("pre {} {} {}", 42, "foo", [])
  |> should.equal(Ok("pre 42 foo []"))
}

pub fn format_3_suffix_test() {
  mat.format3("{} {} {} suff", 42, "foo", [])
  |> should.equal(Ok("42 foo [] suff"))
}

pub fn format_3_infix_test() {
  mat.format3("{} in {} in2 {}", 42, "foo", [])
  |> should.equal(Ok("42 in foo in2 []"))
}

pub fn format_4_correct_test() {
  mat.format4("a {} b {} c {} d {}.", 1, 2, 3, 4)
  |> should.equal(Ok("a 1 b 2 c 3 d 4."))
}

pub fn format_4_incorrect_test() {
  mat.format4("a {} b {} c {} d ", 1, 2, 3, 4)
  |> should.equal(Error(Nil))
}

pub fn format_5_correct_test() {
  mat.format5("a {} b {} c {} d {} e {}.", 1, 2, 3, 4, 5)
  |> should.equal(Ok("a 1 b 2 c 3 d 4 e 5."))
}

pub fn format_5_incorrect_test() {
  mat.format5("a {} b {} c {} d {}", 1, 2, 3, 4, 5)
  |> should.equal(Error(Nil))
}
