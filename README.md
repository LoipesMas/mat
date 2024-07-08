# mat

[![Package Version](https://img.shields.io/hexpm/v/mat)](https://hex.pm/packages/mat)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/mat/)

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

Further documentation can be found at <https://hexdocs.pm/mat>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
