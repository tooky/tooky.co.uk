---
:title: Discovering BDD
:author: tooky
:tags:
- bdd
- atdd
- cucumber
- xp

---
I graduated from UMIST in 2002 with a Software Engineering degree, and I started work with a company who provided document scanning services, mostly to the public sector - NHS trusts and local authorities. I came into the company thinking I knew it all - I had a software engineering degreee!

Wow - I had a _LOT_ to learn!

I met Shane Paterson while I was there. Shane was another developer at the company, and even though he was based in New Zealand, he was responsible for pointing me in the direction of XP and TDD. There's some more about this story in the [Apprenticeship Patterns](http://chimera.labs.oreilly.com/books/1234000001813/ch04.html#solution_id19) book.

I started reading a lot of blogs and participating in the various mailing lists. I found an [old post](http://groups.yahoo.com/neo/groups/extremeprogramming/conversations/messages/116122) on the XP mailing list where I was introducing a colleague to TDD using the bowling game kata which made me smile as I used the same exercise during some recent ruby/tdd training.

This colleague and I were about to start working on the new version of our main software application. A decision had been taken to rewrite the application with a completely new look and feel, to move to the new (at the time) .NET technology stack and to support MS SQL server as well as MS Access. The company had great success with application up until then because it could be set up and installed by anyone with file sharing permissions, so no need to involve corporate IT. This kind of culture was coming to an end though, so we needed to fit in with what the IT departments demanded.

We ran it as close to a proper XP project as the business would allow. In particular we were pair programming and we were writing our tests first! Not just unit tests, we were also writing acceptance tests with our 'customer' to help us understand the requirements.

We used a tool called [FIT](http://en.wikipedia.org/wiki/Framework_for_Integrated_Test). This allowed us to create word documents (!!) that contained tables of examples of what the software should do. We would then hook these tables up to some test classes which would run the tests and colour the tables appropriately.

Using tables to describe the requirements was fantastic. We were able to communicate clearly with our project sponsors about the business rules, using concrete examples to support our understanding.

Brian Marick's foreword from the book really sums up what the FIT community were trying to do:

>A software project is a place where different cultures come together. Some people face towards the business and its concerns; other people face toward the computer and its demands.
>
>To an expert in financial trading, a "bond" is something that's tangled up in all sorts of explicit and implicit legal, social, historical and emotional meanings.
>
>To programmers, a Bond is an object in their program that they're trying to keep from getting too tangled up with other objects, lest their brains explode.
>
>Somehow these people have to work together, and they do it by creating a shared language. Most of that creating happens through the conversation that threads through the whole project. But some of it happens through writing.
>
> _Brian Marick, Feb 2005 (foreword of [Fit for Developing Software](http://www.pearsoned.co.uk/bookshop/detail.asp?item=100000000079971))_

At about the same time as this I came across the term _Behaviour Driven Development_ in [this post](http://blog.daveastels.com/2005/07/a-new-look-at-test-driven-development/) by Dave Astels. It was about trying to change the focus of TDD from testing to specifying behaviour.

> 1. The problem I have with TDD is that its mindset takes us in a different direction… a wrong direction.
>
> 2. We need to start thinking in terms of behavior specifications, not verification tests.
>
> 3. The value of doing this will be thinking more clearly about each behaviour, relying less on testing by class or by method, and having better executable documentation.
>
> 4. Since TDD is what it is, and everyone isn’t about to change their meaning of that name (nor should we expect them to), we need a new name for this new way of working… BDD: Behaviour Driven Development.

This post really struck a chord with me. I was still getting to grips with TDD but when it had worked well for me it was when I was working how Dave described. The timing of this is a little fuzzy for me now, but it was right around the time I first started to use Ruby and Rails, so I picked up RSpec as my testing tool of choice.

The FIT toolchain didn't exist in ruby, but in August 2007 the [RSpec Story Runner was released](http://rubyforge.org/pipermail/rspec-devel/2007-August/003756.html) which gave us the tools to do similar things in ruby. The story runner gave way to [cucumber](http://cukes.info/).

Cucumber and Gherkin (the formal language for writing cucumber specifcations), have spread. It is now possible to write Gherkin specifications [on](https://github.com/cucumber/cucumber-jvm) [a](https://github.com/cucumber/cucumber-js) [huge](http://www.specflow.org/) [range](https://github.com/cucumber/cucumber-cpp) [of](http://behat.org/) [platforms](https://github.com/gabrielfalcao/lettuce).

I think I made a mistake using these tools that many people have done. I used them to write tests. Sometimes they were very brittle tests, [overly focussed on the view](http://tooky.co.uk/stop-writing-scenarios-that-test-everything-through-the-view/). Often they were boring lists of instructions. I learnt to be more [declarative](http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html), and my tests became more readable. But...

They were still written as tests by me (and my colleagues) for the computer to run. [BDD isn't about the tools](http://lizkeogh.com/2011/03/04/step-away-from-the-tools/) its about the [discovery](http://dannorth.net/2010/08/30/introducing-deliberate-discovery/).

BDD enables communication. Our teams are made up of those who need the capabilities some new software will provide, and those who are able to create that software. These people come from different backgrounds, different experiences. Using stories and examples helps to create a shared language which we can then use to explore the problem space and begin to discover the things we don't know!
