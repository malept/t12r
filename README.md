# T12r

T12r (or Transliterator) is a speedup and enhancement for the `i18n` gem's `I18n.transliterate`
method, using a Rust-based native extension. It supports more characters out-of-the-box.

## Requirements

* Ruby ≥ 2.3 (built with shared libraries)
* [Rust](http://www.rust-lang.org/) (if you build from source)

## Usage

To speed up existing calls to `I18n.transliterate`, add this `gem` line to your `Gemfile`, after you
declare `gem 'i18n'`:

```ruby
gem 't12r', require: 't12r/i18n_monkeypatch'
```

# Legal

This project is copyrighted by Infogroup, under the terms of the Apache License (version 2.0). See
`LICENSE` for details.
