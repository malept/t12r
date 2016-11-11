# frozen_string_literal: true
#
# Copyright 2016 Infogroup, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'active_support/i18n'
require 't12r/rusty_transliterator'
require 'minitest/autorun'

CUSTOM_TRANSLATIONS = {
  "\u00b0" => 'degrees',
  "\u2665" => 'Heart',
  "\u00b2" => '2',
  "\u00b3" => '3'
}.freeze
I18n.backend.store_translations(:en, i18n: { transliterate: { rule: CUSTOM_TRANSLATIONS } })

class T12rTest < Minitest::Test
  def test_equivalent_output
    input = "-273\u00b0 C est également connu comme zéro absolu"
    expected = '-273degrees C est egalement connu comme zero absolu'
    assert_equal expected, I18n.transliterate(input)
    t12r = T12r::RustyTransliterator.new(CUSTOM_TRANSLATIONS.dup)
    assert_equal expected, t12r.transliterate(input)
  end

  def test_hash_transliterator_equivalency
    approximations = I18n::Backend::Transliterator::HashTransliterator::DEFAULT_APPROXIMATIONS.dup
    input = approximations.keys.join("\n")
    expected = approximations.values.join("\n")
    assert_equal expected, I18n.transliterate(input)
    t12r = T12r::RustyTransliterator.new
    assert_equal expected, t12r.transliterate(input)
  end
end
