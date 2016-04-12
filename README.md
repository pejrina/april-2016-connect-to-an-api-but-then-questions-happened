# An example during the Rails.MN April 2016 meetup

Tonight's talk started out being about using a 3rd party API from
inside your Rails app, and veered off in a thousand directions. I
think we got somewhere, even if it wasn't where I thought.

## Fog Uploader

I borrowed a tiny class from another Rails application that basically
does one thing: upload a file or stream to AWS S3 using the Fog gem.

The first question was "Where do you put this code?"

The answer, nominally, is the `lib/` directory in the Rails application root.

"What goes in lib?" -- stuff that is independent of your Rails app,
but is used by your Rails app.

The Fog Uploader is in `lib/fog_uploader.rb`.

## Models, Models, and more Models

The discussion took a tangent into more questions about where you put
stuff. The question I asked about where you'd put code that calls
the Fog Uploader generated answers of mostly models, controllers, and
helpers.

My general rule of thumb is that things that are logic, calculation,
transfer, translation, loading, saving, and so on are what are put in
models.

A controller should be kept skinny, and be used to
authenticate/authorize the user, gather and validate input, dispatch
action, and route output. That's really all.

Models are classes in the most Ruby sense of the term. A model class
is instantiated into an object that operates on the data given.

And finally helpers are bags of methods and functions that are generally used in controllers and views to help (tada!) with the presentation of information. Think of things like money formatting, inflectors, and so on. A quick example: suppose in a table you wanted zero and nil values to appear as `"--"`, you'd write a little function that would emit that instead:

```ruby
module ApplicationHelper
  def zero_dash(n)
    (n == 0 || n.nil?) ? "--" : n
  end
end
```

But let us go onward to discuss models:

## Persistence Objects

In Rails, the premier model type is a Persistence Object, i.e., it
deals with the creation, validation, updating, and destruction of data
over time.  These are the familiar ones we get with Rails' Active
Record.

The convention is to put these into the `app/models/` directory.

## Service Objects

Service objects are a specific sort of model, typically consisting of
an initialize method and an execution method, and do a specific sort
of action or procedure, often (but not always) using different models.

## Form Objects

A form object deals with the work of processing a form. These aren't
seen all that often in most applications, because a lot of this is the
conventional behaviour shared between a Model and it's
Controller. However, sometimes the work of gathering, vetting, and
processing data is not as straightforward as Rails' convention
dictates. Forms that can add and delete elements of information,
irregular nesting of information, data that comes from possibly
non-related or irregularly-related models, and so on.

Form objects are also particularly useful with the next sort of object: workflow objects.

## Workflow Objects

A workflow, or a process, is an acknowledgement that sometimes
operating on user input may require several steps. A classic workflow
is a shopping cart.

The cart proceeds through various stages during the checkout
process. Writing a workflow object in conjunction with a form object
keeps your code cleanly separate from the insides of your controllers
and persistence models.

## Models, Models, and more Models, redux

There can be many different types of objects in a Rails app, not just
the common set of controllers, models, and mailers are just a
departure point when you start to flesh things out in your app.

On the other hand, if you find yourself with something that does not
have a home, you might also be in a case where you should rethink
things.

## Inheritance vs Composition

Tonight, I also showed a couple of ways to use an API gateway object. (Oh, hey, look another model!)

In the WidgetUploader, which is a model, in this case a Service object
model, we could have chosen to either inherit the Fog Uploader library
object.  This would have given us the ability to configure, call, and
upload the PDF spec sheet for the widget.

But I think a better form of using the Fog Uploader is to pass it in
to the WidgetUploader, as in composition. Using composition gives the
consumers of the WidgetUploader, in turn, more options for
uploading. Assuming there is some amount of specialized work involved
in uploading the widget specification sheet, the uploading part of it
can be delegated to the composed uploader. This gives the freedom to
use a different service for uploading in the future. Also, for me, it
provides the best means to test the WidgetUploader by substituting in
a different uploading interface that is controlled by the test suite.

Your homework for this is to watch Sandi Metz's talk "Nothing is Something" (again!)

-------------------------------------------------------------------------------

I showed some code in a project I'm working on, I can't really include
that code in with this as it's proprietary (although it's nothing
special). There were a couple things about it worth mentioning though.

## Namespacing

If you saw, under `app/models/` I had created a directory
`order_processing/`. What wasn't necessarily apparent was another file
`app/models/order_processing.rb`. It's a simple file containing only a
few lines:

```ruby
module OrderProcessing
  def self.table_name_prefix
    'order_processing_'
  end
end
```

The module defines the name space `OrderProcessing`, which is used in
the models created in the `app/models/order_processing/` directory.

It also defines a class method inherited by all those models the
prepends `"order_processing_"` to the the front of all their table
names, so `OrderProcessing::Order`'s table name becomes
`"order_processing_orders"`. I use name spacing to organize major
application "concepts" together.

## Rails Autoloading

This is a hugely important Rails convention: autoloading is the thing
that let's you build up a whole bunch of classes without needing to
also do a bunch of `require` statements all over. The convention is,
in a nutshell, to match the CamelCase class / module name to the
snake_case file name. Be aware of this, as it's also a frequent source
of programmer errors.

-------------------------------------------------------------------------------

## Some links

* The Fog gem: <http://fog.io>
* "Nothing is Something", Sandi Metz's talk at RailsConf2015: <https://www.youtube.com/watch?v=OMPfEXIlTVE>
* Practical Object Oriented Design in Ruby, Sandi Metz's book: <http://www.poodr.com/>

## Thanks

I want to thank all who came tonight, your attention and questions are
*deeply* appreciated. I hope you had a good time and maybe left with
something to continue to ask questions about, learn, and explore.

Tamara Temple <tamouse@gmail.com>
