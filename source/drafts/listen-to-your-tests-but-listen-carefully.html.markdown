---
title: 'Listen to your tests, but listen carefully.'
# date: TBD When publishing
tags:
  - ruby
  - tdd
  - design
---

I came across an interesting post by [Brandon Hilkert][brandon] looking at [the
differences between constructor and setter dependency injection][di-post]. It's
a great introduction to the differences between the two, and his example
illustrates them well. Please go and read it first.

Brandon's example gets started when he realises that the tests he wants to write
are difficult:

  > [A] thing that bothered me was the difficulty simulating different pricing
  > tiers and customer usage...What if I wanted to change the ceiling of that
  > tier next month? I'd have to come in here and adjust the stats being created
  > until it totalled something above the adjustment. It just felt weird..

He uses this as an example of how we can use dependency injection to use
different collaborators in tests so we get more control over the context our
objects are running in.

The solution he settles on is to use setter injection:

```ruby
module StripeEvent
  class InvoiceCreated
    attr_writer :usage_service
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def perform
      if user.created_at < 14.days.ago
        Stripe::InvoiceItem.create(
          customer: user.stripe_id,
          amount: additional_charges_in_cents,
          currency: "usd",
          description: "Usage charges"
        )
      end
    end

    private
    def additional_charges_in_cents
      Billing::Tier.new(usage).additional_charges_in_cents
    end

    def usage
      usage_service.last_30_days
    end

    def usage_service
      @usage_service ||= Billing::Usage.new(user)
    end

    def user
      @user ||= User.find_by(stripe_id: payload["data"]["object"]["customer"])
    end
  end

end
```

He's now able to take an initialized object and using the `attr_writer
:usage_service` he can swap in a stub implementation of the usage service and
tightly control what is returned. It allows him to ignor the _incidental detail_
of creating a `Stat`.

For me, though, this doesn't tackle the root problem. When tests are difficult to write
they are a great indicator that there's something about our design that we
should take another look at. Adding the setter method doesn't change the design
in any meaningful way, its just a crutch to help write tests.

Here's the sequence diagram for the original code:

![original sequence](https://dl.dropboxusercontent.com/u/41915/tooky-images/listening_to_tests_1.png)

Using the setter to inject a usage service shortcuts creating the usage service,
but is _only_ relevant in the tests &mdash; in normal usage the design is
_exactly_ the same.

![setter sequence](https://dl.dropboxusercontent.com/u/41915/tooky-images/listening_to_tests_2.png)

The tests were hinting that we had too many responsibilities, but this sequence
diagram really highlights this:

  * Retrieve a user
  * Get the users usage for the last 30 days
  * Get the billing tier for that usage
  * Create an invoice item for the billing tier amount

The last one is the most important. We want to create an additional invoice item
for the user, based on their usage in the last 30 days., and 
sequence diagram looked something like:

![extracted dependencies sequence](https://dl.dropboxusercontent.com/u/41915/tooky-images/listening_to_tests_3.png)

Based on this idea I changed the tests to focus the object on the responsibility
we care about:

```ruby
describe "creating an invoice" do
  before do
    @payload = {
      "data" => {
        "object" => {
          "customer" => "stripe_brandon"
        }
      }
    }
  end
  let(:billing_tier_service) { double(:billing_tier_service) }
  let(:level1) { double(:tier, :additional_charges_in_cents => 1900) }
  let(:level2) { double(:tier, :additional_charges_in_cents => 4900) }

  it 'adds invoice item based on usage' do
    allow(billing_tier_service).to receive(:last_30_days_for_stripe_id).
      with("stripe_brandon").and_return(level1)

    expect( Stripe::InvoiceItem ).to receive(:create).with(
      customer: "stripe_brandon",
      amount: 1900,
      currency: "usd",
      description: "Usage charges"
    )
    StripeEvent::InvoiceCreated.new(@payload, billing_tier_service).perform
  end

  it 'adds next level charge for usage' do
    allow(billing_tier_service).to receive(:last_30_days_for_stripe_id)
      .with("stripe_brandon").and_return(level2)

    expect( Stripe::InvoiceItem ).to receive(:create).with(
      customer: "stripe_brandon",
      amount: 4900,
      currency: "usd",
      description: "Usage charges"
    )
    StripeEvent::InvoiceCreated.new(@payload, billing_tier_service).perform
  end
end
```

We are injecting a new dependency, a `billing_tier_service`. We're imagining
that this dependency will take on the responsibility of giving us back the
correct billing tier for the customer that stripe has asked us for. Our tests
will just check we creating the InvoiceItem correctly, and the resulting code
is little simpler.

```ruby
module StripeEvent
  class InvoiceCreated
    attr_reader :payload
    attr_reader :billing_tier_service

    def initialize(payload, billing_tier_service = :some_sensible_default)
      @payload = payload
      @billing_tier_service = billing_tier_service
    end

    def perform
      Stripe::InvoiceItem.create(
        customer: stripe_id,
        amount: additional_charges_in_cents,
        currency: "usd",
        description: "Usage charges"
      )
    end

    private

    def additional_charges_in_cents
      tier = billing_tier_service.last_30_days_for_stripe_id(stripe_id)
      tier.additional_charges_in_cents
    end

    def stripe_id
      payload["data"]["object"]["customer"]
    end
  end
end
```

Obviously this leaves us with more work to do. We will still need to build the
`billing_tier_service`, to return the current tier for the customer. But this
should be simpler, and focus purely on which level is returned based on usage.

The trade-off is that we now have to deal with more objects in our system, but
each responsibility is in a single place, and our tests are isolated from
incidental changes in other parts of the system, e.g. changing the tier pricing.

Test driven development is about listening to your tests. When something is hard
to test it's usually a good indicator that you should change something in your
design. Use it as an opportunity to reevaluate design &mdash; and don't be
afraid of breaking out some boxes and arrows on the whiteboard.

[brandon]: https://twitter.com/brandonhilkert
[di-post]: http://brandonhilkert.com/blog/a-ruby-refactor-exploring-dependency-injection-options/
