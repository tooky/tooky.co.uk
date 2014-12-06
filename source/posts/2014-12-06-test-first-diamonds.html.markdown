---
:title: Test first diamonds
:tags:
- TDD
- Design
- Kata
:date: 2014-12-06
---
[Seb][seb]'s recent post [Recycling tests in TDD][recycling] introduced the
"Print Diamond" kata. This has provoked a flurry of interesting posts looking at
different approaches to solving it.

```
Given a letter, print a diamond starting with 'A' with the supplied letter at the widest point.

For example: print-diamond 'C' prints

  A
 B B
C   C
 B B
  A
```

*Thinking* has been the theme that has dominated the posts others have published
while trying out this kata. [Alistair Cockburn][alistair] began by suggesting
that this kind of problem is ideal for thinking about the properties of the
problem, and then deriving the code as an exercise - although his approach is to
use tests to get him there. [Ron Jeffries][ronj] and [George Dinwiddie][george]
both take an incremental TDD approach, although both are different.

Luckily I'd had a go at this kata before reading any of the other posts. I say
lucky because I think having read all of the other posts I'd probably have done
something else. 

Ron and George both talk about thinking during their approach. I stepped through
printing 'A', then 'B' and 'C' without really thinking about the algorithm at
all. My first test looked like:


```ruby
class TestPrintDiamond < MiniTest::Unit::TestCase
  include PrintDiamond

  def test_print_a
    assert_equal 'A', print_diamond('A')
  end
end
```

I just took the easy way to make it pass:

```ruby
module PrintDiamond
  def print_diamond
    'A'
  end
end
```

I'm not sure why I decided the interface would be a module that I mixed in, but
I think that's incidental.

My second and third tests followed a similar pattern, I'm going to put them both
here because there's nothing interesting about them.

```ruby
def test_print_b
  expected = [
    ' A ',
    'B B',
    ' A ',
  ].join("\n")
  assert_equal expected, print_diamond('B')
end

def test_print_c
  expected = [
    '  A  ',
    ' B B ',
    'C   C',
    ' B B ',
    '  A  ',
  ].join("\n")
  assert_equal expected, print_diamond('C')
end
```

I kept going with hard coding the answers, so the implementation for this was
pretty simple too.

```ruby
module PrintDiamond
  def print_diamond(letter)
    if letter == 'A'
      [ 'A' ]
    elsif letter == 'B'
      [ ' A ', 'B B', ' A ' ]
    else
      [ '  A  ', ' B B ', 'C   C', ' B B ', '  A  ' ]
    end.join("\n")
  end
end
```

So now I had tests that passed, but an implementation that wasn't going to
scale. This is the point that Seb mentions in his post that we can see the code
is screaming for us to refactor. Seb points out that this is difficult, because
there is so much going on at this point that it's hard to know where to start.

Thanks to [Sandi Metz][sandi] I've been trying recently to make lots of very
small refactorings. This is a great example of code that doesn't quite look the
same, but definitely has a pattern. Rather than going straight for trying to fix
the problem, I wanted to expose the pattern. I want to extract the differences
so I can more clearly see where the lines are the same.

I decided I wanted to focus on the "middle" of each row - the letters and the
spacing between them.

I wrote a method that I thought would give me what I wanted:

```ruby
ALPHABET = Array('A'..'Z')

def print_line(letter)
  if letter == 'A'
    letter
  else
    [letter, ' ' * ALPHABET.index(letter), letter].join
  end
end
```

I had a hunch that the spacing between the letters was the equivalent to the
index of that letter in the alphabet. There's a special case for 'A' as it's the
only character that's printed once, but I figured I would leave that for later.

I then tried using this method in a single place:

```ruby
def print_diamond(letter)
  if letter == 'A'
    [print_line(letter)]
  elsif letter == 'B'
    [' A ', 'B B', ' A ']
  else
    ['  A  ', ' B B ', 'C   C', ' B B ', '  A  ']
  end.join("\n")
end
```

So I extended using it for each of the central rows - the rows that had no extra
spaces on the ends.

```ruby
def print_diamond(letter)
  if letter == 'A'
    [print_line(letter)]
  elsif letter == 'B'
    [' A ', print_line(letter), ' A ']
  else
    ['  A  ', ' B B ', print_line(letter), ' B B ', '  A  ']
  end.join("\n")
end
```

Oh a test failed! My hunch was wrong about the internal padding, or I'd
miss-counted. 'C' has 3 spaces between it, and yes the pattern is that the
internal padding is always an odd number.

```ruby
  def print_line(letter)
    if letter == 'A'
      letter
    else
      internal_padding = ALPHABET.index(letter) * 2 - 1
      [letter, ' ' * internal_padding, letter].join
    end
  end
```

Back to green. Now I was confident that this would work for all the other cases,
so I pushed on and used it throughout, and renamed the method to pad_inside.

