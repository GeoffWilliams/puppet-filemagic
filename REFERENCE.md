# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Resource types

* [`fm_append`](#fm_append): Append lines to a text file
* [`fm_gsub`](#fm_gsub): Global find and replace
* [`fm_prepend`](#fm_prepend): Prepend lines to a text file
* [`fm_replace`](#fm_replace): Replace one instance of /regex/ in a text file with `data` and remove all other instances.

## Resource types

### fm_append

Append lines to a text file

#### Properties

The following properties are available in the `fm_append` type.

##### `ensure`

Valid values: present, absent

Add or remove the requested lines from the file

Default value: present

#### Parameters

The following parameters are available in the `fm_append` type.

##### `path`

The file to operate on - you can only prepend once to any given file

##### `data`

Lines to add to the file - accepts string or array.  If \n present newlines will be inserted

##### `match_start`

If specified, remove the line matching this regexp and all subsequent lines, then append `data`

Default value: `false`

##### `flags`

Regexp flags

### fm_gsub

Global find and replace

#### Properties

The following properties are available in the `fm_gsub` type.

##### `ensure`

Valid values: present, absent

replace or delete the requested regexp from the file

Default value: present

#### Parameters

The following parameters are available in the `fm_gsub` type.

##### `path`

The file to operate on - you can only prepend once to any given file

##### `data`

replacement data for matches. If \n present newlines will be inserted

##### `match`

Target regexp to search for

Default value: `false`

##### `flags`

Regexp flags

### fm_prepend

Prepend lines to a text file

#### Properties

The following properties are available in the `fm_prepend` type.

##### `ensure`

Valid values: present, absent

Add or remove the requested lines from the file

Default value: present

#### Parameters

The following parameters are available in the `fm_prepend` type.

##### `path`

The file to operate on - you can only prepend once to any given file

##### `data`

Lines to add to the file - accepts string or array.  If \n present newlines will be inserted

##### `match_end`

If specified, remove the line matching this regexp and all previous lines, then prepend `data`

Default value: `false`

##### `flags`

Regexp flags

### fm_replace

This works like a line-by-line find and replace. If there is nothing to replace then no change will
be made unless you specify `insert_if_missing`

#### Properties

The following properties are available in the `fm_replace` type.

##### `ensure`

Valid values: present, absent

Add or remove the requested lines from the file

Default value: present

#### Parameters

The following parameters are available in the `fm_replace` type.

##### `path`

The file to operate on - you can only prepend once to any given file

##### `data`

Lines to add to the file - accepts string or array.  If \n present newlines will be inserted

##### `match`

If specified, remove all instances of /match/, and insert one line `data` if ensure=>present

Default value: `false`

##### `flags`

Regexp flags

##### `insert_if_missing`

If `true`, always ensure that `data` is added to file, even if this involves inserting a new line instead of replacing a match

Default value: `false`

##### `insert_at`

If `insert_if_missing` true and we need to do an insert, where should the data be inserted?
options are `top`, `bottom` or line number

Default value: bottom

