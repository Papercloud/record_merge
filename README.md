# RecordMerge
Easily merge ActiveRecords in the database, copies over attributes and relations with smart and configurable options.

###Install
```ruby
gem 'record_merge'
```

###Usage


```ruby
RecordMerge.merge(destination, source, options)
```
**Options**

Attribute | Default | Description | Example
--- | --- | --- | ---
`attributes`|`[]`| *Which of the sources attributes to copy over* | `[:name, :email]`
`copy_all_relations`| `true`| *Copies all relations unless `only` or `except` specified * |
`only`| `[]`| *Only the specified relations* | `only: [:invoices]`
`except`| `[]` | *All relations except these specified*| `except: [:comments]`
`delete_source` | `true`| *Delete the source object on complete*
**Example**
```ruby
RecordMerge.merge(destination, source, attributes: [:name, :email], only: [:invoices, :comments], delete_source: false)
```
**Exception Handling**
`RecordMerge.merge` will throw a `ActiveRecord::RecordInvalid` exception if the `destroy!` or `save!` fail for any reason. So you need to make sure to catch this exception.
