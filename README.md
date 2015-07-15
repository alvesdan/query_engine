# QueryEngine

You can test if a hash matches a query:

```ruby
query = {
  '$or' => [
    { age: { '$gt' => 18 } },
    { role: { '$any' => ['Developer', 'Engineer'] } }
  ]
}

john = { age: 17, role: 'Student' }
jack = { age: 22, role: 'Developer' }
lisa = { age: 23, role: 'Marketing' }

QueryEngine::Matchable.matches?(john, query) #=> false
QueryEngine::Matchable.matches?(jack, query) #=> true
QueryEngine::Matchable.matches?(lisa, query) #=> true
```

Check out the specs for more examples.
