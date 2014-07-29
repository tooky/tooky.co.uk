---
:title: Kickstart Academy Podcast with Corey Haines and Sandi Metz
:tags:
- oop
- podcast
- sandi-metz
- corey-haines
:author: tooky
:meta_tags:
  twitter:card: summary
  twitter:site: "@tooky"
  twitter:title: Kickstart Academy Podcast with Sandi Metz
  twitter:description: Corey Haines and Sandi Metz join Steve, Chris and Matt to discuss
    simple design.
:date: 2014-07-29
---
Last month we broadcast our 2nd live podcast. We were fortunate to be joined by
[Corey Haines][corey] &mdash; to discuss simple design &mdash; and by [Sandi
Metz][sandi] &mdash; who was kind enough to return for a second show.

(READMORE)

<iframe width="560" height="315" src="//www.youtube.com/embed/BT7MYd07OFw"
frameborder="0" allowfullscreen></iframe>

There is an [audio version of this podcast available here][audio] - but due to the nature
of the live code examples on the video version that is probably the better
experience.

## Show Notes

* [0:02:20] &mdash; 4 rules of simple design
  * [Kent Beck][kent]
  * "Design that is easier to change" - Corey
  * [Four elements of simple design][2rulespost] &mdash; [J. B. Rainsberger][jbrains]
* [0:6:11] &mdash; [Understanding the 4 Rules of Simple Design][4rulesbook]
  * [Code Retreat][coderetreat]
  * Sandi doesn't hate Corey...
* [0:10:17] Understanding Testing Book
  * What can you learn from writing your own assert method?
  * All testing frameworks bring baggage with them - leaving that aside allows
  you to understand the fundamentals
  * Do you start with `assert` or `assert_true` ?
* [0:19:55] Writing your own assert method demo
  * (apologies about the sound cutting in and out, Hangouts appears to mute
  typing)
  * "Fundamentally testing is about checking that two things are the same" - Corey
* [0:30:02] Having rich ways of verifying your system can mask design feedback from simple tests
  * [TypeMock][typemock] for mocking static methods in .NET masked the need to inject dependencies
* [0:36:00] Only having simple testing features can lead to writing a single method that does everything
* [0:38:10] The tension between learning and getting things out in production
  * Being able to explain the value of the things that you use
  * Doing something because smart people say you should do it, and understanding why they do it
* [0:45:21] What's the best approach to teaching design sense to new programmers?
  * Go back to the mechanical refactoring steps - back to the fundamentals
  * "refactorings are little machines that produce objects" - Sandi
  * [SOLID][solid] principles are guide points
* [0:54:10] Actionable principles
  * SOLID principles are hard to action, minute-by-minute
  * Inner/outer design loops
  * [Refactoring to Patterns - Joshua Kerievsky][refactor2patterns]
* [01:01:22] Efficient ways of travelling the long road
  * Paying attention to what your doing
  * [Divergent/convergent thinking][divergentconvergent] phases
  * [Sunk cost fallacy][sunkcost]
* [01:04:07] Only ever one undo away from being back to green
  * [Corey's Challenge][stackchallenge]
  * [Limited Red Society - Joshua Kerievsky][limitedred]
  * [Time to Green Graph - Gary Bernhardt][timetogreen]

[corey]: https://twitter.com/coreyhaines
[sandi]: https://twitter.com/sandimetz/
[kent]: https://twitter.com/kentbeck
[2rulespost]: http://www.jbrains.ca/permalink/the-four-elements-of-simple-design
[jbrains]: https://twitter.com/jbrains
[4rulesbook]: https://leanpub.com/4rulesofsimpledesign
[coderetreat]: http://coderetreat.org/
[typemock]: http://www.typemock.com/
[solid]: http://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29
[refactor2patterns]: http://industriallogic.com/xp/refactoring/
[divergentconvergent]: http://www.innovationexcellence.com/blog/2012/10/24/divergent-and-convergent-thinking/
[sunkcost]: http://en.wikipedia.org/wiki/Sunk_costs
[stackchallenge]: https://gist.github.com/tooky/a75778f70499af2f9435
[limitedred]: http://www.infoq.com/presentations/The-Limited-Red-Society
[timetogreen]: http://vimeo.com/3763583
[audio]: http://bit.ly/1lR4AsO

