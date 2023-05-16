# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

Entity.destroy_all
Sentence.destroy_all

sentence = Sentence.create(text: "Apple is looking at buying U.K. startup for $1 billion.")
Entity.create(sentence: sentence, text: "Apple", typ: "ORG")
Entity.create(sentence: sentence, text: "U.K.", typ: "GPE")
Entity.create(sentence: sentence, text: "$1 billion", typ: "MONEY")

sentence = Sentence.create(text: "Regional funds with exposure to United States and outperform equity market over 3 year")
Entity.create(sentence: sentence, text: "Regional funds", typ: "THEME")
Entity.create(sentence: sentence, text: "United States", typ: "GPE")
Entity.create(sentence: sentence, text: "equity market", typ: "THEME")
Entity.create(sentence: sentence, text: "3 year", typ: "TIME")

