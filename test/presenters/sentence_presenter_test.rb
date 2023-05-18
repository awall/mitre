require "test_helper"

class SentencePresenterTest < ActiveSupport::TestCase
  test "A normal word is a chunk." do
    chunks = chunkify("find the word")
    the = chunks.find {|chunk| chunk.text == "the"}
    assert_not_nil the
  end

  test "A word is found when it's the only word." do
    chunks = chunkify("the")
    the = chunks.find {|chunk| chunk.text == "the"}
    assert_not_nil the
  end

  test "An entity is not selectable." do
    chunks = chunkify("An entity", ["entity"])
    entity = chunks.find {|chunk| chunk.text == "entity"}

    assert_equal false, entity&.selectable
  end

  test "An entity can contain multiple words." do
    chunks = chunkify("An entity", ["An entity"])
    entity = chunks.find {|chunk| chunk.text == "An entity"}

    assert_not_nil entity
  end

  test "When entities overlap, the longer one wins." do
    chunks = chunkify("An entity", ["An enti", "ity"])
    an_enti = chunks.find {|chunk| chunk.text == "An enti"}
    ity = chunks.find {|chunk| chunk.text == "ity"}

    assert_not_nil an_enti&.typ
    assert_nil ity

    chunks = chunkify("An entity", ["ity", "An enti"])
    an_enti = chunks.find {|chunk| chunk.text == "An enti"}
    ity = chunks.find {|chunk| chunk.text == "ity"}

    assert_not_nil an_enti&.typ
    assert_nil ity
  end

  test "An entity is tagged for every time it appears." do
    chunks = chunkify("I think the test tests the logic.", ["the"])
    entities = chunks.filter {|chunk| chunk.typ}

    assert_equal 2, entities.size
  end

  test "Entity tagging is case insensitive." do
    chunks = chunkify("The test tests things.", ["the"])
    chunk = chunks.find {|chunk| chunk.text = "The"}

    assert_not_nil chunk&.typ
  end

  test "The end of a sentence is not selectable." do
    chunks = chunkify("This sentence ends in a period.")
    period = chunks.find {|chunk| chunk.text == "."}

    assert_equal ".", period&.text
    assert_equal false, period&.selectable
  end

  test "Commas are not considered part of a word." do
    chunks = chunkify("This sentence, is awkard.")
    before_comma = chunks.find {|chunk| chunk.text == "sentence"}
    assert_not_nil before_comma
  end

  test "U.K. is considered a word." do
    chunks = chunkify("In the U.K. it is rainy.")
    uk_chunk = chunks.find {|chunk| chunk.text == "U.K."}

    assert_equal "U.K.", uk_chunk&.text
    assert_equal true, uk_chunk&.selectable
  end

  def chunkify(text, entities=[])
    presenter = SentencePresenter.new(
      Sentence.new(
        text: text,
        entities: entities.map { |text| Entity.new(text: text, typ: "TEST") },
      ),
    )
    presenter.chunks
  end
end
