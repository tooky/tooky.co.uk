---
:title: Delegation is not inheritance
:author: tooky
:tags:
- oo
- ruby

---
On the train home last night I watched the excellent [Jim Weirich Play-by-play](https://peepcode.com/products/play-by-play-jimweirich-ruby) from [PeepCode](https://peepcode.com/).

During the screencast Jim develops a library that "protects against unauthorized data model modification by users in less-privileged roles." The screencast provides a great insight into the way Jim approaches problems, designs apis, and how he's customised his environment to suit the way he works.

His approach is to build a proxy object which wraps the object to be updated, and provides a whitelist for fields which can be updated. He also inadvertantly demonstrates an easy mistake to make when using proxy objects.

Here is a simplified version of Jim's solution -  without any of the api for creating / finding proxies - which we will use to demonstrate this pitfall and its effects.

```ruby
require 'delegate'
class ProtectionProxy < SimpleDelegator
  def initialize(object, *writable_fields)
    super(object)
    @writable_fields = writable_fields
  end
 
  def method_missing(method, *args, &block)
    method_name = method.to_s
    if !method_name.end_with?('=')
      super
    elsif @writable_fields.include?(method_name[0...-1].to_sym)
      super
    end
  end
end
```

This approach works great for silently dropping calls to the accessor methods that are not in the provided whitelist. Here are some rspec examples which show how it works.

```ruby
require 'rspec-given'
require 'protection_proxy'
 
class User < Struct.new(:name, :email, :membership_level)
end
 
describe ProtectionProxy do
  Given(:user) { User.new("Jim", "jim@somewhere", "Beginner") }
  Given(:proxy) { ProtectionProxy.new(user, :membership_level) }
 
  Then { proxy.name.should == "Jim" }
 
  context "when modifiying a writable field" do
    When { proxy.membership_level = "Advanced" }
    Then { proxy.membership_level.should == "Advanced" }
  end
 
  context "when modifiying a non-writable field" do
    When { proxy.name = "Joe" }
    Then { proxy.name.should == "Jim" }
  end
end
```

Now if we imagine we have a rails project, we can create a proxy to wrap our ActiveRecord object, and specify an attribute whitelist.  This should then prevent mass-assignment of any non-whitelist attributes - it could be used in a controller like this:

```ruby
class UserController < ActionController::Base
  def update
    user = User.find(params[:id])
    proxy = ProtectionProxy.new(user, :name, :email)
 
    if proxy.update_attributes(params[:user])
      # happy path
    else
      # error
    end
  end
end
```

Unfortunately this won't work as we might expect.

Proxying like this is a great way to add new behaviour to existing objects, without modifying them - or creating new subclasses. but there is one thing to be aware of when you are using delegation in this way.

Methods called on the wrapped object have **no** knowledge of the methods in the proxy object.

So what happens when we call `proxy.update_attributes`?

The proxy object immediately delegates that method call to the user object, it will call `user.update_attributes`.

If you have used ActiveRecord, you will be aware of the way that `ActiveRecord::Base#update_attrbiutes` will make use of the accessor methods on its instances to set the field names.

So, `user.update_attributes name: 'Joe'` will call `user.name = 'Joe'`, not the accessor methods on the proxy.

![update attributes sequence diagram](http://dl.dropbox.com/u/41915/update_attributes_sequence_diagram.png)

As we are not calling the accessor methods on the proxy, we aren't filtering out the fields that don't appear in the whitelist and our attribute protection won't work when we use `update_attributes`.

Here is another example. `Capitalise` wraps an object and provides a upper case version of its name method.

```ruby
require 'delegate'
class Capitalise < SimpleDelegator
  def initialize(source)
    @source = source
    super(source)
  end
 
  def name
    @source.name.upcase
  end
end
 
class Person < Struct.new(:name)
  def greet
    "Hello, #{name}"
  end
end
 
john = Person.new('john')
capital_john = Capitalise.new(john)
 
john.greet #=> "Hello, john"
capital_john.greet #=> "Hello, john"
```

Because `greet` is defined in the `Person` class, when it calls `name` it will always call `Person#name`.

This has caught me out a couple times. It's so easy in ruby to create proxy objects or decorators that its easy to forget that you have a different object.

One solution is to implement a version of `update_attributes` on the proxy object.

```ruby
class ProtectionProxy < SimpleDelegator
  def initialize(object, *writable_fields)
    super(object)
    @object = object
    @writable_fields = writable_fields
  end
 
  def update_attributes(attributes={})
    attrs = attributes.select { |field_name|
      @writable_fields.include?(field_name)
    }
    @object.update_attributes attrs
  end
end
```

Here we add an `update_attributes` method to the `ProtectionProxy` class - this only allows attributes allowed by the whitelist through to `User#update_attributes`.

The [screencast](https://peepcode.com/products/play-by-play-jimweirich-ruby) ends with a note that Jim noticed this error later after recording of the screen cast finished. Jim's complete solution, including the nice api, can be found on [github](https://github.com/jimweirich/protection_proxy).

[Here is the whole of the `ProxyProtection` implementation][gist], with rspec examples.

[gist]: https://gist.github.com/3294185.js
