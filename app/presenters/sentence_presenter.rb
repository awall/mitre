# We follow the 'presenter' pattern so that we don't shove all of this presentation-specific
# logic into the model. It's also not appropriate to put it in the View, as we want this to
# be easily unit-testable, and potentially reused in the future.

class SentencePresenter
  def initialize(sentence)
    @text = sentence.text
    @entities = sentence.entities
  end

  def chunks
    # Split the string into chunks, where a chunk is either regular text, or an
    # entity.
    #
    # This is one of the few times where a regular expression is a decent
    # solution to a problem. The underlying algorithm is O(mn), where n is the
    # length of `text` and m is the # of entities.
    if @entities.empty?
      sections = [@text.strip]
    else
      sorted_entities = @entities.sort {|a, b| b.text.length <=> a.text.length }
      match_any_entity = sorted_entities.map {|entity| Regexp.quote(entity.text)}.join("|")
      regex = /(#{match_any_entity})/i
      sections = @text.split(regex).map(&:strip).reject(&:empty?)
    end

    # we call `downcase` to handle case-insensitivity
    entities_by_text = @entities.map {|entity| [entity.text.downcase, entity]}.to_h
    sections.map do |section| 
      entity = entities_by_text[section.downcase]
      if entity
        [OpenStruct.new(
          text: section,
          typ: entity.typ,
          color: color(entity.typ),
          selectable: false,
        )]
      else
        words = section.split
        words.map { |word| split_single_word(word) }.flatten
      end
    end.flatten
  end

  private

  # This could be improved substantially. This is a known and documented caveat.
  PUNCTUATION = /[\.\,\:\!\?\~\-\'\"]/

  def split_single_word(word)
    ends_with_punctuation = word.match?(/#{PUNCTUATION}$/)
    punctuation_elsewhere = word.match?(/#{PUNCTUATION}.+$/)
    all_punctuation = word.match?(/^#{PUNCTUATION}+$/)

    if all_punctuation
      [OpenStruct.new(text: word, typ: nil, color: nil, selectable: false)]
    elsif ends_with_punctuation && !punctuation_elsewhere
      parts = word.match(/^(.+)(#{PUNCTUATION}+)$/)
      non_punctuation = parts[1]
      punctuation = parts[2]
      [
        OpenStruct.new(text: non_punctuation, typ: nil, color: nil, selectable: true),
        OpenStruct.new(text: punctuation, typ: nil, color: nil, selectable: false),
      ]
    else
      [OpenStruct.new(text: word, typ: nil, color: nil, selectable: true)]
    end
  end

  def color(typ)
    # A quick-and-dirty way to provide colors for common entity types.
    # In the future, we may want to make this configurable. At that point,
    # it would make sense to introduce an `EntityType` model.
    case typ
    when "ORG"
      "cyan"
    when "MONEY"
      "lightgray"
    when "GPE"
      "beige"
    when "THEME"
      "pink"
    when "TIME"
      "yellow"
    else 
      "gray"
    end
  end
end
