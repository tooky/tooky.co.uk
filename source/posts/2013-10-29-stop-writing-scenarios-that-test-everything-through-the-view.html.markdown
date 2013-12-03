---
:title: Stop Writing Scenarios That Test Everything Through The View
:author: tooky
:tags: []

---
Following on from my [last post][gherkin-reading], I wanted to mention a common anti-pattern that [Kevin's case against cucumber][case-against] mentioned. Scenarios that are too focussed on the user interface. Scenarios written as an imperative set of instructions for a machine to follow.

READMORE

Scenarios like this.

```gherkin
Given I go to the homepage
And I fill in my username
And I click sign in
When I click "Accounts"
Then I see "Current Account"
And I see "Savings Account"
```

*sigh*

There has been quite a lot written about this, the [canonical post][imp-vs-dec] is from 2008. The cucumber team made a mistake including `web_steps.rb` - they were [removed][bye-web-steps] 2 years ago.

The problem here isn't just isolated to the imperative style of this scenario, but also that the scenario is highly coupled to the view.

Testing through the view is something you have to be wary of with any tool. It's slow and brittle. That isn't to say it has no value, but you don't need every test to go through the UI. Beware the [ice cream cone][ice-cream] anti-pattern.

I've written a little more about this [here](http://tooky.co.uk/cucumber-and-full-stack-testing/), Seb has introduced the [Testing Iceberg][iceberg] and [Matt][matt] talks more about it [here][one-liners].

[case-against]: http://blog.8thlight.com/kevin-liddle/2013/09/18/a-case-against-cucumber.html
[imp-vs-dec]: http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
[bye-web-steps]: https://github.com/cucumber/cucumber-rails/commit/f027440965b96b780e84e50dd47203a2838e8d7d
[ice-cream]: http://watirmelon.com/2012/01/31/introducing-the-software-testing-ice-cream-cone/
[matt]: http://mattwynne.net
[one-liners]: http://skillsmatter.com/podcast/agile-testing/why-your-step-definitions-should-be-one-liners-and-other-pro-tips
[iceberg]: http://claysnow.co.uk/the-testing-iceberg/
[gherkin-reading]: http://tooky.co.uk/this-gherkins-not-for-reading/
