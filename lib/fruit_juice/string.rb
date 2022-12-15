# frozen_string_literal: true

module FruitJuiceString
  refine String do

    def camelize(uppercase_first_letter = true)
      string = self
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
      else
        string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
      end
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::")
    end

    def underscore
      camel_cased_word = self
      return camel_cased_word.to_s unless /[A-Z-]|::/.match?(camel_cased_word)
      word = camel_cased_word.to_s
      word.gsub!(/([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) { ($1 || $2) << "_" }
      word.tr!("-", "_")
      word.downcase!
      word
    end

  end
end
