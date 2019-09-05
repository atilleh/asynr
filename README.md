# Asynr

[![Gem Version](https://badge.fury.io/rb/asynr.svg)](https://badge.fury.io/rb/asynr)

(This gem is a rebuild of a previous one located at the same Github repository).
\
Asynr is a gem to perform asynchronous tasks by evaluating directly classes and entrypoints.
This is highly inspired by Rufus-Scheduler.

## How it works ?

When you want to create a scheduler running several tasks separated by classes, you can instantiate Asynr and launch them asynchronously an easy way.
\
Asynr is based-upon Ruby threads and requires no dependency.
```ruby
# example
require "asynr"
Dir.glob(Dir.pwd + "/lib/*_class.rb").each &method(:require)

class Worker
  def self._start
    scheduler = Asynr.new
    scheduler.in 3, ARandomClass
    scheduler.every 3600, 2, AnotherClass, {entrypoint: :new}
    scheduler.at (Time.now + 10), AgainAnother, {arg1: :hello, arg2: :world}
  
    scheduler.start
  end
end
```

* We require asynr and all the files containing independant classes.
* We instantiate a new scheduler, which is gonna be empty
* We create .in, .every and .at jobs (read definitions)
* We start it

## launch a job in two days

```ruby 
secrets = File.read '/a/secret/path/secrets.txt'

scheduler = Asynr.new
scheduler.at (Time.now + (3600 * 24) * 2), BackupFiles, {password: secrets}
scheduler.start
```

In this example, we are using the arguments API of Asynr. It allows us to bind any value to any key when calling a .in, .every or .at method.


## launch a job every hour
```ruby
url = "https://acoolwebsitetoscrap.com"

scheduler = Asynr.new
scheduler.every 3600, 0, WebScrapper, {entrypoint: :new, url: url, save_to: "/tmp/scrapper"}
scheduler.start
```

We typically want to download a whole page every hour since it may change soon. This snippet allows you to send the url and the path where you want to save scrapped file.
\

### Entrypoint argument
Entrypoint is a quite special argument, since it allows you to select which class method is gonna be called by the class evaluator. `new` allows you to create objects, and the default value is `self._entrypoint`.

Here is what a default Asynr-compliante class may look like.
```ruby
class WebScrapper
  def self._entrypoint(*args)
    body = AnyHTTPLib.get(URI.parse(args[:url])).body
    f = File.open("%s/%s" % [args[:save_to], Time.now.strftime('%y-%m-%d')])
    f.puts body
    f.close
  end
end
```

## Launch a job in two minutes
```ruby
scheduler = Asynr.new
scheduler.in 120, PrintHelloWorld
```

This is a quite easy method to understand. Please mind you are free to put arguments at the end of this line or select another entrypoint than `_entrypoint`.

# Why an entrypoint ?
Ruby doesn't have any entrypoint function as main() could be one in Go, for example. This function is typically intended to provide a "entrypoint" where function-calls tree will be created and attached to. Since Ruby doesn't have it, without a entrypoint method, Asynr wouldn't be able to load and execute the class in a cool way.
\
I called this temporary main method `_entrypoint`. The `_` means it is special and it allows us to avoid common names mistakes. This method must be registred as `self` into a class to be called as it.

```ruby
class RandomTest ; def self._entrypoint(*args) ; end ; end
```

You can override this parameter (in order to create instance through .new method, for example) by adding a `{entrypoint: :any_method}` argument to .in, .every and .at methods.
\
Please note the `*args` method parameter. It allows us to bind any information comming from the scheduler to attach it into the entrypoint method.
\
Working example : 
```ruby
url = "https://rubygems.org"

scheduler = Asynr.new
scheduler.in 3, DisplaySomething, {text: url}

class DisplaySomething
  def self._entrypoint(*args)
    puts args[:text]
  end
end
```
