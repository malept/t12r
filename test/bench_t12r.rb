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
require 't12r'
require 'minitest/autorun'
require 'minitest/benchmark'

CUSTOM_TRANSLATIONS = {
  "\u00b0" => 'degrees',
  "\u2665" => 'Heart',
  "\u00b2" => '2',
  "\u00b3" => '3'
}.freeze
TO_TRANSLITERATE_UNREALISTIC = (CUSTOM_TRANSLATIONS.keys.join + "\u2018\u2019\u201C\u00a2abc") * 20
TO_TRANSLITERATE_REALISTIC = 'Introducing: Slurm® Latté—Even more highly addictive!'
TO_TRANSLITERATE_NOOP = <<EOT
"The time has come," the Walrus said,
"To talk of many things:
Of shoes--and ships--and sealing-wax--
Of cabbages--and kings--
And why the sea is boiling hot--
And whether pigs have wings."
EOT

I18n.backend.store_translations(:en, i18n: { transliterate: { rule: CUSTOM_TRANSLATIONS } })

class BenchmarkEscapeHstore < Minitest::Benchmark
  # Override self.bench_range or default range is [1, 10, 100, 1_000, 10_000]

  def bench_activesupport_transliterate_unrealistic
    i18n_benchmark(TO_TRANSLITERATE_UNREALISTIC)
  end

  def bench_t12r_transliterate_unrealistic
    t12r_benchmark(TO_TRANSLITERATE_UNREALISTIC)
  end

  def bench_activesupport_transliterate_realistic
    i18n_benchmark(TO_TRANSLITERATE_REALISTIC)
  end

  def bench_t12r_transliterate_realistic
    t12r_benchmark(TO_TRANSLITERATE_REALISTIC)
  end

  def bench_activesupport_transliterate_noop
    i18n_benchmark(TO_TRANSLITERATE_NOOP)
  end

  def bench_t12r_transliterate_noop
    t12r_benchmark(TO_TRANSLITERATE_NOOP)
  end

  private

    def i18n_benchmark(input)
      assert_performance_linear 0.001 do
        1000.times do # Double inner loop for smaller numbers
          100.times do
            I18n.transliterate(input)
          end
        end
      end
    end

    def t12r_benchmark(input)
      assert_performance_linear 0.001 do
        1000.times do # Double inner loop for smaller numbers
          100.times do
            T12r.transliterate(input, CUSTOM_TRANSLATIONS)
          end
        end
      end
    end
end
