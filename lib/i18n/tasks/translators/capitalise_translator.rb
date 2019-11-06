# frozen_string_literal: true

require 'i18n/tasks/translators/base_translator'

module I18n::Tasks::Translators
  class CapitaliseTranslator < BaseTranslator
    def initialize(*)
      super
    end

    protected

    def translate_values(list, **options)
      list.map(&:upcase)
    end

    def options_for_translate_values(from:, to:, **options)
      options
    end

    def options_for_html
      { html: true }
    end

    def options_for_plain
      { format: 'text' }
    end

    def no_results_error_message
      "SORRY COULDN'T CAPITALISE THIS!"
    end
  end
end
