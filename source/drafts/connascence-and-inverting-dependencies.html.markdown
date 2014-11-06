---
title: 'Connascence and Inverting Dependencies'
author: tooky
# date: TBD When publishing
tags:
- oo
- connascence
- design
- solid
---

Recently [Andre Bernardes][andre] [wrote about inverting
dependencies][inverting] and a refactoring that he made in the [Ruby Object
Mapper][rom] codebase.

It's a great article and if you haven't read it yet it won't take you long.
Go on, I can wait.

The original code though, doesn't just provide a great example of code that
violates the [Dependency Inversion Principle][DIP]. Let's take a closer look and
see what else we can find.

```ruby
class Adapter
  ...
  def self.setup(uri_string)
    uri = Addressable::URI.parse(uri_string)
    adapter =
        case uri.scheme
        when 'sqlite', 'jdbc' then Adapter::Sequel
        when 'memory' then Adapter::Memory
        when 'mongo' then Adapter::Mongo
        else
          raise ArgumentError, "#{uri_string.inspect} uri is not supported"
        end

    adapter.new(uri)
  end
  ...
end
```

In 2010 I saw Jim Weirich speak about the [Grand Unified Theory of Software
Development][GUT] (this is the version from Aloha on Rails) where he introduced
his audience to the idea of [Connascence][connascence], from wikipedia:

  > In software engineering, two components are connascent if a change in one
  > would require the other to be modified in order to maintain the overall
  > correctness of the system.

Let's look again at `Adapter` code through the lens of connascence.

The `setup` method is checking the scheme of the `uri` and deciding which
specific adapter to use in this instance. This is an example of [Connascence of
Meaning][CoM].

As Andre pointed out in his post adding a new adapter, also means changing this
method. If an `Adapter` is changed to handle different schemes, then this method
will also need to change.

The refactoring that Andre has implemented doesn't rid us of Connascence of
Meaning but it reduces both the *Degree* of the connascence and the *Locality*.

When we are looking at connascence and deciding whether any particular instance
of connascence is acceptable there are two concepts that we need to consider.

The degree of connascence is really about the volume of connascence, how much of
it we can see. Andre mentions in his post that the example presented above is
not terrible, but when he was about to add 19 more branches to the case
statement it would have become much worse. The degree of connascence would have
increased, and would only keep increasing.

The locality of connascence is concerned with how closely related the elements
are. Stronger forms of connascence are considered to be more acceptable when the
elements involved are closer together. In the original `setup` method the
connascence of meaning ties the `Adapter` class to the specific adapters.

Let's take a look at Andre's refactoring.

```ruby
# adapter.rb

class Adapter
  @adapters = []

  def self.setup(uri_string)
    uri = Addressable::URI.parse(uri_string)

    unless adapter = self[uri.scheme]
      raise ArgumentError, "#{uri_string.inspect} uri is not supported"
    end

    adapter.new(uri)
  end

  def self.register(adapter)
    @adapters << adapter
  end

  def self.[](scheme)
    @adapters.detect { |adapter| adapter.schemes.include?(scheme.to_sym) }
  end
end

# adapter/memory.rb
class Adapter
  class Memory
    def schemes
      [:memory]
    end

    # Methods to communicate with DB omitted.

    Adapter.register(self)
  end
end

Adapter.setup("memory://test").class
# => Adapter::Memory
```

We still have Connascence of Meaning, but it is now isolated inside the
individual adapter class. The *locality* of connascence has been increased. Each
specific adapter will only have a small number of schemes that it matches
&mdash; rather than all of them. The *degree* of connascence has been reduced.

By increasing the locality and reducing the degree of connascence Andre has made
the connascence of meaning more acceptable. The connascence of meaning resulted
in the `Adapter` abstraction depending on the details of the specific adapters.

It also prevented the `Adapter` from being *Closed for Modification*. Any time
we add a new adapter we would need to change the `Adapter` class to add another
branch to the switch statement. It violated the [Open/Closed Principle][ocp].

Andre's refactoring which reduced the degree and increased the locality of
connascence of meaning produced the effect of making the code adhere more
closely to both the Single Responsibility Principle and the Open/Closed
Principle.

I think this may be a good example of what [Kevin Rutherford][kevin] is hinting
at in [The problem with code smells][smells]. Finding the areas in our code that
are more connascent &mdash; having the stronger forms of connascence, having
a high degree of connascence, or having low locality of connascence &mdash; will
help us to improve the design of software.

[andre]: http://twitter.com/abernardes
[inverting]: http://abernardes.github.io/2014/11/04/inverting-dependencies.html
[rom]: http://rom-rb.org
[DIP]: http://en.wikipedia.org/wiki/Dependency_inversion_principle
[GUT]: http://vimeo.com/10837903
[connascence]: http://en.wikipedia.org/wiki/Connascence_(computer_programming)
[CoM]: http://en.wikipedia.org/wiki/Connascence_(computer_programming)#Connascence_of_Meaning_.28CoM.29
[ocp]: http://en.wikipedia.org/wiki/Open/closed_principle
[kevin]: http://twitter.com/kevinrutherford
[smells]: http://silkandspinach.net/2012/09/03/the-problem-with-code-smells/
