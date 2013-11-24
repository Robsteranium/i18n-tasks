# coding: utf-8
require 'terminal-table'
module I18n
  module Tasks
    module Reports
      class Terminal
        include Term::ANSIColor

        def initialize
          @task = I18n::Tasks::BaseTask.new
        end

        attr_reader :task

        def missing_translations
          recs = task.untranslated_keys
          print_title "Missing keys and translations (#{recs.length})"
          if recs.present?
            type_sym  = {
                :none    => red('✗'),
                :blank   => yellow('∅'),
                :eq_base => bold(blue('='))
            }
            type_desc = {
                :none    => 'key missing',
                :blank   => 'translation blank',
                :eq_base => 'value equals to base_locale'
            }
            $stderr.puts "#{bold 'Types:'} #{type_desc.keys.map { |k| "#{type_sym[k]} #{type_desc[k]}" } * ', '}"
            print_table headings: [bold('Locale'), bold('Type'), magenta('i18n Key'), bold(cyan "Base value (#{base_locale})")] do |t|
              t.rows = recs.map { |rec|
                if rec[:type] == :none
                  locale     = red bold rec[:locale]
                  base_value = ''
                else
                  locale     = bold rec[:locale]
                  base_value = cyan rec[:base_value].try(:strip) || ''
                end
                [locale, type_sym[rec[:type]], magenta(rec[:key]), base_value]
              }
            end
          else
            print_success 'Good job! No translations missing!'
          end
        end

        def unused_translations
          unused = task.unused_keys
          print_title "Unused i18n keys (#{unused.length})"
          if unused.present?
            print_table headings: [bold(magenta('i18n Key')), cyan("Base value (#{base_locale})")] do |t|
              t.rows = unused.map { |x| [magenta(x[0]), cyan(x[1])] }
            end
          else
            print_success 'Good job! Every translation is used!'
          end
        end

        private

        extend Term::ANSIColor

        def print_title(title)
          $stderr.puts "#{bold cyan title.strip} #{dark "|"} #{bold "i18n-tasks v#{I18n::Tasks::VERSION}"}"
        end

        def print_success(message)
          $stderr.puts(bold green message)
        end

        private
        def indent(txt, n = 2)
          spaces = ' ' * n
          txt.gsub /^/, spaces
        end

        def print_table(opts, &block)
          puts ::Terminal::Table.new(opts, &block)
        end
      end
    end
  end
end