```ruby
module PrintDiamond
  ALPHABET = Array('A'..'Z')

  def print_diamond(letter)
    if letter == 'A'
      [pad_inside(letter)]
    elsif letter == 'B'
      [" #{pad_inside('A')} ",
       pad_inside(letter),
       " #{pad_inside('A')} "]
    else
      ["  #{pad_inside('A')}  ",
       " #{pad_inside('B')} ",
       pad_inside(letter),
       " #{pad_inside('B')} ",
       "  #{pad_inside('A')}  "]
    end.join("\n")
  end

  private
  def pad_inside(letter)
    if letter == 'A'
      letter
    else
      internal_padding = ALPHABET.index(letter) * 2 - 1
      [letter, ' ' * internal_padding, letter].join
    end
  end
end
```

The next thing to tackle is the external padding. Again I started by writing the
code I thought might handle it:

```ruby
def pad_out(letter, mid_letter, thing)
  padding = ALPHABET.index(mid_letter) - ALPHABET.index(letter)
  [' ' * padding, thing, ' ' * padding]
end
```

Another hunch. The central row was never padded, and each other row the padding
increased by one. My simple finger-counting maths seemed to think this would
work. Let's try it in one place and see how it goes:

```ruby
def print_diamond(letter)
  if letter == 'A'
    [pad_inside(letter)]
  elsif letter == 'B'
    [" #{pad_inside('A')} ",
     pad_out(letter, letter, pad_inside(letter)),
     " #{pad_inside('A')} "]
  else
    ["  #{pad_inside('A')}  ",
     " #{pad_inside('B')} ",
     pad_inside(letter),
     " #{pad_inside('B')} ",
     "  #{pad_inside('A')}  "]
  end.join("\n")
end
```

Ok - something failed there... Ahh, I'm returning an array, not the string
I need.

```ruby
def pad_out(letter, mid_letter, thing)
  padding = ALPHABET.index(mid_letter) - ALPHABET.index(letter)
  [' ' * padding, thing, ' ' * padding]
end
```

I can now work through using this method throughout:

```ruby
def print_diamond(letter)
  if letter == 'A'
    [pad_out(letter, letter, pad_inside(letter))]
  elsif letter == 'B'
    [
      pad_out('A', letter, pad_inside('A')),
      pad_out(letter, letter, pad_inside(letter)),
      pad_out('A', letter, pad_inside('A')),
    ]
  else
    [
      pad_out('A', letter, pad_inside('A')),
      pad_out('B', letter, pad_inside('B')),
      pad_out(letter, letter, pad_inside(letter)),
      pad_out('B', letter, pad_inside('B')),
      pad_out('A', letter, pad_inside('A')),
    ]
  end.join("\n")
end
```

Great - that works. I want to make a small refactoring to make all of the lines
look the same. The central line that uses `letter` on each conditional is
perhaps masking the pattern a bit.

```ruby
def print_diamond(letter)
  if letter == 'A'
    [pad_out('A', letter, pad_inside('A'))]
  elsif letter == 'B'
    [
      pad_out('A', letter, pad_inside('A')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('A', letter, pad_inside('A')),
    ]
  else
    [
      pad_out('A', letter, pad_inside('A')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('C', letter, pad_inside('C')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('A', letter, pad_inside('A')),
    ]
  end.join("\n")
end
```

So, now I want to remove the duplication inside one of the legs. I need some way
of stepping through from `A` to the target letter, and then back to `A`.

```ruby
def print_diamond(letter)
  if letter == 'A'
    [pad_out('A', letter, pad_inside('A'))]
  elsif letter == 'B'
    rows = Array('A'..letter) + Array('A'...letter).reverse
    rows.map { |row_letter| pad_out(row_letter, letter, pad_inside(row_letter)) }

    [
      pad_out('A', letter, pad_inside('A')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('A', letter, pad_inside('A')),
    ]
  else
    [
      pad_out('A', letter, pad_inside('A')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('C', letter, pad_inside('C')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('A', letter, pad_inside('A')),
    ]
  end.join("\n")
end
```

There's another hunch! It's a bit tricky because it uses the difference between
the ruby `..` range operator, and the `...` operator &mdash; using `..` means up
to and including, and `...` means up to but not including. Let's see if it works
&mdash; I'll just remove the old code for `B`.

```ruby
def print_diamond(letter)
  if letter == 'A'
    [pad_out('A', letter, pad_inside('A'))]
  elsif letter == 'B'
    rows = Array('A'..letter) + Array('A'...letter).reverse
    rows.map { |row_letter| pad_out(row_letter, letter, pad_inside(row_letter)) }
  else
    [
      pad_out('A', letter, pad_inside('A')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('C', letter, pad_inside('C')),
      pad_out('B', letter, pad_inside('B')),
      pad_out('A', letter, pad_inside('A')),
    ]
  end.join("\n")
end
```

Great, so I can try the same for the `C` branch.

