---
:title: This Gherkin's Not For Reading
:author: tooky
:tags: []

---
Recently [Kevin Liddle][kevin] made his [case against cucumber][case-against]. In the article he outlines several problems he experiences working with cucumber. One of his key arguments is that non-technical team members don't read the scenarios written by developers.

> In theory, this is a valuable thing, a bridge between the divergent worlds of
> developers and managers. In practice, however, I’ve never seen Cucumber used
> this way. Non-technical people don’t read code, no matter how easy it is to
> read. They care about the actual use cases and that means using the
> application. And if they use the application, who cares if there is some text
> claiming the application works!

So why don't non-technical people read the scenarios written by developers or testers?

Because they aren't written for non-technical people to read! They probably aren't even written with non-technical people in mind. They are written as a test script, they are written as a set of instructions for a computer to follow so they can execute a test plan. At best they're written as set of steps that the developer will go through to get the feature finished.

Gherkin isn't a scripting language for tests. Cucumber isn't a testing tool. BDD isn't a testing process. Kevin says that "non-technical people don't read code" and that they "care about the actual use cases".

We don't want them to read our code, or our test plans. We want to talk to them about the behaviour, we want to discuss the impact they are looking to create and collaborate on how we can achieve that.

Gherkin's value isn't when it's read. It's when it's written - it's value is as a communication tool. It is close enough to natural language that both technical and non-technical people can collaborate but it has enough constraints to encourage thinking in terms of behaviour.

Writing scenarios with non-technical people, allows you to document the conversations you have about the behaviour of the system. It provides an avenue to explore new features and their value without building anything.

Kevin's article goes on to highlight the value of gherkin when "gathering requirements", but he argues that automating those scenarios using cucumber adds a level of overhead and’ indirection that is not worthwhile.

I have more to say about that, but that's another post.

For now try sitting down with with your stakeholders and use gherkin to document examples of how they expect your software to behave. Use those examples to help you when you're writing the code, but also check the assumptions with other people on the team. Do other non-technical stakeholders find them more readable?

[kevin]: http://www.8thlight.com/our-team/kevin-liddle
[case-against]: http://blog.8thlight.com/kevin-liddle/2013/09/18/a-case-against-cucumber.html
