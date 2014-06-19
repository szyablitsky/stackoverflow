# StackOverflow clone

[![Build Status](https://travis-ci.org/szyablitsky/stackoverflow.svg?branch=master)](https://travis-ci.org/szyablitsky/stackoverflow)
[![Coverage Status](https://coveralls.io/repos/szyablitsky/stackoverflow/badge.png)](https://coveralls.io/r/szyablitsky/stackoverflow)
[![PullReview stats](https://www.pullreview.com/github/szyablitsky/stackoverflow/badges/master.svg?)](https://www.pullreview.com/github/szyablitsky/stackoverflow/reviews/master)
[![Code Climate](https://codeclimate.com/github/szyablitsky/stackoverflow.png)](https://codeclimate.com/github/szyablitsky/stackoverflow)
[![Dependency Status](https://gemnasium.com/szyablitsky/stackoverflow.svg)](https://gemnasium.com/szyablitsky/stackoverflow)
[![Stories in Ready](https://badge.waffle.io/szyablitsky/stackoverflow.png?label=ready&title=Ready)](https://waffle.io/szyablitsky/stackoverflow)

This is a demo of my skills as a Ruby on Rails developer. This app can be viewed in action at http://so-clone.herokuapp.com/

Some hilights of this project:

1. All user stories are delivered using BDD and can be seen in Issues.
2. Styles by Twitter Bootstrap.
3. Posting answers via AJAX with `.js.erb` views.
4. Posting comments via AJAX and JSON with jQuery handlers and Handlebars templates.
5. Comments propagation via Comet with [Private Pub][3] / [Faye][4].
5. Custom RSpec matcher for Rais `delegate`.
6. Tagging questions via [Select2][1] jQuery plugin.
7. Database query optimizations via `includes`, `counter_cache`, `connection.select_all`.
8. File uploads via [CarrierWave][2].
9. Service classes for multi-model use cases and other not related directly to model logic.
10. Models decoration with [Draper][5].
11. Light controllers with [Inherited Resources][6].
12. OAuth 2 authentication with Facebook and GitHub.
13. [Redcarpet][7] for markdown render.

by [Sergey Zyablitsky](http://finch.pro)

[1]: http://ivaynberg.github.io/select2/
[2]: https://github.com/carrierwaveuploader/carrierwave
[3]: https://github.com/ryanb/private_pub/
[4]: http://faye.jcoglan.com/
[5]: https://github.com/drapergem/draper
[6]: https://github.com/josevalim/inherited_resources
[7]: https://github.com/vmg/redcarpet
