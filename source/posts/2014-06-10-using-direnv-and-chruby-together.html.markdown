---
:title: Using `direnv` and `chruby` together
:tags:
- ruby
- environment
- dev
:date: 2014-06-10
---
I've been using [`chruby`][chruby] to manage my ruby versions for a few
months &mdash; I like it's lightweight approach.

A combination of [bundler's][bundler] [binstubs][binstubs], the introduction
of rails 4 introducing the `bin` directory and trying to [use the
environment to configure my apps][12factor] has meant I wanted a way to
to manage my environment on a per project basis.

I've tried using [dotenv][dotenv], which works well for ruby projects, and for
setting environment variables to be used by your app &mdash; but, as far as
I can tell, it doesn't actually modify your environment. So setting your `PATH`
to select the correct binary, e.g. `bin/rails` in a rails app, won't work.

Enter [`direnv`][direnv]. `direnv` looks for a `.envrc` file in a directory and
loads any thing there into your environment. You have to specifically allow
direnv to load a file, and it tracks modifications to the file. It's very nice.

Unfortunately, I had a problem using it alongside `chruby` &mdash; everytime
I entered a directory `direnv` would do it's thing and then `chruby` would
follow suit, and I could never quite get the result I wanted! For example, I'd
have the right version of ruby, but the wrong `PATH` &mdash or the right `PATH`
with the wrong ruby.

To fix this I removed `chruby`'s auto switching feature from my default
environment, and based on a suggestion [here][direnv#98] added a `use_ruby`
function to my `~/.direnvrc`:

```sh
source /usr/local/share/chruby/chruby.sh

# use ruby [version]
use_ruby() {
  local ver=$1
  if [[ -z $ver ]] && [[ -f .ruby-version ]]; then
    ver=$(cat .ruby-version)
  fi
  if [[ -z $ver ]]; then
    echo Unknown ruby version
    exit 1
  fi
  chruby $ver
}
```

This checks for a `.ruby-version` file, and, if it finds one, defers to `chruby`
to load the correct ruby environment.

I can now use this function in a project `.envrc` to load ruby before I modify
the path:

```sh
use_ruby
PATH_add bin
```

This seems to work really well. The only downside is that I don't have
autoswitching of ruby versions anymore &mdash; unless I decide that's what
I want, so I have to be explicit about that.

[chruby]: https://github.com/postmodern/chruby
[bundler]: http://bundler.io
[binstubs]: http://robots.thoughtbot.com/use-bundlers-binstubs
[12factor]: http://12factor.net
[dotenv]: https://github.com/bkeepers/dotenv
[direnv]: https://github.com/zimbatm/direnv
[direnv#98]: https://github.com/zimbatm/direnv/issues/98
