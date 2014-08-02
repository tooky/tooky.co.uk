---
title: 'Follow the Messages'
# date: TBD When publishing
tags:
---

Yesterday I saw a post by [Eric Roberts][ericroberts] on the [Ruby
Rogues][rogues] [Parley][parley] forum that highlights something I find
interesting when working with an object oriented language.

Eric has a `Percentage` class that he is using to represent percentages, he
wants to be able to use instances of the `Percentage` class in numeric maths
operations.

```ruby
fifty_percent = Percent.new(50)

1 + fifty_percent  # => 1.5
10 - fifty_percent # => 5

20 * fifty_percent # => 10
20 / fifty_percent # => 40
```

Ruby provides an interface for using the standard numeric operators with objects
that are not `Numeric` types. If ruby does not now how to perform the operations
with an object it will send the `#coerce` message to the object asking it to
give it back something it can work with.

The interface here is that ruby expects back a pair of objects representing the
left and right-hand sides of the operation. Let's consider `+` for simplicity.

```ruby
class FakeNumber < Struct.new(:value)
end

3 + FakeNumber.new(4)

# TypeError: FakeNumber can't be coerced into Fixnum
# 	from (irb):4:in `+'
# 	from (irb):4
# 	from /opt/rubies/ruby-2.0.0-p247/bin/irb:12:in `<main>'
```

At this point we need to look at what our `Fixnum` does when it's asked to add
an object to itself &mdash; when we send it the `+` message with some object as
the argument.

```c
static VALUE
fix_plus(VALUE x, VALUE y)
{
  if (FIXNUM_P(y)) {
    long a, b, c;
    VALUE r;

    a = FIX2LONG(x);
    b = FIX2LONG(y);
    c = a + b;
    r = LONG2NUM(c);

    return r;
  }
  else if (RB_TYPE_P(y, T_BIGNUM)) {
    return rb_big_plus(y, x);
  }
  else if (RB_TYPE_P(y, T_FLOAT)) {
    return DBL2NUM((double)FIX2LONG(x) + RFLOAT_VALUE(y));
  }
  else {
    return rb_num_coerce_bin(x, y, '+');
  }
}
```

The important part here is the else condition. Ruby is checking if the value
passed is a number that know's how to deal with (`Fixnum`, `Float`, `Bignum`) 


```ruby
def coerce other
  method = caller[0].match("`(.+)'")[1].to_sym

  case other
  when Numeric
    case method
    when :+
      [to_f * other, other]
    when :-
      [other, to_f * other]
    else
      [other, to_f]
    end
  else
    fail TypeError, "#{self.class} can't be coerced into #{other.class}"
  end
end
```
