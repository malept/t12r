// Copyright 2016 Infogroup, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#[macro_use]
extern crate ruru;
extern crate unidecode;

use ruru::{AnyObject, Class, Hash, NilClass, Object, RString, Symbol, VM};
use ruru::result::Error as RuruError;
use ruru::result::Result as RuruResult;
use ruru::types::ValueType;
use std::collections::HashMap;
use std::error::Error;
use unidecode::unidecode_char;

fn rusty_transliterate(input: &str, overrides: HashMap<char, String>) -> String {
    input.chars()
        .map(|chr| match overrides.get(&chr) {
            Some(replacement) => replacement,
            None => unidecode_char(chr),
        })
        .collect()
}

fn any_object_to_string(object: AnyObject) -> Result<String, RuruError> {
    let result = match object.ty() {
        ValueType::Symbol => object.try_convert_to::<Symbol>()?.to_string(),
        ValueType::RString => object.try_convert_to::<RString>()?.to_string(),
        _ => object.send("to_s", vec![]).try_convert_to::<RString>()?.to_string(),
    };

    Ok(result)
}

fn build_overrides(overrides_result: RuruResult<AnyObject>) -> HashMap<char, String> {
    let mut rusty_overrides: HashMap<char, String> = HashMap::new();
    if let Ok(overrides) = overrides_result {
        if let Ok(overrides_hash) = overrides.try_convert_to::<Hash>() {
            overrides_hash.each(|key, value| {
                if let Ok(key_string) = any_object_to_string(key) {
                    if let Some(chr) = key_string.chars().next() {
                        if let Ok(t14n_override) = value.try_convert_to::<RString>() {
                            rusty_overrides.insert(chr, t14n_override.to_string());
                        }
                    }
                }
            });
        }
    }

    rusty_overrides
}

class!(T12r);

methods!(
    T12r,
    _itself,

    fn transliterate(input_result: RString, overrides: AnyObject) -> AnyObject {
        match input_result {
            Ok(input) => {
                let rusty_overrides = build_overrides(overrides);
                RString::new(&rusty_transliterate(&input.to_string(),
                                                  rusty_overrides)).to_any_object()
            },
            Err(error) => {
                VM::raise(error.to_exception(), error.description());
                NilClass::new().to_any_object()
            }
        }
    }
);

#[no_mangle]
pub extern "C" fn init_t12r() {
    Class::new("T12r", None).define(|itself| {
        itself.def_self("transliterate", transliterate);
    });
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;
    use super::rusty_transliterate;

    #[test]
    fn no_overrides() {
        let overrides: HashMap<char, String> = HashMap::new();
        assert_eq!(rusty_transliterate("café", overrides), "cafe")
    }

    #[test]
    fn with_overrides() {
        let mut overrides: HashMap<char, String> = HashMap::new();
        overrides.insert('é', "ay".to_string());
        assert_eq!(rusty_transliterate("café", overrides), "cafay")
    }
}
