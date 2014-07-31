---
:title: Kickstart Academy Podcast with Liz Keogh and Corey Haines
:tags:
- bdd
- cynefin
- specification-by-example
- podcast
- corey-haines
- liz-keogh
:author: tooky
:meta_tags:
  twitter:card: summary
  twitter:site: "@tooky"
  twitter:title: Kickstart Academy Podcast with Liz Keogh and Corey Haines
  twitter:description: Liz Keogh and Corey Haines join Steve and Suzan to discuss
    BDD and cynefin.
:date: 2014-07-31
---
For the third installment of the Kickstart Academy podcast we were pleased to
have [Liz Keogh][liz] join us &mdash; and [Corey Haines][corey] returned to the
panel for his second appearance.

(READMORE)

We enjoyed having [Sandi Metz][sandi] on the panel for the [last
podcast][corey-show] so much that we hope to have a running theme of inviting
the previous guest back to the following show – in a similar vein to BBC Radio
4's [Chain Reaction][chain-reaction].

<iframe width="560" height="315" src="//www.youtube.com/embed/_hKO-AVjCJM"
frameborder="0" allowfullscreen></iframe>

There is an [audio version of this podcast available here][audio].

## Show Notes

* [0:01:39] Liz's backstory
* [0:04:17] Define [Cynefin][cynefin] - a sense making framework
  * Simple/Obvious - children can solve it
  * Requires expertise - watchmaker
  * Complex - not predictable outcomes
  * Chaos - accident and emergency
* [0:08:30] Software development approaches within the different cynefin domains
  * Commoditised requirements vs Differentiating Requirements
  * Chaos - Experiment / Spike / Probe
  * Requires expertise - Analyze (e.g. BDD)
  * Simple - off the shelf
* [0:12:25] Capabilities vs Goals
  * Understanding the goal behind the capability
  * Which stakeholders are getting the benefit?
  * [Tom Gilb][tom-gilb] - [Evolutionary Project Management][evo]
* [0:16:31] Is BDD a design activity not required for obvious requirements? - [Matt Wynne][mattwynne]
  * Analyze as simply as possible
  * Name the scenarios
  * Ask: is there anything different?
* [0:20:40] BDD: automation and regression testing
  * How you set the context with "Given" doesn't matter
  * "When" is the actual behaviour your interested in
* [0:22:11] Liz's scale for classifying capabilities
  * 5 - nobody in the world has ever done it before
  * 4 - somebody has done it before but not in this organisation
  * 3 - somebody in this organisation has done it before, and we need their expertise
  * 2 - somebody in the team has done it before
  * 1 - we all know how to do it
* [0:23:05] When automated scenarios catch a regression bug it's usually because of poor design
  * Don't just throw more scenarios at it find out why your getting the bugs
  * Often because two capabilities are bleeding in to each other
* [0:25:51] Techniques for talking through capabilities with stakeholders
  * Why are we doing this project?
  * Who are we doing it for?
  * Can you give me an example?
  * What will you be able to do that you can't do now?
* [0:30:44] Focusing on the outcome
  * [Chris Matts][chris-matts] - [Value Mapping][value-mapping]
  * Assign numbers from Liz's scale to capabilities
  * For 1s and 2s, "Choose the technology that's easy to change" - Chris Matts
* [0:37:01] Applying BDD at the different levels
  * When outcomes are uncertain, can lead to analysis paralysis
  * Often an indicator of 4s and 5s
  * So find a way to prototype/experiment
  * Listen for the uncertainty
  * Listen for the boredom
* [0:42:05] What is BDD?
  * Not testing tools with BDD mode - "should" or "expect"
  * "Using examples to illustrate behaviour" - Liz
  * Let dev's write the scenarios, and get feedback from the testers and experts
  * [Dan North][dannorth]'s [definition][bdd-definition] true in 2009, maybe not 2010
  * It's not necessarily high-automation
  * It's still outside-in
  * It's still 2nd generation
  * It's still pull-based
  * It's still multiple-scale
  * It's still agile
  * It's still about getting feedback
  * It's still a cycle of interactions
  * We now respect we can't always get well defined outputs
  * It still results in software that matters
* [0:49:01] Patterns for improving scenarios
  * Just write down what people say
  * Have the conversation
  * Don't try to make patterns fit existing steps
  * Step away from the tools
* [0:53:14] How does having theses conversations about the system itself affect the minute-by-minute development process?
  * Leads to more spikes and prototypes, and understanding why to do them?
  * Less useful for large organisations where a lot of the work is governed by regulations
  * Removes frustrations of things like 4-hour planning meetings
* [0:55:25] Can you use examples to identify and then test your assumptions?
* [0:57:45] Leveling capabilities
  * Map out the capabilities
  * Map the stakeholders - then understand the capailities they are looking for
  * Try estimating them using relative sizes
  * Find the capabilities that are new
* [1:00:33] Liz's Fantasy Fiction
  * [The Silversong Child][silversong-child]
  * [The Nightingale Throne][nightingale-throne]
  * High-level fantasy - a bit like Game of Thrones, with less killings and more magic
* [1:01:40] How do you guard against new adopters of BDD from just rewriting existing requirements with new words, e.g. should, then, describe, expect - [Kerry Buckley][kerryb]
  * [What is the value of Social Capital? - Jabe Bloom][social-capital] - [Jabe Bloom][jabe-bloom]

[liz]: https://twitter.com/lunivore
[corey]: https://twitter.com/coreyhaines
[sandi]: https://twitter.com/sandimetz
[corey-show]: http://kickstartacademy.io/blog/2014-07-29-kickstart-academy-podcast-with-corey-haines-and-sandi-metz
[chain-reaction]: http://en.wikipedia.org/wiki/Chain_Reaction_%28radio%29
[audio]: https://dl.dropboxusercontent.com/u/41915/kickstart-academy-podcast/003-liz-keogh-and-corey-haines.mp3
[cynefin]: http://en.wikipedia.org/wiki/Cynefin
[tom-gilb]: https://twitter.com/imtomgilb
[evo]: http://gilb.com/Project-Management
[mattwynne]: https://twitter.com/mattwynne
[chris-matts]: https://twitter.com/PapaChrisMatts
[value-mapping]: http://theitriskmanager.wordpress.com/2014/07/06/a-tale-of-two-feature-injections-a-cynefin-tale/
[dannorth]: https://twitter.com/tastapod
[bdd-definition]: http://en.wikipedia.org/wiki/Behavior-driven_development#History
[kerryb]: https://twitter.com/kerryb
[social-capital]: http://vimeo.com/75923366
[jabe-bloom]: https://twitter.com/cyetain
[silversong-child]: https://leanpub.com/silversongchild
[nightingale-throne]: https://leanpub.com/nightingalethrone

