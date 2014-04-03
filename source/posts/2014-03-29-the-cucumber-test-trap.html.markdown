---
:title: The Cucumber Test Trap
:author: tooky
:tags:
- cucumber
- bdd
- specification-by-example
:meta_tags:
  "twitter:card": summary
  "twitter:site": "@tooky"
  "twitter:title": The Cucumber Test Trap
  "twitter:description": Slow and brittle features? Documenting everything end-to-end? Have you fallen into the Cucumber Test Trap?
:date: 2014-03-29
---
[Aslak Hellesøy][aslak01] recently wrote how cucumber is "[the world's most
misunderstood collaboration tool][aslak02]."

  > Cucumber was born out of the frustration with ambiguous requirements and
  > misunderstandings between the people who order the software and those who
  > deliver it.

Anybody who has spent time with more than a few codebases that use cucumber will
probably recognise Aslak's description of a cucumber anti-pattern:

  > When Cucumber is adopted solely as a tool to write automated tests without
  > any input from business analysts they tend to become imperative and lose
  > their documentation value.
  >
  > This also makes them slow and brittle.

This doesn't tell the whole story though - there are many teams that work with
the business to define their scenarios, that make an effort to write declarative
scenarios - yet some of these teams still suffer from slow and brittle builds.

They've fallen into the cucumber test trap - they want to document everything
the system does and automatically check it using cucumber.

As they start building their system the automated cucumber suite gives them
the confidence that everything is working. Running the features is quick and
their system is simple. As they add behaviour to the system they diligently
document the behaviour in gherkin and automate it with cucumber. All of the
while running every scenario from end-to-end through their entire stack.

In [The Cucumber Book][mattw01] (*When Cucumbers Go Bad* p. 103), [Matt
Wynne][mattw02] and Aslak describe one of the main causes for "*Slow Features*":

  > **Lots of Scenarios**
  > 
  > It might seem like stating the obvious, but having a lot of scenarios is by
  > far the easiest way to give yourself a slow overall feature run. We're not
  > trying to suggest you give up on BDD and go back to cowboy coding, but we do
  > suggest you treat a slow feature run as a red flag. Having lots of tests has
  > other disadvantages than just waiting a long time for feedback. It's hard
  > to keep a large set of features organized, making them awkward for readers
  > to navigate around. Maintenance is also harder on the underlying step
  > definitions and support code.

Of course this isn't really a product of using cucumber, or even trying to get
started with BDD or Specification by Example. It's exactly the same problem that
[J. B. Rainsberger][jbrains01] describes when he says that "[integrated tests
are a scam][jbrains03]."

  > You write integrated tests because you can't write perfect unit tests. You
  > know this problem: all your unit tests pass, but someone finds a defect
  > anyway.  Sometimes you can explain this by finding an obvious unit test you
  > simply missed, but sometimes you can't. In those cases, you decide you need
  > to write an integrated test to make sure that all the production
  > implementations you use in the broken code path now work correctly together.

As soon as you make a decision that you will describe everything your system
does using cucumber features you've left BDD behind, fallen into the cucumber
test trap and are destined to have "*Lots of Scenarios*". J. B.
[describes][jbrains03] this brilliantly:

  > You have a medium-sized web application with around 20 pages, maybe 10 of
  > which have forms. Each form has an average of 5 fields and the average field
  > needs 3 tests to verify thoroughly. Your architecture has about 10 layers,
  > including web presentation widgets, web presentation pages, abstract
  > presentation, an HTTP bridge to your service API, controllers, transaction
  > scripts, abstract data repositories, data repository implementations, SQL
  > statement mapping, SQL execution, and application configuration. A typical
  > request/response cycle creates a stack trace 30 frames deep, some of which
  > you wrote, and some of which you've taken off the shelf from a wide variety
  > of open source and commercial packages. How many tests do you need to test
  > this application thoroughly?
  >
  > At least 10,000. Maybe a million. One million.

_One million_ scenarios - even _10,000_ scenarios - to thoroughly check "a
medium sized web application" using cucumber. All of them running end-to-end. No
wonder teams have "*Slow Features*".

Avoiding the cucumber test trap is hard. It's easy to keep adding scenarios
which give you a false confidence that your application is working correctly.
It's easy to just add some more code to make those scenarios pass.

Instead we need to keep [focusing on the conversations][lizk01]. Find the
scenarios that matter, that are important to document, that are worth automating
and push everything else down into lower level, isolated tests.

Define contracts between layers, and test those exhaustively. Allow the design
pressure of creating testable code help you to build a cleaner, maintainable
application. This will help you prevent another one of the main causes of "*Slow
Features*" that Matt and Aslak describe in The Cucumber Book.

  > **Big Ball of Mud**
  >
  > The Big Ball of Mud is an ironic name given to the type of software design
  > you see when nobody has really made much effort to actually do any software
  > design. In other words, it's a big, tangled mess.

At the [Extreme Programmers London][xprolo] meetup last week [Keith
Braithwaite][keithb01] talked about code metrics and the effect that
unit-testing has on the distribution of complexity in the codebase. During the
talk he mentioned that he thought the part of the TDD cycle that has the biggest
effect on the software design is when you have to add the next test, because we
often have to refactor our code to support adding the next test - to make it
testable.

In [Growing Object Oriented Software, Guided by Tests][goos] (*What Is the Point
of Test-Driven Development*), [Steve Freeman][stevef01] and [Nat Pryce][natp01]
describe why testable code *is* well designed code.

  > Thorough unit testing helps us to improve the internal quality because, to
  > be tested, a unit has to be structured to run outside the system in a test
  > fixture. A unit test for an object needs to create the object, provide its
  > dependencies, interact with it, and check that it behaved as expected. So,
  > for a class to be easy to unit-test, the class must have explicit
  > dependencies that can easily be substituted and clear responsibilities that
  > can easily be invoked and verified. In software engineering terms, that
  > means that the code must be *loosely coupled* and *highly cohesive* - in
  > other words, well designed.

By falling into the cucumber test trap and relying on checking the system
end-to-end you lose this valuable design pressure that comes from TDD. You have
no need to make your units testable in isolation, because it's *easy* to add
another test that runs from outside of the application. Which means you have
nothing pushing you to improve the internal quality of the codebase, nothing to
help you avoid creating a *Big Ball of Mud*.

Writing scenarios *with your customers* will help you to understand what your
application needs to do, and automating those scenarios with cucumber will help
you to know when the application meets those needs. Just don't fall into the
trap of thinking you can use cucumber to test the app completely at the expense
of unit tests or *Lots of Scenarios* and a *Big Ball of Mud* will be your
reward.

[aslak01]: https://twitter.com/aslak_hellesoy
[aslak02]: https://cucumber.pro/blog/2014/03/03/the-worlds-most-misunderstood-collaboration-tool.html
[mattw01]: http://pragprog.com/book/hwcuc/the-cucumber-book
[mattw02]: https://twitter.com/mattwynne
[jbrains01]: https://twitter.com/jbrains/
[jbrains02]: http://vimeo.com/80533536
[jbrains03]: http://blog.thecodewhisperer.com/2010/10/16/integrated-tests-are-a-scam/
[lizk01]: http://lizkeogh.com/2011/09/22/conversational-patterns-in-bdd/
[xprolo]: http://www.meetup.com/Extreme-Programmers-London/
[keithb01]: https://twitter.com/keithb_b
[goos]: http://www.growing-object-oriented-software.com
[stevef01]: https://twitter.com/sf105
[natp01]: https://twitter.com/natpryce
