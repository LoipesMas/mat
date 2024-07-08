# mat

*It's easy for `mat` to format strings!*

[![Package Version](https://img.shields.io/hexpm/v/mat)](https://hex.pm/packages/mat)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/mat/)

`mat` is a gleam library for simple string formatting.

It's goals is easy and ergonomic formatting of any values.

```sh
gleam add mat
```

```gleam
import mat
import gleam/io

pub fn main() {
  mat.format2("This is hello from {}! The answer is {}", "Mat", 42)
  |> io.println
}
```
It formats any variable type: `String`, `Int`, `List`, your own types, etc.!

`mat` is also fault-tolerant. It will do it's best with what it's given.

Too many variables? Ignore the rest.
Not enough variables? Leave the placeholders in.


This means that you don't have to handle any `Result`s.
This makes it convenient for prototyping or for cases where you don't care about the output that much (for example logs)

If you're looking for more robust formatting, with type-safety, check out <https://github.com/mooreryan/gleam_fmt>.

## Limitations

Because `mat` is just a gleam library, there are some limitations on the ergonomics front.

Since you can't have heterogeneous lists or a variable amount of arguments, you have to either:

1. Use correct function, e.g. `format3` if you have 3 variables
2. Convert all your arguments to `dynamic`s and use that with `format_list`

Of course, if all your variables are of the same type, you can simple use `format_list` with a list of that type.

Functions are currently rendered as `<function>`, because I haven't yet found a way to get information about a function.

Further documentation can be found at <https://hexdocs.pm/mat>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