```ruby
def print_diamond(letter)
  if letter == 'A'
    [pad_out(letter, letter, pad_inside(letter))]
  elsif letter == 'B'
    rows = Array('A'..letter) + Array('A'...letter).reverse
    rows.map { |row_letter| pad_out(row_letter, letter, pad_inside(row_letter)) }
  else
    rows = Array('A'..letter) + Array('A'...letter).reverse
    rows.map { |row_letter| pad_out(row_letter, letter, pad_inside(row_letter)) }
  end.join("\n")
end
```

Success! Time to remove the duplication and lose the `B` branch.


```ruby
def print_diamond(letter)
  if letter == 'A'
    [pad_out(letter, letter, pad_inside(letter))]
  else
    rows = Array('A'..letter) + Array('A'...letter).reverse
    rows.map { |row_letter| pad_out(row_letter, letter, pad_inside(row_letter)) }
  end.join("\n")
end
```

Still works - so I'm confident it will work for the `A` branch too, so I'll
remove the conditional altogether.

```ruby
def print_diamond(letter)
  rows = Array('A'..letter) + Array('A'...letter).reverse
  rows.map { |row_letter| pad_out(row_letter, letter, pad_inside(row_letter)) }.join("\n")
end
```

I think this is a good point to talk about how this approach has differed from
the others. Like some of the other solutions I didn't do very up front thinking,
but I didn't really break the problem down. I just started to write code &mdash;
I think Sandi Metz would call it [shameless][shameless] &mdash; and then looked
for patterns.

One of Sandi's key points from her OOD training is that it helps to look for
simliar code, and extract the differences. This lets you make code that is
nearly the same, actually be the same, and then you can tackle the duplication.

By this point I'd pretty much sketched out the algorithm. Its still not
particularly nice, but it works and there's something to work with.

```ruby
module PrintDiamond
  ALPHABET = Array('A'..'Z')

  def print_diamond(letter)
    rows = Array('A'..letter) + Array('A'...letter).reverse
    rows.map { |row_letter| pad_out(row_letter, letter, pad_inside(row_letter)) }.join("\n")
  end

  private
  def pad_inside(letter)
    if letter == 'A'
      letter
    else
      internal_padding = ALPHABET.index(letter) * 2 - 1
      [letter, ' ' * internal_padding, letter].join
    end
  end

  def pad_out(letter, mid_letter, thing)
    padding = ALPHABET.index(mid_letter) - ALPHABET.index(letter)
    [' ' * padding, thing, ' ' * padding].join
  end
end
```

I'm concerned about that `if letter == 'A'`, and I definitely sense there's an
object or two waiting to leap out! I won't bore you with the step-by-step
[refactorings][branch], as this post is already pretty long. This was where
I stopped though:

```ruby
module PrintDiamond
  ALPHABET = Array('A'..'Z')

  def print_diamond(letter)
    Diamond.new(letter).to_s
  end

  class Diamond
    attr_reader :letter

    def initialize(letter)
      @letter = letter
    end

    def to_s
      rows.map { |row_letter| PaddedRow.new(row_letter, letter) }.join("\n")
    end

    def rows
      top + bottom
    end

    def top
      Array('A'..letter)
    end

    def bottom
      Array('A'...letter).reverse
    end
  end

  class Row
    attr_reader :letter

    def initialize(letter)
      @letter = letter
      create_chars
    end

    def to_s
      @chars.join
    end

    private
    def row_size
      # 0 -> 1, 1 -> 3, 3 -> 7, ...
      ALPHABET.index(letter) * 2 + 1
    end

    def create_chars
      @chars = Array.new(row_size) { ' ' }
      @chars[0] = letter
      @chars[-1] = letter
    end
  end

  class PaddedRow
    attr_reader :diamond_letter, :row, :letter
    def initialize(letter, diamond_letter)
      @row = Row.new(letter)
      @letter = letter
      @diamond_letter = diamond_letter
    end

    def to_s
      [padding, row, padding].join
    end

    private
    def padding
      ' ' * padding_size
    end

    def padding_size
      ALPHABET.index(diamond_letter) - ALPHABET.index(letter)
    end
  end
end
```

I won't claim this as an example of TDD. I think this is what [J. B.
Rainsberger][jbrains] would call test-first development. The tests were written
first, but they didn't influence the design particularly. I think it is an
example of evolutionary design, and how having tests enables the refactoring
that allows a design to emerge.

[seb]: https://twitter.com/sebrose
[recycling]: http://claysnow.co.uk/recycling-tests-in-tdd/
[alistair]: http://alistair.cockburn.us/Thinking+before+programming
[ronj]: http://ronjeffries.com/articles/diamond/diamond.html
[george]: http://blog.gdinwiddie.com/2014/11/30/another-approach-to-the-diamond-kata/
[branch]: https://github.com/tooky/print-diamond/tree/refactoring
[jbrains]: http://www.jbrains.ca/permalink/how-test-driven-development-works-and-more
[shameless]: http://pawelduda.blogspot.co.uk/2014/06/practical-object-oriented-design-in.html
[sandi]: https://twitter.com/sandimetz
