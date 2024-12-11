## Introduction to XPath

Xpath is a syntax that allows you to traverse an XML document. 

## Nodes

A "node" is a building block of the XML document. Think of it as any XML entity that can be accessed by XPath. Among its types are
- Elements
- Attributes
- Text
- Documents
- Comments
- Processing Instructions

## Step Operators

"Steps" are the segments of an XPath expression that together form the "path" to a node. Each step is indicated by a `/`.
For example,
```
address/addressline
```
returns all `addressline` elements that are nested directly inside `address` elements.

The `//` is a pass-through, allowing you to return nodes nested below the context node, at any level. For example,
```
dsc//c
```
returns all `c` elements (aka components) nested in the `dsc` element, at any nesting depth.

## Syntax

The general syntax of any step in an XPath expression is 
```
Axis::node_test[predicate]
```
For example:
```
ancestor::c[@level="series"]
```
i.e., "look for an ancestor of the current node that's called `c` and whose `level` attribute is set to 'series'".

The "axis" is the direction in which you're looking up, down, or sideways in the tree. For example, if you're looking one step up, i.e. from a nested node to the node that immediately contains it, you're on the parent axis. If you look farther than the immediately containing node, you're on the ancestor axis. And so on.

XPath has a verbose and a concise syntax. (Not everything can be expressed in the conside syntax.) Note that you can switch syntax within the same expression.

| Verbose | Concise | Example | Note |
| ---- | ---- | ---- | ---- |
| parent | .. | `addressline/../address` | Selects the parent of the current node |
| child | / |`address/addressline`| Selects all children of the current node |
| ancestor | | `ancestor::controlaccess` |  Selects all ancestors (parent, grandparent, etc.) of the current node |
| ancestor-or-self | | `c/ancestor-or-self::c` | Selects all ancestors (parent, grandparent, etc.) of the current node and the current node itself |
| descendant | | `descendant::c` | Selects all descendants (children, grandchildren, etc.) of the current node |
| descendant-or-self | // | `publicationstmt//*` | Selects all descendants (children, grandchildren, etc.) of the current node and the current node itself |
| attribute | @ |`publicationstmt/@id` Selects all attributes of the current node |
| following-sibling | | `following-sibling::container` | Selects all siblings after the current node |
| preceding-sibling | | `preceding-sibling::container` | Selects all siblings before the current node |
| following | | `following::c` | Selects everything in the document after the closing tag of the current node |
| preceding | | `preceding::c` | Selects all nodes that appear before the current node in the document, except ancestors, attribute nodes and namespace nodes |
| self | . | `address/./addressline` (same as `address/addressline`) | Selects the current node |


## Exercise

In the appendix XML file, try to predict what these return, then run them and check your assumptions:
- `//self::unittitle`
- `//c/descendant::container`
- `//container/ancestor::c`
- `//language/ancestor::langmaterial`

Time to write some yourself! 
- Return all `language` elements that are children of `langusage` elements.
- Return all `container` elements whose `type` attribute is set to "box".
- Return all `emph` elements whose ancestor is NOT a `did` element. (Hint: use `not()` for the negative.)

## Position Tests

Position tests allow you to return the `nth` node of a node set. They can be expressed as 
```
node[position()=n]```
or 
```
node[n]
```

For example, to get the first ancestor of a `unittitle` element, you could write
```
unittitle[1]
```

(NB that indices in XPath start at 1, not 0.)

The position can also be given as a function, e.g.
```
c[position()=last()
```

If you want to find the absolute first instance of a node, your expression before the predicate needs to be wrapped in parentheses. For example,
```
//c[1]
```
returns the first `c` relative to its context, e.g. the first c of each series etc., whereas

```
(//c)[1]
```
returns the first `c` in document order, i.e. the absolute first `c` of the document.


## The Order of Predicates Matters

This can be a subtle difference, and a big gotcha! For example:

```
c[1][@level='file']
```
matches if the first child `c` of the context node satisfies the condition `@level='file'`
	
```
c[@level='file'][1]
```
matches the first child `c` of the context node that satisfies the condition `@level='file'`

## Namespaces

Namespaces are a mechanism to distinguish nodes from different XML schemata, for example a Dublin Core `subject` from an EAD `subject`. (You can think of them as family names, which allow us to tell apart e.g. John Smith from John Meyer.)

Namespaces are declared at the root of an XML element, e.g.
```
<metadata
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/">
```
They may be declared with or without a prefix (an example of a namespace prefix is e.g. the `:xsi` following the `xmlns` namespace attribute that declares the namespace url). 

Nodes that have been declared with a namespace and prefix can be referenced in an XPath expression by using the namespace prefix followed by a colong, like so:
```
dc:title
```

## XPath in Ruby

To use XPath with Ruby, you can use the Nokogiri gem.

Require Nokogiri:
```
require 'nokogiri'
```

Parse file as XML document:
```
Nokogiri::XML(file)
```

Traverse the XML, e.g. a MARC-XML:
```
file..at_xpath('//marc:controlfield[@tag="008"]')
```

## Resources
- [Nokogiri](Nokogiri)
- [W3 XPath Tutorial](https://www.w3schools.com/xml/xpath_intro.asp)
