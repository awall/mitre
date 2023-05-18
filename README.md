# README

This is a demo app that demonstrates how to use Rails 6 for a simple tagging system.

The specifications are [redacted]. There was a corner-case left unspecified: what if the same word appears
multiple times in a sentence, should it be tagged every time it appears? I chose 'yes'. 
You can see `sentences_presenter_test` for the full list of expectations in this scenario, and
other potential ambiguities (like case sensitivity).

## Test it out

This demo was built using Rails 6.1.7.3.

If bundler is installed on your system, you should be able to run with the following commands:

1. `bundle install`
2. `rails db:setup`
3. `rails test`
4. `rails server`

## Caveats

I deliberately chose to use _vanilla Rails 6_, as I believe it better demonstrates the inner workings of how
forms, views, and controllers interact. In a real project, I would likely reach for dependies like _Turbo Rails_
and _Draper_.

In order to complete this demo in a timely manner, I left some things rough around the edges:

1. When creating a new entity, the user can only select a single word. The API supports the ability to create
   multi-word entities (and there's a unit test for this), but the view provides no mechanism to do this.
   This could be added by adding some sophisticated javascript to the view.
2. The CSS is very basic; the forms that allow tagging are displayed on hover, but I didn't control for the DOM adjustment!
   This means that the words "move around" while you move your mouse, which is rather annoying. This could be fixed with some
   adjustments to the CSS if we ensure that the hovered section is a popup.
3. When a model's rules are violated (e.g., if you attempt to create an `Entity` with an empty type), we just show the
   default Rails' exception page. The controllers could be made more robust, to handle these kinds of errors and redirect
   to a more appropriate error page.
4. There is no way to edit a sentence, edit an entity, delete a sentence, or delete an entity. If you want to experiment
   with different sentences, you can edit `db/seeds.rb`, then run `rails db:reset` and restart the server.
5. There are some tests that are missing. I did not test the views themselves, and the controller tests are
   only testing the _happy path_. I prioritized testing the [SentencePresenter](app/presenters/sentence_presenter.rb),
   because it contains all the logic used to split up a sentence and apply tags.
6. I did not benchmark the controllers, nor did I attempt to optimize any of the calculations. There is definitely room
   for improvement in the `SentencePresenter#chunks` method.
