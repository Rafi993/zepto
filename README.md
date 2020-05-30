# zepto

Really tiny static site generator

## Usage

1. Install zepto

```
$ gem install zepto
```

1. Create **\_layout** for storing all layouts (with extension **.erb**)
1. Create folder **\_images** for storing all images (when you build all images will be optimized)
1. Place your favicon in the project root with name **favion.ico**
1. Run

```
$ zepto serve
```

to run the server locally

1. To build run

```
$ zepto build
```

By default zepto will look for 

## Customization

You can customize zepto using **zepto.json** in project root

You can specify the following options in **.json** in the project root
| key     | Description             | Value                                                               | Default Value   | Required |
|---------|-------------------------|---------------------------------------------------------------------|-----------------|----------|
| folders | Folders to include      | ```[{name: 'folder_name', layout: 'layout.erb', route: 'blog' }]``` | `[]`            | false    |
| ignore  | Files/Folders to ignore | Array of file paths relative to project root                        | `["README.md"]` | false    |
| images  | Location of images      | String                                                              | _images         | false    |
| layout  | Location of layouts     | String                                                              | _layout         | false    |
| offline | Add offline support     | Boolean                                                             | true            | false    |
| root    | Home page               | String                                                              | index.md        | false    |

## Pagewise customization

At the top of the page you can attributes between as follows

```
title: "Title of the page"
date: "Date"
layout: "blog.erb"
tags: ["blog", "ruby", "javascript"]
```

Attributes specified at the page level will overwride global attribudes.

1. **tags:** When you speficy a tag here the contents of the file are avaibale as a colleciton in your **layout.erb** file which you
can access as

```
  <ul>
    <% for | blog | in @collection.tags.blog %>
     <li><%=  blog.title %></li>
    <% end %>
  </ul>
```
1. **layout:** is used to speficy the layout file. Layout speficied here will override layout speficied global config
1. You can include whatever additional keys here that you need. They are exposed in the **layout.erb**