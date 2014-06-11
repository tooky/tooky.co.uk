---
:title: Using charklock_holmes on Heroku
:tags:
- ruby
- heroku
- deploymnent
- charlock_holmes
- libicu
:date: 2014-06-11
---
[`charlock_holmes`][charlock_holmes] is a useful gem if you have to deal with
user supplied data which may come in a variety of text-encodings. Not only does
it enable you to detect the encoding of a string, but it also allows you to
transcode the string to a different encoding.

`charklock_holmes` uses [`libicu`][libicu] to deal with string encoding.

Unfortunately, the default [Heroku][heroku] buildpack for Ruby doesn't include
`libicu` which prevents bundler from being able to compile `charklock_holmes`
C-extension.

There have been a few attempts at solving this problem, most of which are
discussed over on [stack overflow][stack-libicu-heroku]. The [accepted
answer][accepted-bundle-icu] is a common solution, which relies on using
a version of the gem which includes a bundled version of `libicu`. While this
works, it does result in very slow build times both on heroku, and locally when
doing a bundle install.

[Another solution][use-custom-buildpack] uses a custom version of the ruby
buildpack which includes `libicu` &mdash; while this is a simple solution it
relies on the maintainer of that solution keeping it up to date with heroku's
ruby buildpack.

[My favourite solution][use-apt-solution] seems to move in the right direction,
it uses [`heroku-buildpack-multi`][buildpack-multi] and
[`heroku-buildpack-apt`][buildpack-apt] to install `libicu` using apt.
Unfortunately it uses a forked version of the `heroku-buildpack-apt` which
adds specific behaviour for `charlock_holmes` and where `bundler` can find the
version of `libicu` installed by `apt`.

My solution builds upon the previous solution, but rather than use a custom
version of the `heroku-buildpack-apt` I have added one more buildpack into the
mix &mdash; [`heroku-bundle-config`][heroku-bundle-config].

This buildpack allows you to configure your heroku bundler config in your
repository in the `.heroku-bundle` directory. During the build it will move this
directory to `.bundle`, and most importantly, make sure that all `/app` paths
point correctly to the temporary build directory.

I've created a [sample project][sample], that can be [deployed to heroku][app-on-heroku] – the only thing
you need to do is ensure that you have set the `BUILDPACK_URL` to
`https://github.com/ddollar/heroku-buildpack-multi.git`:

```
$ heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
```

When you push to heroku, this buildpack will check for a `.buildpacks` file,
which specify the different buildpacks you want to use:

```
https://github.com/ddollar/heroku-buildpack-apt
https://github.com/timolehto/heroku-bundle-config
https://github.com/heroku/heroku-buildpack-ruby
```

`heroku-buildpack-apt` will then check for an `Aptfile` and install the
specified packages:

```
libicu-dev
```

Finally, you need to configure you `.heroku-bundle/config` to make sure that
`bundler` can use your newly installed version of `libicu`:

```
---
BUNDLE_FROZEN: '1'
BUNDLE_PATH: vendor/bundle
BUNDLE_BIN: vendor/bundle/bin
BUNDLE_JOBS: 4
BUNDLE_WITHOUT: development:test
BUNDLE_DISABLE_SHARED_GEMS: '1'
BUNDLE_BUILD__CHARLOCK_HOLMES: --with-icu-lib=/app/.apt/usr/lib --with-icu-include=/app/.apt/usr/include
```

That should be all you need.

[charlock_holmes]: https://github.com/brianmario/charlock_holmes
[libicu]: http://site.icu-project.org
[heroku]: https://www.heroku.com
[stack-libicu-heroku]: http://stackoverflow.com/questions/18926574/how-to-install-charlock-holmes-dependency-libicu-dev-on-heroku
[accepted-bundle-icu]: http://stackoverflow.com/a/18926982/223996
[use-custom-buildpack]: http://stackoverflow.com/a/20507705/223996
[use-apt-solution]: http://stackoverflow.com/a/22662875/223996
[buildpack-multi]: https://github.com/ddollar/heroku-buildpack-multi
[buildpack-apt]: https://github.com/ddollar/heroku-buildpack-apt
[heroku-bundle-config]: https://github.com/timolehto/heroku-bundle-config
[sample]: https://github.com/tooky/heroku-charlock-holmes
[app-on-heroku]: http://heroku-charlock-holmes.herokuapp.com
