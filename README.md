# T12r

[![Build Status](https://travis-ci.org/data-axle/t12r.svg?branch=master)](https://travis-ci.org/data-axle/t12r)

T12r (or Transliterator) is a speedup and enhancement for the [`i18n` gem](https://rubygems.org/gems/i18n)'s
`I18n.transliterate` method, using a Rust-based native extension. It supports more characters
out-of-the-box.

## Requirements

* Ruby ≥ 2.3 (built with shared libraries)
* [Rust](http://www.rust-lang.org/) (if you build from source)

If you're using t12r on OSX without Rust installed, please note that the prebuilt binaries are built
with the following xcode versions:

* OSX 10.11: xcode 8.0
* OSX 10.12: xcode 8.1

## Usage

To speed up existing calls to `I18n.transliterate`, add this `gem` line to your `Gemfile`, after you
declare `gem 'i18n'`:

```ruby
gem 't12r', require: 't12r/i18n_monkeypatch'
```

To only use `T12r.transliterate` directly, omit the `require` argument.

### Example

```ruby
> T12r.transliterate('…yes?')
=> '...yes?'
> T12r.transliterate('Input string…', ' ' => '-')
=> 'Input-string...'
```

# Legal

This project is copyrighted by Infogroup, under the terms of the Apache License (version 2.0). See
`LICENSE` for details.
