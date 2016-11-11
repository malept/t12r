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

require 't12r'

class T12r
  #
  # Transliterator for {I18n} compatible with its
  # {I18n::Backend::Transliterator::HashTransliterator}.
  #
  class RustyTransliterator
    def initialize(rule = nil)
      @rule = rule || {}
      # For compatibility with I18n
      @rule['Ŋ'] ||= 'NG'
      @rule['ŋ'] ||= 'ng'
    end

    def transliterate(string, _replacement = nil)
      T12r.transliterate(string, @rule)
    end
  end
end
